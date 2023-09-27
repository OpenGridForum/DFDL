GWD-E  
OGF DFDL WG  
dfdl-wg@ogf.org  
2024-05-20

-----

# <p style="text-align: center;">Data Format Description Language (DFDL) v1.0<br/> Experience Document 9<br/><br/> String-as-XML Feature

-----

### Status of This Document

Grid Working Document (GWD)

### Copyright Notice

Copyright © Open Grid Forum 2024.  Some Rights Reserved. Distribution is unlimited.

### Abstract

This document provides experience information about an experimental String-as-XML feature 
prototyped in Apache Daffodil.
It is intended to inform the design of a DFDL language feature for a future revision of 
the DFDL standard.

-----

## Introduction

This document describes a feature of Apache Daffodil DFDL which is known by the term 
"String-as-XML". 
It is described for the Apache Daffodil project here: 
[Daffodil String-As-XML](https://cwiki.apache.org/confluence/display/DAFFODIL/Proposal%3A+Embedded+XML+Strings).

The rest of this document repeats some of that material for purposes of the OGF DFDL community 
consumption and commentary. 

## Motivation
It is not uncommon for data formats to embed other formats. 
In some cases, this embedded data is XML that must be modeled as an `xs:string`. 
For example, a small schema to describe data with a length field and an XML payload might look 
like this:
```xml
<element name="format">
  <complexType>
    <sequence>
      <element name="length" type="xs:int" dfdl:terminator="%NL;" />
      <element name="xmlPayload" type="xs:string" dfdl:lengthKind="explicit" dfdl:length="{ ../length }" />
    </sequence>
  </complexType>
</element>
```
Using this schema to parse this data:
```
52
<foo bar="baz">mixed content<qaz>complex</qaz></foo>
```
Would result in the following infoset:
```xml
<format>
  <length>52</length>
  <xmlPayload>&lt;foo bar=&quot;baz&quot;&gt;mixed content&lt;qaz&gt;complex&lt;/qaz&gt;&lt;/foo&gt;</xmlPayload>
</format>
```
Because the xmlPayload element contains XML characters that are included in the infoset as a simple 
xs:string type, the characters must be escaped. Not only is this field difficult to read and 
interpret, it is also difficult to validate against an XML Schema that describes the embedded XML.

This proposes a new feature to support handling XML data embedded in other data.

## Implementation
This feature makes use of the Apache Daffodil 
[Runtime Properties](
https://cwiki.apache.org/confluence/display/DAFFODIL/Proposal%3A+Runtime+Properties) DFDL extension.

Elements that should be treated as embedded XML should specify their type as "xs:string" and set 
the "stringAsXml" runtime property to true. For example, the above schema would be changed to this:
```xml
<element name="xmlPayload" type="xs:string" dfdlx:runtimeProperties="stringAsXml=true" ... />
```
Because the type is `xs:string`, these elements are parsed and unparsed using normal DFDL string
processing logic, with Daffodil's internal infoset containing the string value.

After the element has been parsed, when we project the internal infoset into an XML infoset,
elements with the `stringAsXml=true` runtime property perform the following:

The element that normally has simple text content is changed to one that has complex content
A complex child element with QName `stringAsXml` and define `xmlns=""` is added as a child to this 
complex element. 
Setting the default namespace to the empty string helps to avoid namespace conflicts between the 
infoset and the embedded XML in cases where the infoset defines a default namespace.
We check that the string is well-formed XML, parse it as XML, and add the resulting XML tree as a 
child to the `stringAsXml` complex element. This also performs normalization like removing 
DOCTYPE's, removing the XML declaration, translating XML escape characters, etc.
With the above schema modified to add the stringAsXml runtime property, the data now parses to this 
infoset:
```xml
<format>
  <length>52</length>
  <xmlPayload>
    <stringAsXml xmlns="">
      <foo bar="baz">mixed content<qaz>complex</qaz></foo>
    </stringAsXml>
  </xmlPayload>
</format>
```
Not only is this much easier to read, but it is also much easier to validate the xmlPayload using 
normal XML validation tools.

Note that this embedded XML need not obey the normal limitations of an DFDL infoset--it can contain 
any well-formed XML, including attributes, mixed content, comments, etc.

For unparsing, we do the reverse:

When projecting the incoming XML infoset to the internal Daffodil infoset, search for elements that 
have a runtime property of `stringAsXML="true"`.
For these elements, find the `stringAsXml` complex child element
Read the children of the `stringAsXml` element and serialize them to a string
Set that string to the value of the simple element in the internal infoset
We then unparse that element using normal string unparse logic.

## Known Limitations
### Normalization
Some XML strings may not be possible to round trip (parse then unparse) exactly. 
This is because projecting a string into an XML infoset will normalize or remove elements such as 
DOCTYPEs, XML declarations, escape characters, etc. 
When unparsing, these removed/modified elements are not be recoverable, or elements such as the XML 
declarations may always be added even if the original XML did not have one.
In addition, many aspects of XML will be canonicalized - for example, which quotes are used to 
create quoted attribute values. Canonical XML uses the `"` (double quote) character, but the 
parsed XML document may have used `'` (single quote or apostrophe). 
Unused namespace prefix declarations may be dropped, and namespace prefix definitions may be moved
to the root document element. 

### Validation
The DFDL schema can no longer be used to validate the resulting XML infoset. This is because the 
DFDL schema defines the embedded XML element as a simple xs:string, but when projected
into an XML infoset it becomes a complex element with complex content. 
Instead, a separate XSD must be created if validation of the resulting XML infoset is required. 
However, because the resulting XML is fairly limited and the algorithm well-defined, it is likely 
one could automate the creation of this alternative schema.

### DFDL Expressions
Because the translation from `xs:string` to XML is done when projecting between the internal and XML 
infosets, and Daffodil only sees the internal infoset, things like DFDL expressions have no access 
to the content of this XML. From the viewpoint of expressions, there is only the single embedded XML 
element and it is only a string.

### Backtracking
Because the translation from `xs:string` to XML is done when projecting between the internal and 
XML infosets, which may occur far after the element was parsed, there is no way to perform 
speculative parsing and backtrack if the field is not well-formed XML. 
Instead, an error is thrown during the projection which is treated as a SchemaDefinitionError. 
An additional mechanism is required to enable checking for well-formedness while parsing.

There are likely a number of potential solutions for this. One option could have a 
`dfdl:isWellFormedXML(xs:string)` function for evaluating in a discriminator applied to embedded XML 
elements. 
Alternatively, new properties could be added (e.g. `dfdl:textStringRep="xml"`)  which would behave 
just like normal xs:string processing but add a well-formed check immediately after parsing the 
content. Note that if we have a property like `dfdl:textStringRep="xml"`, that could possibly be 
used in place of the `stringAsXML` runtime property. 

There are likely other approaches that are worth consideration, and could potentially be extended to 
support additional embedded string types (e.g. JSON).

Note that by doing the translation into XML when projecting from the internal infoset to XML 
infoset, it means that each individual projection type can decide how best to handle elements that 
specify the `stringAsXml` runtime property. For example, if we project our internal infoset to JSON 
where XML isn't valid, then we can simply ignore the `stringAsXML` runtime property and treat is as 
a JSON string like usual. 
Or if we projected into an infoset of JDOM objects we could parse the embedded XML into a JDOM tree 
and add that to the JDOM infoset.

Note that whatever the mechanism, it is likely important to have separate mechanisms for checking if 
a string is well-formed versus projecting that data into an infoset. 
For example, one could imagine extending this capability to support embedded JSON strings. 
We may want the capability to validate that the field is well-formed JSON but still project it into 
an XML infoset where it would be treated as a simple xs:string. 
So while well-formedness checking and projecting to an infoset likely overlap in some implementation 
details, the two mechanisms are orthogonal--you may only want to do one or the other depending on 
the type of the embedded data and the infoset type.

### Non-Well-Formed XML

In the case where the XML String is not well-formed, then the Infoset Outputter which is creating 
XML could just escape the string for inclusion in XML, and output

```xml
<notWellFormedXML>...escaped string ...</notWellFormedXML>
```
This would then be well-formed, but the DFDL schema could arrange for this to always be invalid, as 
this element would be described by something like:
```xml
<element name="notWellFormedXML" maxOccurs="0" ...>
```
This use of `maxOccurs="0"` ensures that the element is always considered to be invalid. 

This could be a useful alternative to backtracking which could be implemented by the Infoset 
Outputter without a need for backtracking on malformed XML strings.

## Additional Commentary

### Implicit Length of XML/JSON Strings

The length of a well-formed XML/JSON string could be determined by parsing. 
The parse would terminate when a well-formed string of XML/JSON has been isolated. 
This could, perhaps, be overloaded on dfdl:lengthKind 'implicit', or a new dfdl:lengthKind
could be introduced. 
In this case, if the string data was not well-formed XML/JSON, then the parser would very likely 
fail, and this would have to be a processing error. 

### Validation Errors from Validating XML/JSON Parsing

A validating DFDL processor issues validation errors separately from processing errors and these 
are not processing errors and so do not guide the parser or cause backtracking. 

To be consistent with this, if a string of XML or JSON is being validated by a validating DFDL 
processor, the validation errors coming from the validating parser of the XML or JSON string 
would need to become DFDL Validation Errors, not processing errors. 

-----

## Appendix: Examples

Here is the Daffodil DFDL schema for data containing a string of XML.

```xml
<schema
  xmlns="http://www.w3.org/2001/XMLSchema" 
  xmlns:xs="http://www.w3.org/2001/XMLSchema" 
  xmlns:b="urn:bin"
  targetNamespace="urn:bin">

  <import namespace="urn:stringAsXml" schemaLocation="stringAsXmlWrapper.xsd" />

  <element name="binMessage">
    <complexType>
      <sequence>
        <element name="record" maxOccurs="unbounded">
          <complexType>
            <sequence>
              <element name="id" type="xs:int" />
              <!--
              The XMLTextInfosetOutputter converts this xmlStr element, which used to be a
              simple element with xs:string type, to a complex element. This complex element
              contains a "wrapper" element defined in the stringAsXmlWrapper.xsd schema file,
              which references the schema that defines the payload XML. See the
              stringAsXMLWrapper.xsd file for more information.
              -->
              <element name="xmlStr">
                <complexType>
                  <group xmlns:s="urn:stringAsXml" ref="s:stringAsXmlGroup" />
                </complexType>
              </element>
              <element name="priority" type="xs:int" />
            </sequence>
          </complexType>
        </element>
      </sequence>
    </complexType>
  </element>
  
</schema>
```

There are then two stringAsXMLWrapper.xsd files.
The first is for DFDL parse/unparse.

```xml 
<schema
  xmlns="http://www.w3.org/2001/XMLSchema"
  targetNamespace="urn:stringAsXml"
  elementFormDefault="unqualified">

  <import namespace="urn:payload" schemaLocation="xmlPayload.xsd" />

  <group name="stringAsXmlGroup">
    <sequence>
      <element name="xmlStr"
               dfdl:lengthKind="explicit" dfdl:length="{ ../strLen }"
               dfdlx:runtimeProperties="stringAsXml=true">
        <simpleType>
          <restriction base="xs:string">
            <maxLength value="0" />
          </restriction>
        </simpleType>
      </element>
    </sequence>
  </group>
  
</schema>
```

The stringAsXMLWrapper.xsd file is used for validating the data as a combined XML document.

When using the stringAsXml=true runtime property, the infoset no longer
validates against the DFDL schema. This is because what used to be a simple
element with type xs:string is now a complex element with an "xmlString" child
and a grand child depending on the payload XML.

To modify a DFDL schema into an XSD schema to validate a this kind of infoset,
the DFDL schema should have the following changes:

1. Import this file:

```xml 
<xs:import namespace="urn:stringAsXml" schemaLocation="stringAsXmlWrapper.xsd" />
```

2. Simple elements with `type="xs:string"` and `dfdlx:runtimeProperty="stringAsXml=true"`
   should be changed to a complex type referencing the group in this schema.
   For example, if the DFDl schema looks like this:

```xml
   <xs:element name="xmlString" type="xs:string" dfdlx:runtimeProperties="stringAsXml=true" />
```

   Then the validation schema should be changed to this:
```xml 
   <xs:element name="xmlString">
     <xs:complexType>
       <xs:group xmlns:s="urn:stringAsXml" ref="s:stringAsXmlGroup" />
     </xs:complexType>
   </xs:element>
```

3. Modify this file to import the payload schema and reference the correct root
   element represented by the xmlString string.

Note that the stringAsXml element will have no namespace associated with it,
and in the infoset will be output like this to ensure this is the case:

```
<stringAsXml xmlns="">...</stringAsXml>
```
This is necessary to reset the default XML namespace to ensure the default
namespace in the infoset (if defined) does not leak into the namespace of
the XML payload and prevent validation.

Using this approach, the payload schema can be used without modification to
validate XML embedded in data and subsequently embedded into the infoset.


```xml

<schema
  xmlns="http://www.w3.org/2001/XMLSchema"
  targetNamespace="urn:stringAsXml"
  elementFormDefault="unqualified">

  <import namespace="urn:payload" schemaLocation="xmlPayload.xsd" />

  <group name="stringAsXmlGroup">
    <sequence>
      <element name="stringAsXml">
        <complexType>
          <sequence>
            <element xmlns:p="urn:payload" ref="p:root" />
          </sequence>
        </complexType>
      </element>
    </sequence>
  </group>
  
</schema>

```

Here is a data file correspoinding to the above.
```xml
1
710
<?xml version="1.0" encoding='UTF-8'?>
  
<!DOCTYPE root [
  <!ENTITY name "Entity">
]>
  
<p:root   attr2="4"   xmlns:q='urn:payload' xmlns:p="urn:payload" attr1=' value '>
  <!-- commment -->
  <?processing instruction?>
  <field><![CDATA[Field ]]> with <![CDATA[cdata]]> </field> here is mixed content
  <field>spaces</field>    <field>   spaces   </field> and more mixed content
  <field /> and more mixed content
  <field></field>
  <field>entity references: &lt; &gt; &amp; &quot; &apos; &#169;</field>
  <field>CR</field>&#13;<field>LF</field>&#10;<field>CRLF</field>&#13;&#10;<field>end</field>
  <field>CR</field>
  <field>LF</field>
  <field>CRLF</field>
  <field>=invalid field</field>
</p:root>
  
5
2
71
<r:root xmlns:r="urn:payload">
  <field>second record</field>
</r:root>
1
␀
```

Here is the resulting infoset as XML. Notice how the DOCTYPE has been removed.

```xml
<?xml version="1.0" encoding="UTF-8"?>
 ...
    <xmlStr>
      <stringAsXml xmlns="">
<p:root   attr2="4"   xmlns:q='urn:payload' xmlns:p="urn:payload" attr1=' value '>
  <!-- commment -->
  <?processing instruction?>
  <field><![CDATA[Field ]]> with <![CDATA[cdata]]> </field>
  <field>spaces</field>    <field>   spaces   </field>
  <field />
  <field></field>
  <field>entity references: &lt; &gt; &amp; &quot; &apos; &#169;</field>
  <field>CR</field>&#13;<field>LF</field>&#10;<field>CRLF</field>&#13;&#10;<field>end</field>
  <field>CR</field>
  <field>LF</field>
  <field>CRLF</field>
  <field>=invalid field</field>
</p:root>
      </stringAsXml>
    </xmlStr>
   ...

```
-----
### Security Considerations

Any time XML parsing is used, there are some Denial-of-Services issues associated with the 
[Billion Laughs Attack](https://en.wikipedia.org/wiki/Billion_laughs_attack). 

The prototype implementation (for Daffodil) removes all DOCTYPEs/DTDs from the embedded strings 
of XML which eliminates this particular issue. 

### Contributors

Michael J. Beckerle  
Owl Cyber Defense, LLC & Apache Software Foundation  
mbeckerle@apache.org

### Intellectual Property Statement
The OGF takes no position regarding the validity or scope of any intellectual property or other 
rights that might be claimed to pertain to the implementation or use of the technology described 
in this document or the extent to which any license under such rights might or might not be 
available; neither does it represent that it has made any effort to identify any such rights.  
Copies of claims of rights made available for publication and any assurances of licenses to be made 
available, or the result of an attempt made to obtain a general license or permission for the use 
of such proprietary rights by implementers or users of this specification can be obtained from the 
OGF Secretariat.

The OGF invites any interested party to bring to its attention any copyrights, patents or patent 
applications, or other proprietary rights which may cover technology that may be required to 
practice this recommendation.  
Please address the information to the OGF Executive Director.

### Disclaimer
This document and the information contained herein is provided on an “As Is” basis and the OGF 
disclaims all warranties, express or implied, including but not limited to any warranty that the 
use of the information herein will not infringe any rights or any implied warranties of 
merchantability or fitness for a particular purpose.

### Full Copyright Notice

Copyright (C) Open Grid Forum (2024). Some Rights Reserved.

This document and translations of it may be copied and furnished to others, and derivative works 
that comment on or otherwise explain it or assist in its implementation may be prepared, copied, 
published and distributed, in whole or in part, without restriction of any kind, provided that the 
above copyright notice and this paragraph are included as references to the derived portions on all 
such copies and derivative works. 
The published OGF document from which such works are derived, however, may not be modified in any 
way, such as by removing the copyright notice or references to the OGF or other organizations, 
except as needed for the purpose of developing new or updated OGF documents in conformance with the 
procedures defined in the OGF Document Process, or as required to translate it into languages other 
than English. OGF, with the approval of its board, may remove this restriction for inclusion of OGF 
document content for the purpose of producing standards in cooperation with other international 
standards bodies.

The limited permissions granted above are perpetual and will not be revoked by the OGF or its 
successors or assignees.

### References

[DFDL] OGF DFDL 1.0 specification
http://www.ogf.org/documents/GFD.240.pdf/
