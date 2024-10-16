# OGF DFDL Working Group Call Agenda and Minutes 13 June 2024

### Meeting Time
11:00 - 12:00 EDT.US (UTC-4) 

### Attendees
* Mike Beckerle
* Steve Hanson
<!--
* Bradd Kadlecik
* Liam O'Neill
-->

### IPR statement
"I acknowledge that participation in this meeting is subject to the OGF Intellectual Property Policy"

### Meeting closed
12:15 EDT.US

### Next regular call (Normally, monthly on 2nd Thursday)

July meeting is cancelled.

Next meeting in August: 2024-08-08 @ 11:00 EDT.US(UTC-4)

## Agenda

1. Review of open action items (see dated comments below)

2. Proposed new action item: Convert DFDL spec to XML (from MS Word) as way to create the first 
   ISO formatted version, and get away from MS-Word. 

3. 

4. Administrivia
  a.  Proposed: remove "deferred actions" from the call agenda/minutes to github tickets as place to park them

## Minutes

1. several actions closed as there is nothing further to be done or decisions are finalized. See 
   closed actions list below. 
2. Ongoing actions: status updated in the action item below.
3. New action item and tracker added for Convert DFDL spec to XML and create ISO-formatted version.
4. New action item: review whether element properties can be expressed on complex types (as a 
   new feature for a future DFDL version)
4. New action item: consider non-XML syntax for DFDL 2.0 to make DFDL more attractive to 
   developers and communities not using XML. 
5. Two long-deferred actions closed. Inactive. 

## Actions

Next action: **344**

### Actions raised at this meeting

341 - Convert DFDL spec to XML and create ISO-formatted version

342 - complex types with element properties

343 - alternate non-XSD-based syntax for DFDL

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

| 338        | Pathological DFDL behavior (Non-linear)
|------------|---|
| 2024-02-07 | Created to address this issue. Bradd K mentioned that customers use the transformation capabilities of DFDL to create and populate structures that are different from the input format, and in unparsing to populate the output from structures that are different. So any solution to the pathological DFDL behavior problem can't prevent these kinds of transformations since users are depending on them. However, there is nothing that requires creation of non-linearly larger structures.
| 2024-03-14 | Briefly discussed. No concrete proposals yet.
| 2024-04-18 | No progress reported. 
| 2024-05-09 | No progress reported. Needs more research. 
| 2024-06-13 | No progress reported. 

| 340        | DFDL 2.0 feature priority 
|------------|---|
| 2024-05-09 | Action is to add "in use" labels to experimental features that are already being used/implemented, as a priority scheme. Also add labels for non-experimental things that are high-priority for any user community. 
| 2024-06-13 | The "in use" labels added. High-priority labels still TBD. 

| 341        | Convert DFDL spec to XML and create ISO formatted document
|------------|---|
| 2024-06-13 | Action created. Emails from Jim Melton (ISO SQL workgroup) and materials in email thread titled "Topic: Creating ISO document from XML source". 

| 342        | complex types with element properties
|------------|---|
| 2024-06-13 | Action created to consider this improvement to the DFDL language. This was in reaction to recent email threads on XSD Element References which are the only way to reuse complex elements with their DFDL properties currently. A way to do this that reuses the complex type is desirable. By keeping the properties on the complex type distinct from those of the model group of that type perhaps the previously feared drawbacks of properties on complex types can be avoided. Worth consideration for DFDL 2.0. 

| 343        | Simplified non-XSD syntax for DFDL 
|------------|---|
| 2024-06-13 | Action created. The world has moved on from XML/XSD and some developers who would otherwise be interested in DFDL are put-off by the XML/XSD complexities. A non-XML syntax, along with a simplification of language features should be considered as an available alternative for a future version of DFDL. 

### Closed actions

| 336         | ISO status: announcing this, branding requirements
|-------------|---|
| 2024-02-07  | Created action on when and how we announce the ISO status, what trademarks and branding we can/should use both in announcements and on our materials going forward. Bradd K. has upcoming TPF Users Group 2024 Conference in May and wants to be able to announce the ISO status there.
| 2024-03-14  | Mike did some investigation and did not find branding/promotion guidelines. Other PAS groups (OMG, w3c) have some process descriptions of how their standards are ISO standards and what the differences are. Suggest we can copy that notion. 
| 2024-04-18 | ISO page for DFDL updated to final 'published' status: https://www.iso.org/standard/87444.html. Need to verify that final ISO version has errors (from prior review draft) fixed. (Proof copy of ISO-spec is being uploaded)  BraddK to address IBM updates to reference ISO standard. MikeB to handle ASF references, wikipedia update, Owl Cyber references. 
| 2024-05-09 | From email threads: Verified that ISO version published has most errors fixed (just some bad table breaks left unfixed.) Noted on call that we need to update DFDL pages on OGF site to mention ISO status. 
| 2024-06-13 | Nothing else to do here. Closing.


| 337        | ISO Workgroup operations 
|------------|---|
| 2024-02-07 | Creaded action on how we change how we work going forward to interoperate properly with ISO. Alan Sill started an email thread, but has not received a response. 
| 2024-03-14 | No progress reported.
| 2024-04-18 | MikeB to contact SC 38 chair re: how to engage going forward.
| 2024-05-09 | Mike to try again. 
| 2024-06-13 | Mike contacted Bill Ash (SC 38). Circulated notes in email. May 20: Title: "Actions 336 and 337 was: Re: Action 337: ISO DFDL Workgroup Operation changes". No changes needed in our processes/procedures other than ISO formatted version of our document(s). Action closed. 

