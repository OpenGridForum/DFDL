# OGF DFDL Working Group Call Agenda and Minutes 14 Nov 2024

### Meeting Time
11:00 - 12:00 EST.US (UTC-5) 

### Attendees
* Mike Beckerle
* Liam O'Neill
* Steve Hanson
* Bradd Kadlecik


### IPR statement
"I acknowledge that participation in this meeting is subject to the OGF Intellectual Property Policy"

### Meeting closed
11:57 EST.US (UTC-5)

### Next regular call (Normally, monthly on 2nd Thursday)

12 Dec 2024 11:00 EST.US (UTC-5) 

## Agenda

1. Review & Approval of minutes from 2024-10-10 call
1. Discussion topic: prefixLengthType and prefixIncludesPrefixLength (from email thread)
2. Discussion topic: decimalSigned (from email thread)
2. Review of open action items (see dated comments below)
1. Any other business

## Minutes

* prefixLengthType - redistribute as email not received.
* decimalSigned - implementations need to check and report back on whether a decimalSigned="no" 
  xs:decimal is unparsing a negative value - is this error detected. Because this will dictate 
  whether specifying this requirement is a breaking change. Note that DFDL on IBM ZSeries does 
  not implement dfdl:decimalSigned="no", so can't have the issue. Daffodil and IBM DFDL need to 
  check. 
* decimalSigned property definition should use "signed number" and "unsigned number" terminology. 
  Create issue to track. 

* action items review: 
  * action 338 (Pathological DFDL behavior) to be closed, and recorded as a github
    issue, but there is no specific action to take to further this (it's a research topic).
  * action 341 to be moved to deferred
  * other actions - no progress 

## Actions

Next action: **344**

### Actions raised at this meeting

* none

### Current actions

|    322     | DFDL 2.0 candidate: Handle embedded XML and JSON in a natural way (Mike) |
| ---------- | --- |
| 2021-07-08 | This was something that was included in the first DFDL 1.0 spec drafts but dropped.
| 2021-10-14 | Mike has created GitHub issue https://github.com/OpenGridForum/DFDL/issues/27.
| 2022-02-24 | Create an experimental feature document
| 2022-07-14 | Waiting for prototype implementation
| 2022-08-11 | Apache Daffodil implementation in code review and being tested 
| 2022-10-06 | Will be in next Apache Daffodil release as an experimental feature
| 2022-11-03 | Needs evaluating over the next 6 months as its current implementation is not in a form that could be incorporated into DFDL spec. Also breaks the idiom that the DFDL schema is also an XML schema for the infoset, because DFDL schema says the embedded XML is just a string. 
| 2022-12-01 | Nothing likely to happen for this action in short term, so moving to deferred actions.
| 2023-06-22 | Reactivated this action. Mike Beckerle to write up Daffodil implementation as experimental feature document that we can then review. Mike suggests this feature will likely evolve from what Daffodil has implemented, but the current way it works in Daffodil will be worth analyzing. 
| 2024-01-11 | No progress reported. 
| 2024-02-07 | No progress reported.
| 2024-03-14 | No progress reported.
| 2024-04-18 | No progress reported. 
| 2024-05-09 | No progress reported. 
| 2024-06-13 | Mike opened PR with draft document describing Daffodil experience (to be Exp Doc 9). Discussion of some points. SMH raised issue of possible new lengthKind based on self-delimiting length of well-formed XML (or JSON). Also need clarification of what it means when a DFDL processor is validating, what this means for XML (or JSON) strings. These comments added to the pull request. Will be incorporated into the document.
| 2024-09-12 | No progress reported. Updates to the document per above have not been made yet. 
| 2024-10-10 | No progress reported. Updates to the document per above still pending. 
| 2024-11-14 | No progress reported. Ditto. 


| 340        | DFDL 2.0 feature priority 
|------------|---|
| 2024-05-09 | Action is to add "in use" labels to experimental features that are already being used/implemented, as a priority scheme. Also add labels for non-experimental things that are high-priority for any user community. 
| 2024-06-13 | The "in use" labels added. High-priority labels still TBD. 
| 2024-09-12 | No progress reported.
| 2024-10-10 | No progress on the "high priority" labels. Apache Daffodil project has created a new-feature request to implement the experimental offset/pointer (aka "indirection") feature (https://issues.apache.org/jira/browse/DAFFODIL-2941)
| 2024-11-14 | No progress reported. 
| 2024-11-14 | No progress reported.

| 342        | complex types with element properties
|------------|---|
| 2024-06-13 | Action created to consider this improvement to the DFDL language. This was in reaction to recent email threads on XSD Element References which are the only way to reuse complex elements with their DFDL properties currently. A way to do this that reuses the complex type is desirable. By keeping the properties on the complex type distinct from those of the model group of that type perhaps the previously feared drawbacks of properties on complex types can be avoided. Worth consideration for DFDL 2.0. 
| 2024-09-12 | No progress reported.
| 2024-10-10 | No progress reported.
| 2024-11-14 | No progress reported.


| 343        | Simplified non-XSD syntax for DFDL 
|------------|---|
| 2024-06-13 | Action created. The world has moved on from XML/XSD and some developers who would otherwise be interested in DFDL are put-off by the XML/XSD complexities. A non-XML syntax, along with a simplification of language features should be considered as an available alternative for a future version of DFDL. 
| 2024-09-12 | No progress reported.
| 2024-10-10 | Discussed this need. It was observed that ASN.1 ECN is such a notation. Non-XML data structures, format annotatinos. The annotations are not at all like DFDL, but the syntax supports those annotations, so this is at least a precedent for some sort of notation like this. 
| 2024-11-14 | No progress reported.


### Closed actions

| 338        | Pathological DFDL behavior (Non-linear)
|------------|---|
| 2024-02-07 | Created to address this issue. Bradd K mentioned that customers use the transformation capabilities of DFDL to create and populate structures that are different from the input format, and in unparsing to populate the output from structures that are different. So any solution to the pathological DFDL behavior problem can't prevent these kinds of transformations since users are depending on them. However, there is nothing that requires creation of non-linearly larger structures.
| 2024-03-14 | Briefly discussed. No concrete proposals yet.
| 2024-04-18 | No progress reported. 
| 2024-05-09 | No progress reported. Needs more research. 
| 2024-06-13 | No progress reported. 
| 2024-09-12 | No progress reported. 
| 2024-10-10 | No progress reported. Observation: this isn't stopping anyone from using DFDL successfully. 
| 2024-11-14 | Closed. See: https://github.com/OpenGridForum/DFDL/issues/63

### Deferred actions

| 341        | Convert DFDL spec to XML and create ISO formatted document
|------------|---|
| 2024-06-13 | Action created. Emails from Jim Melton (ISO SQL workgroup) and materials in email thread titled "Topic: Creating ISO document from XML source".
| 2024-09-12 | Discussed and conclusion from discussion is until a new version of the DFDL spec is needed, it seems there is not enough motivation to dig into this task.
| 2024-10-10 | Reviewed discussion. Consensus remains that this be deferred until a new version is needed.