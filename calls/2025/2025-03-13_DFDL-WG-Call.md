# OGF DFDL Working Group Call Agenda 13 March 2025

### Meeting Time
11:00 - 12:00 EDT.US (UTC-4)

### Attendees

* Mike Beckerle
* Steve Hanson
<!--
* Liam O'Neill
* Bradd Kadlecik
-->

### IPR statement
"I acknowledge that participation in this meeting is subject to the OGF Intellectual Property Policy"

### Meeting closed

11:55 EDT.US (UTC-4) 

### Next regular call (Normally, monthly on 2nd Thursday)

10 Apr 2025 11:00 EDT.US (UTC-4) 

## Minutes/Notes

Two items raised in email by SMH, motivated by work with a DFDL beginner working on IBM SMF format. 
The issues come up from using Apache Daffodil, where it behaves differently from IBM DFDL.

- use of an encoding when scanning hex binary data

We agreed that there are two bugs in Daffodil. If hexBinary data is parsed with 
dfdl:lengthKind 'delimited', but no delimiter is in scope, then no encoding should be required. 
Daffodil is currently requiring one, and furthermore insisting on it being iso-8859-1. 

Binary data can be delimited, and the encoding property in scope should be used, if delimiters 
are defined. 
The schema author is responsible for knowing that the delimiters, expressed as
characters, will not be found incorrectly within the content of the data. 

The workaround for this is simple. Adding `dfdl:encoding="iso-8859-1"` is easy and remains 
portable DFDL. 

- occursCountKind 'parsed' treating everything as an array

We reviewed the definition of array and optional in the DFDL spec, and there is no
mention of DFDL properties there.
Hence, expressions that end in an element name,
where that element declaration has minOccurs 0, maxOccurs 1, cannot require indexing 
in expressions. 
Furthermore, as parsing can place more than one element occurrence in the infoset, then 
when an expression that has no indexing, tries to access that element's value, it is a 
processing error. 

Apache daffodil currently deems any element with dfdl:occursCountKind 'parsed' to be an array
and requires that indexing is used to access it. 
This is not consistent with the definitions in the DFDL spec, nor other implementations.

Once again, the work around is easy and portable. Just add "[1]" indexing to these expressions, or
change the dfdl:occursCountKind to 'implicit' (the latter is the preferred change.)

Additionally we discussed the 'left over data' error. 
Recently email support threads have mentioned that if a schema has 
minOccurs="0" on an element for a record type, and a whole file of data is supposed
to consist of those records, then DFDL does not provide an easy way to declare
"It's a file format, and parsing is supposed to use up all the data."
One can express this with a simple pattern discriminator which just uses 
`testPattern="."` but beginners to DFDL run into this left-over-data error
yet discriminators are a somewhat advanced topic. 

The question was raised of if DFDL is missing a property allowing expressing
that a format is a "whole file" format, so it is intended to consume all the available data,
and it is a parse error if not. 
There is a precedent for other 'file' oriented properties such as 
`dfdl:finalTerminatorCanBeMissing`. 

We did not discuss a concrete proposal for any new property. 

1. Issue review (list of issues reviewed)

We did not review any specific items in depth. 

Mike emphasized the 'layers' feature item remains a high-priority extension
and that Daffodil does have documentation of the feature that needs
to be converted into a real experimental feature writeup. 

We noted that all the DFDL v1.0 erratum items are fairly small, and that OGF process for 
incorporating these in an updated version is fairly easy, and we did 
it once before. 

The greater challenge is updating the ISO specification, which is gated by the reformatting 
exercise. 

2. Any other business

None discussed.