| 339        | Dynamic value for dfdl:extraEscapedCharacters
|------------|---|
| 2024-03-14 | Created action. Discussed this need. EDIFACT is motivating example. Example DFDL schemas on github site have the default escape characters listed in the dfdl:extraEscapedCharacters property, which seems like a mistake. Steve H. to investigate with IBM contacts. 
| 2024-04-18 | No progress reported. 
| 2024-05-09 | SMH reported on analysis of this - unclear why EDIFACT model has any extraEscapedCharacters - they seem unnecessary. Consistency with escape schemes and delimiters does require this to be a dynamic property. Decision needed as to Erratum in 1.0 or 1.1 or 2.0. 
| 2024-06-13 | Decided this is a future version feature. Tracker created https://github.com/OpenGridForum/DFDL/issues/60. Action closed. 

These deferred actions were also closed.

|    250     | Standardise on a single tdml format for DFDL tests (All) |
| ---------- | --- |
| 2014-02-05 | Steve has requested permission for IBM to view / use the Daffodil tdml files, as a precursor to trying to standardise on a common tdml format. Was formerly part of action 066. 
| 2014-02-18 | No further progress 
| 2014-03-11 | Mike and Steve discussing the best way to share and cooperate on tdml format.
| 2014-03-25 | Discussed the creation of an OGF document that will own and define a standardised tdml format. 
| 2014-04-11 | Proposal is for the OGF document to define a tdml format without Tresys or IBM copyright statement.
| 2014-04-15 | Draft document on Redmine
| 2014-05-06 | No further progress
| 2014-05-20 | Mark has read through the document. Particularly concerned with how namespaces are handled in the infoset. 
| 2014-06-17 | No further progress
| 2014-06-25 | Mike has added bit order capability as per action 233.
| 2014-12-09 | No further progress
| 2015-01-06 | Mike to resurrect this as Tresys would like to run their tdml suite against both Daffodil and IBM DFDL.
| 2015-02-10 | No further progress
| 2015-02-24 | Mike updating the Daffodil TDML test runner to handle unparser (ie, serializer) tests
| 2015-04-14 | No further progress
| 2015-04-28 | Tresys have enhanced their tdml runner to allow unparser tests and round-trip tests (parser->unparser->parser) as well as the new tutorial tag (see action 228)
| 2015-05-12 | Not discussed
| 2015-11-03 | No progress 
| 2016-01-05 | No progress. Needs more interoperability between implementations to be really useful.
| 2017-07-25 | No further progress
| 2017-10-03 | No further progress although forthcoming work to add packed/zoned numbers may force https://redmine.ogf.org/issues/339 progress
| 2017-12-11 | Expected to look at this in the next month or so
| 2018-09-04 | No further progress
| 2018-10-16 | Mike has started work on a TDML runner that can drive a pluggable DFDL implementation, in support of interoperability testing, including IBM DFDL.
| 2018-11-01 | Pluggable TDML runner working. On Github at https://github.com/OpenDFDL/ibmDFDLCrossTester. Schema resolution for IBM DFDL achieved using its schema resolver feature and pointing it at Daffodil's resolver. IBM DFDL sample uses mark() on its input stream but IBM believes this is not necessary.
| 2018-11-15 | IBM DFDL and Daffodil have dependencies on different releases of ICU. Forcing changes to the TDML runner to isolate the implementations under test.
| 2018-11-29 | Good progress on the TDML runner, see email from Mike. The ibmCrossTestRig is not part of Daffodil (because it links against IBM DFDL), but is open source Apache License v2, and is currently in review at https://github.com/OpenDFDL/ibmDFDLCrossTester/pull/1. Steve needs to talk to IBM legal to check this is ok as it currently modifies IBM DFDL sample code.
| 2019-01-10 | Daffodil have removed the modified IBM DFDL sample code. Steve to ask whether IBM can donate tests from the existing IBM DFDL test suite.
| 2019-02-07 | If permitted, the tests from IBM can be used to see how the IBM and Daffodil tdmls have diverged.
| 2019-04-05 | IBM are permitted to send Daffodil some example tdmls. Steve to send some to Mike for next call.
| 2019-05-31 | No progress
| 2019-06-27 | Steve has sent example TDML files to Mike, under the existing IBM Grant of Copyright agreement with Apache.
| 2019-07-11 | Daffodil to adapt their test runner so that it works with the IBM TDML file variant. Action can be closed when this is done.
| 2019-08-29 | No further progress
| 2019-10-17 | Noted that this action had its number accidentally swapped with 242 in October 2016. Renumbered back to 250.
| 2020-07-23 | No further progress
| 2020-09-03 | Nothing likely to happen for this action in medium term, so moving to deferred actions
| 2024-06-13 | Inactive. Closed. 

|    316     | Proposed new experimental feature 'User defined functions' (Mike) |
| ---------- | --- |
| 2020-01-09 | Version 2.5.0. of Daffodil will include this, needs writing up. Does XPath 2.0 provide for this?
| 2020-04-16 | Nothing in core XPath 2.0 that allows user-defined functions, that is left to XSL etc. A write-up is here: https://cwiki.apache.org/confluence/display/DAFFODIL/Proposal%3A+Feature+to+Support+User+Defined+Functions. Mike has an example where values need to be normalised for later comparison. Bradd has an example where floating point precision needs adjustment. Steve is concerned that DFDL is straying too far into the transformation layer, maybe "user-defined-functions-for-DFDL" should be a separate spec? 
| 2020-09-03 | No further progress. 
| 2020-09-17 | Nothing likely to happen for this action in medium term, so moving to deferred actions.
| 2024-06-13 | There is already a tracker for this issue. https://github.com/OpenGridForum/DFDL/issues/21. Will be tracked there and removed from these calls. 


### Deferred actions

* none
