# Colour-coded bit diagrams, written as plain text with colour masks.
#
# A listing styled [bits] is a diagram exactly as it reads.  A line starting
# with ~ is a mask for the line above it: each character under a letter takes
# that letter's colour, and a space or . leaves it plain.  Mask lines are not
# shown.  The block declares what each letter means:
#
#   [bits,R=red,L=lime]
#   ----
#   Char NUUUUUUU IINNNNNN
#   ~    R        LLRRRRRR
#   ----
#
# A colour is one of the names in COLOURS, which are the shades the
# specification has always used, or a hex value such as #FF0000.  A mask
# letter the block doesn't declare is an error, so a typo can't silently drop
# a colour.
#
# The block becomes an ordinary listing with inline colour roles, which
# Metanorma renders in every output.  The Makefile loads this file with
# metanorma compile -r.

require "asciidoctor"
require "asciidoctor/extensions"

module DfdlBits
  COLOURS = {
    "blue" => "#0070C0",
    "cyan" => "#00B0F0",
    "darkred" => "#C00000",
    "green" => "#00B050",
    "lime" => "#92D050",
    "ochre" => "#BF8F00",
    "purple" => "#7030A0",
    "red" => "#FF0000",
    "yellow" => "#FFC000",
  }.freeze

  # Characters the listing's quotes substitution would read as formatting.
  ENTITIES = {
    "&" => "&amp;", "<" => "&lt;", ">" => "&gt;", "*" => "&#42;",
    "_" => "&#95;", "`" => "&#96;", "#" => "&#35;", "^" => "&#94;",
    "~" => "&#126;", "+" => "&#43;"
  }.freeze

  class Block < Asciidoctor::Extensions::BlockProcessor
    use_dsl
    named :bits
    on_context :listing
    parse_content_as :raw

    def process(parent, reader, attrs)
      palette = palette(attrs)
      out = []
      text = nil
      reader.lines.each do |line|
        if line.start_with?("~")
          raise "bits: a mask line must follow a diagram line" if text.nil?

          out[-1] = colour(text, " #{line[1..]}", palette)
          text = nil
        else
          text = line
          out << escape(line)
        end
      end
      create_block parent, :listing, out, { "style" => "source" }, subs: [:quotes]
    end

    def palette(attrs)
      attrs.each_with_object({}) do |(key, value), map|
        next unless key.is_a?(String) && key.match?(/\A[A-Za-z]\z/)

        hex = value.start_with?("#") ? value : COLOURS[value.downcase]
        raise "bits: unknown colour #{value.inspect} for #{key}" unless hex

        map[key.upcase] = hex
      end
    end

    def escape(text)
      text.gsub(/[&<>*_`#^~+]/, ENTITIES)
    end

    # Split a line into runs by mask letter and wrap each coloured run.  A
    # space between two runs of one colour stays inside the run.
    def colour(text, mask, palette)
      keys = Array.new(text.length) do |i|
        k = mask[i]
        k.nil? || k == " " || k == "." ? nil : k.upcase
      end
      keys.each_index do |i|
        next unless keys[i].nil? && text[i] == " "

        j = i
        j += 1 while j < text.length && keys[j].nil? && text[j] == " "
        left = i.positive? ? keys[i - 1] : nil
        (i...j).each { |k| keys[k] = left } if left && left == keys[j]
      end
      text.chars.zip(keys).chunk_while { |a, b| a[1] == b[1] }.map do |run|
        chunk = escape(run.map(&:first).join)
        key = run.first[1]
        next chunk unless key

        hex = palette.fetch(key) { raise "bits: mask letter #{key} has no colour" }
        "[css color:#{hex}]###{chunk}##"
      end.join
    end
  end
end

Asciidoctor::Extensions.register do
  block DfdlBits::Block
end
