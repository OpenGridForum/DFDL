GWD-E  
OGF DFDL WG  
dfdl-wg@ogf.org  
2023-09-27

-----

# <p style="text-align: center;">Data Format Description Language (DFDL) v1.0<br/> Experience Document 9<br/><br/> String-as-XML Feature

-----

### Status of This Document

Grid Working Document (GWD)

### Copyright Notice

Copyright © Open Grid Forum 2023.  Some Rights Reserved. Distribution is unlimited.

### Abstract

This document provides experience information about an experiemental string-as-XML feature prototyped in Apache Daffodil.
It is intended to inform the design of a DFDL language feature for a future revision of the DFDL standard.

-----

## Examples


Here is the DFDL schema for data containing a string of XML.

```xsd
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



The stringAsXMLWrapper.xsd file used for validating the data as a combined XML document.

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

   ```
   <xs:element name="xmlString" type="xs:string" dfdlx:runtimeProperties="stringAsXml=true" />
   ```

   Then the validation schema should be changed to this:
```
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


```xsd

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

No additional security issues have been raised.

### Contributors

Michael J. Beckerle  
Owl Cyber Defense, LLC & Apache Software Foundation  
mbeckerle@apache.org

### Intellectual Property Statement
The OGF takes no position regarding the validity or scope of any intellectual property or other rights that might be claimed to pertain to the implementation or use of the technology described in this document or the extent to which any license under such rights might or might not be available; neither does it represent that it has made any effort to identify any such rights.  Copies of claims of rights made available for publication and any assurances of licenses to be made available, or the result of an attempt made to obtain a general license or permission for the use of such proprietary rights by implementers or users of this specification can be obtained from the OGF Secretariat.

The OGF invites any interested party to bring to its attention any copyrights, patents or patent applications, or other proprietary rights which may cover technology that may be required to practice this recommendation.  Please address the information to the OGF Executive Director.

### Disclaimer
This document and the information contained herein is provided on an “As Is” basis and the OGF disclaims all warranties, express or implied, including but not limited to any warranty that the use of the information herein will not infringe any rights or any implied warranties of merchantability or fitness for a particular purpose.

### Full Copyright Notice

Copyright (C) Open Grid Forum (2014-2018). Some Rights Reserved.

This document and translations of it may be copied and furnished to others, and derivative works that comment on or otherwise explain it or assist in its implementation may be prepared, copied, published and distributed, in whole or in part, without restriction of any kind, provided that the above copyright notice and this paragraph are included as references to the derived portions on all such copies and derivative works. The published OGF document from which such works are derived, however, may not be modified in any way, such as by removing the copyright notice or references to the OGF or other organizations, except as needed for the purpose of developing new or updated OGF documents in conformance with the procedures defined in the OGF Document Process, or as required to translate it into languages other than English. OGF, with the approval of its board, may remove this restriction for inclusion of OGF document content for the purpose of producing standards in cooperation with other international standards bodies.

The limited permissions granted above are perpetual and will not be revoked by the OGF or its successors or assignees.

### References

[DFDL] OGF DFDL 1.0 specification
http://www.ogf.org/documents/GFD.240.pdf/





