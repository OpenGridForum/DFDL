# OGF DFDL Working Group Call Minutes 11-Aug-22

### Meeting Time
16:00-17:00 UK

### Attendees
* Steve Hanson
* Mike Beckerle

### Apologies
* 

### IPR statement
"I acknowledge that participation in this meeting is subject to the OGF Intellectual Property Policy"

### Meeting closed
16:45

### Next regular call
8th October 2022 @ 16:00 UK

## Agenda

1. Implementations Update
 
2. AOB

## Actions

Next action: **330**

### Actions raised at this meeting

### Current actions

| 289 | Unparsing: expression refers backwards to outputValueCalc which refers beyond it (Mike). | 
| -------- | -------|
| 2016-08-02 | Need to decide if this is allowed and if so if there are any restrictions. 
| 2016-09-13 | Motivating scenario is where a variable is being set to a length element using dfdl:setVariable,  which on unparse is set using dfdl:outputValueCalc. So although the variable is referring backwards to the length element, it is effectively forward referencing so must block. Mike believes this is unavoidable.
| 2016-10-11 | Daffodil has implemented this, Mike to provide scenario.
| 2016-08-11 | Mike couldn't find example, will continue to look
| 2017-01-10 | Mike has realised that all the examples were reworked to avoid using variables, hence why can't be found.
| 2017-02-07 | Daffodil will soon be implementing dfdl:newVariableInstance which will bring this up again.
| 2018-04-17 | Waiting for Daffodil to implement dfdl:newVariableInstance
| 2018-05-15 | Daffodil team have supplied an example of this from the PCAP schema. Likely to require a flag on newVariableInstance (or maybe variable declaration) to indicate whether needed on parse, unparse or both. 
| 2019-10-17 | No further progress 
| 2019-12-12 | Daffodil starting to implement dfdl:newVariableInstance
| 2020-04-16 | No further progress
| 2020-04-30 | Daffodil has implemented newVariableInstance so now in a position to look at this again.
| 2020-07-09 | No update -->
| 2020-07-23 | Daffodil has implemented newVariableInstance so Mike will look at this again
| 2020-09-03 | Daffodil team looking at this and related issues surrounding expression evaluation when unparsing.
| 2020-10-29 | No further progress
| 2020-11-12 | Mike has a scenario in the PCAP schema that uses several outputValueCalc. To simplify the expressions, he would like to use a variable with a value set by newVariableInstance. The problem is that the rules for variables are different from those for outputValueCalc, specifically variables can not refer forwards (because they are evaluated on both parse and unparse) whereas that is the point of outputValueCalc.  To ease this would require a change to the spec. WG agreed this is not necessary for DFDL 1.0 but a candidate for 2.0.
| 2020-12-10 | Daffodil to implement as as an experimental feature. Added to table below. GitHub issue https://github.com/OpenGridForum/DFDL/issues/22.
| 2021-01-07 | Daffodil have started prototype work on this.
| 2021-02-18 | Work continuing, but it looks like forward reference variables are needed as anticipated.
| 2021-03-18 | Daffodil has implementation of this nearly complete, which Mike will walk through on the next call.
| 2021-04-15 | Mike walked through examples of dfdl:newVariableInstance which refer forward and use 'dfdlx:direction=unparseOnly', using the PCAP schema. Will be part of the experience document. 
| 2021-07-08 | Material assembled for experience document.
| 2021-10-14 | Mike to write this up
| 2022-08-11 | Write up still in progress

| 322 | DFDL 2.0 candidate: Handle embedded XML and JSON in a natural way (Mike) |
| --- | --- |
| 2021-07-08 | This was something that was included in the first DFDL 1.0 spec drafts but dropped.
| 2021-10-14 | Mike has created GitHub issue https://github.com/OpenGridForum/DFDL/issues/27.
| 2022-02-24 | Create an experimental feature document
| 2022-07-14 | Waiting for prototype implementation
| 2022-08-11 | Apache Daffodil implementation in code review and being tested 

| 324 | Erratum: Clarify semantic of array element assert containing subexpression " .[1] " (All) |
| --- | --- |
| 2021-07-08 | Erratum needed to state that ".[1]" is equivalent to "../a[1]" and "../a[dfdl:occursIndex()]"
| 2021-10-14 | Mike has created GitHub issue https://github.com/OpenGridForum/DFDL/issues/26.
| 2022-02-24 | Mike to look back through emails for more information.
| 2022-08-11 | No further progress

| 325 | Submit OGF DFDL 1.0 to ISO for adoption as an ISO standard (Mike, Steve) |
| --- | --- |
| 2021-11-11 | Alan & Wolfgang attended the call. OGF is looking to re-home its successful standards to more relevant organisations. The proposal is that DFDL moves to ISO.  OGF has well-established connections with ISO, and Wolfgang is an attendee at working group meetings. There is a specific ISO process that lets them adopt a public, freely available standard whilst maintaining its public, free status. In contrast to ISO-owned standards which are chargeable. The public, free status continues to apply to ongoing revisions. DFDL feels like a good fit for ISO, noted that DFDL schemas exist for ISO 8583 and EDIFACT.  There is no need initially to change DFDL to use ISO templates, this can happen later. Noted that this is not a process for dumping old standards onto ISO, it applies to standards with an active community. The end result is that DFDL continues to evolve and be freely available but there are revisions that are effectively 'blessed' by ISO. An example of this in practice is Open Virtualization Format Specification from DMTF.  Adoption of a standard by ISO is ultimately determined by national body votes. Next steps: OGF will write to ISO-IEC JST1 with the proposal. DFDL WG will reach out to the chair of SC38 WG5 which is considered the most likely place DFDL will end up in ISO. The WG5 chair is Fernando Gebara Filho <fgebara@amazon.com>. DFDL WG to consider attending the appropriate ISO meetings. Useful links: ISO Process: https://www.iec.ch/members_experts/refdocs/iec/Consolidated_JTC1_Supplement_2020_publication.pdf, DMTF ANSI/ISO adoptions: https://www.dmtf.org/about/register/apresources. 
| 2022-02-24 | OGF are still working on the first step of the process, the application for OGF becoming a PAS submitter. They expect to submit the application letter begin of March. Once OGF will be a recognised PAS submitter there will be an assigned mentor who will guide through the next steps which mostly will have to be taken by the DFDL WG. Wolfgang sent an email with questions that the WG need to answer. Questions discussed and answers sent back to Wolfgang. 
| 2022-04-07 | Steve to chase OGF for latest position. 
| 2022-07-14 | From Wolfgang: "The process was a bit slower than foreseen, mostly because of holiday absence both on side the of OGF and JTC1. Regarding the application letter I am waiting for the confirmation from our guide that the last  version we have sent him on Monday is well suited for our official application as PAS submitter. If we have his confirmation OGF will officially send the application to JTC1. Thereafter it will subject to a voting of the national bodies which my take additional one or two months." Meantime in parallel Steve will contact the WG5 chair.
| 2022-08-11 | ISO have received the application from OGF for it to be allowed to be a PAS submitter. Steve has contacted the WG5 chair who is now following progress.

| 326 | Rules for when an assert or discriminator is used on a prefixLengthType simple type (All) |
| --- | --- |
| 2022-02-24 | Mike and Steve believe this is allowed but the meaning of relative path components need to be clarified. IBM DFDL does not support asserts on global simple types so unable to test if it works. Apache Daffodil ignores them. A good way to look at the prefixLengthType is as a quasi-element, so assert feels like it should be allowed. If so need to decide if the expression can use absolute paths, relative paths other than '.' and variables. 
| 2022-04-07 | Struggling to think of a use case where the expression is other than '.', meaning the quasi-element. This is a very restricted use, and suitable for an erratum on DFDL 1.0. Mike to write up. Aside: Steve wondered if validation could be used here instead. IBM DFDL has rich enough validation options that effectively make a validation failure behave like a parse error. Apache Daffodil does not though.
| 2022-07-14 | Mike has created a tracker https://github.com/OpenGridForum/DFDL/issues/29. Following from Steve's suggestion, can you use an assert with dfdl:checkConstraints('.') be applied to the type?
| 2022-08-11 | Mike has created a PR for the issue. Steve to review.

| 327 | Do we need a default dfdl:choiceDispatchKey branch? (Steve) |
| --- | --- |
| 2022-07-14 | To handle a nested choice use case where there is a need to distinguish a bad choice branch key from a good choice branch key that then fails to parse its branch. Steve to reproduce the use case to see if IBM DFDL has a similar problem.
| 2022-08-11 | IBM DFDL exhibits the same problem. Issue #34 raised. Discussed options for the syntax to indicate that a branch is the default, and agreed that dfdl:choiceBranckKey="" (empty string) works best. Could be an erratum on 1.0 but probably better as 2.0 candidate. 

| 329 | DFDL 2.0 candidate: Additional binary number reps (Mike) |
| --- | --- |
| 2022-07-14 | Apache Daffodil users are encountering a bunch of unsupported binary number formats. Apache Daffodil would like add support for these into DFDL 1.0 as an experimental feature ahead of DFDL 2.0. To do so requires action 328 to extend the experimental syntax to permit this. 
| 2022-08-11 | Apache Daffodil has also observed that the same is required for binary calendars, eg, unsigned binary seconds.

### Closed actions

| 328 | Extend experimental feature syntax to allow extra enums on existing properties (Mike) |
| --- | --- |
| 2022-07-14 | The experimental feature document does not cater for additional enums to existing properties. Action 329 is an example of where this would be useful.
| 2022-08-11 | Closed. Mike has updated the document, Steve has reviewed.

### Deferred actions

| 250 | Standardise on a single tdml format for DFDL tests (All) |
| --- | --- |
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

| 316 | Proposed new experimental feature 'User defined functions' (Mike) |
| --- | --- |
| 2020-01-09 | Version 2.5.0. of Daffodil will include this, needs writing up. Does XPath 2.0 provide for this?
| 2020-04-16 | Nothing in core XPath 2.0 that allows user-defined functions, that is left to XSL etc. A write-up is here: https://cwiki.apache.org/confluence/display/DAFFODIL/Proposal%3A+Feature+to+Support+User+Defined+Functions. Mike has an example where values need to be normalised for later comparison. Bradd has an example where floating point precision needs adjustment. Steve is concerned that DFDL is straying too far into the transformation layer, maybe "user-defined-functions-for-DFDL" should be a separate spec? 
| 2020-09-03 | No further progress. 
| 2020-09-17 | Nothing likely to happen for this action in medium term, so moving to deferred actions.


