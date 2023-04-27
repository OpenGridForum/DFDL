# OGF DFDL Working Group Call Agenda 27-Apr-2023

### Meeting Time
16:00-17:00 UK

### Attendees
* Steve Hanson
* Mike Beckerle
* Don Brutzman

### Apologies
* 

### IPR statement
"I acknowledge that participation in this meeting is subject to the OGF Intellectual Property Policy"

### Meeting closed


### Next regular call
11-May-2023 @ 16:00 UK

## Agenda

1. Implementations Update

Not discussed.

2. Asterix format

Mike showed an example of "All-purpose structured EUROCONTROL surveillance information exchange". It starts with a bitmap that indicates whether corresponding optional data fields exist. The bitmap has 3 parts, the 2nd & 3rd parts are optional and their existence is indicated by a bit at the end of the previous part. The existence bit is set if one of the corresponding data fields is present. Like ISO8583. Except that if a bitmap part is empty, it must not exist. This latter condition DFDL can't cope with. DFDL 2.0 candidate.

## Actions

Next action: **335**

### Actions raised at this meeting

### Current actions

|    325     | Submit OGF DFDL 1.0 to ISO for adoption as an ISO standard (Mike, Steve) |
| ---------- | --- |
| 2021-11-11 | Alan & Wolfgang attended the call. OGF is looking to re-home its successful standards to more relevant organisations. The proposal is that DFDL moves to ISO.  OGF has well-established connections with ISO, and Wolfgang is an attendee at working group meetings. There is a specific ISO process that lets them adopt a public, freely available standard whilst maintaining its public, free status. In contrast to ISO-owned standards which are chargeable. The public, free status continues to apply to ongoing revisions. DFDL feels like a good fit for ISO, noted that DFDL schemas exist for ISO 8583 and EDIFACT.  There is no need initially to change DFDL to use ISO templates, this can happen later. Noted that this is not a process for dumping old standards onto ISO, it applies to standards with an active community. The end result is that DFDL continues to evolve and be freely available but there are revisions that are effectively 'blessed' by ISO. An example of this in practice is Open Virtualization Format Specification from DMTF.  Adoption of a standard by ISO is ultimately determined by national body votes. Next steps: OGF will write to ISO-IEC JST1 with the proposal. DFDL WG will reach out to the chair of SC38 WG5 which is considered the most likely place DFDL will end up in ISO. The WG5 chair is Fernando Gebara Filho. DFDL WG to consider attending the appropriate ISO meetings. Useful links: ISO Process: https://www.iec.ch/members_experts/refdocs/iec/Consolidated_JTC1_Supplement_2020_publication.pdf, DMTF ANSI/ISO adoptions: https://www.dmtf.org/about/register/apresources. 
| 2022-02-24 | OGF are still working on the first step of the process, the application for OGF becoming a PAS submitter. They expect to submit the application letter begin of March. Once OGF will be a recognised PAS submitter there will be an assigned mentor who will guide through the next steps which mostly will have to be taken by the DFDL WG. Wolfgang sent an email with questions that the WG need to answer. Questions discussed and answers sent back to Wolfgang. 
| 2022-04-07 | Steve to chase OGF for latest position. 
| 2022-07-14 | From Wolfgang: "The process was a bit slower than foreseen, mostly because of holiday absence both on side the of OGF and JTC1. Regarding the application letter I am waiting for the confirmation from our guide that the last  version we have sent him on Monday is well suited for our official application as PAS submitter. If we have his confirmation OGF will officially send the application to JTC1. Thereafter it will subject to a voting of the national bodies which my take additional one or two months." Meantime in parallel Steve will contact the WG5 chair.
| 2022-08-11 | ISO have received the application from OGF for it to be allowed to be a PAS submitter. Steve has contacted the WG5 chair who is now following progress.
| 2022-10-06 | Application still in ISO pipeline. 
| 2022-11-03 | Expecting to hear by next WG call. 
| 2022-12-01 | Not heard anything yet. Steve to send chaser.
| 2023-01-05 | OGF accepted as a PAS submitter. Joined on the call by Alan Sill & Wolfgang Ziegler. Alan suggested DFDL WG joined the SC38 WG5 calls, introduced DFDL 1.0 to the group, and followed its suggestions as to how to proceed. Steve to approach WG5 chair Fernando Gebara Filho. Wolfgang reminded us that adoption of DFDL would be by national body vote, so making relevant national bodies like ANSI & BSI aware might be useful. Also need to make sure there is a free copy of the standard publicly available. Noted that there is already a good synergy with ISO standards because DFDL schemas exist for ISO standards EDIFACT and ISO8583.
| 2023-01-19 | The next SC38 Plenary Meeting is in Brisbane, AU from Feb 13 to 17, with remote access. On Thursday Feb 16, WG5 will meet to discuss the activities for the following months. Fernando suggested that we join the Zoom call. Steve to email Fernando nearer the time.
| 2023-02-02 | Steve has emailed Fernando. Suggest cancelling next DFDL WG call as it also on Feb 16th.
| 2023-03-02 | The anticipated WG5 call didn't happen, as we found out that the decision to adopt is taken at a higher level. Wolfgang has been in discussion with ISO and we have received documents including SD9 which explain next steps. Awaiting document templates before proceeding further. Agreed to hold separate bi-weekly calls to progress the ISO submission, starting 2023-03-09, so that the regular WG bi-weekly calls are not taken over by this action, Steve to send calendar invite. Mike to create a new folder in the DFDL GitHub repo specifically for the ISO submission.
| 2023-03-30 | Covered by updates to https://github.com/OpenGridForum/DFDL/blob/master/ISO-process/Call-Notes.md.
| 2023-04-13 | Mike posted first version of PAS Explanatory Report https://github.com/OpenGridForum/DFDL/pull/41. Steve, Alan, Wolfgang to review and fill in TBDs.
| 2023-04-27 | Review of PAS Explanatory Report https://github.com/OpenGridForum/DFDL/pull/41 in progress.


|    326     | Rules for when an assert or discriminator is used on a prefixLengthType simple type (All) |
| ---------- | --- |
| 2022-02-24 | Mike and Steve believe this is allowed but the meaning of relative path components need to be clarified. IBM DFDL does not support asserts on global simple types so unable to test if it works. Apache Daffodil ignores them. A good way to look at the prefixLengthType is as a quasi-element, so assert feels like it should be allowed. If so need to decide if the expression can use absolute paths, relative paths other than '.' and variables. 
| 2022-04-07 | Struggling to think of a use case where the expression is other than '.', meaning the quasi-element. This is a very restricted use, and suitable for an erratum on DFDL 1.0. Mike to write up. Aside: Steve wondered if validation could be used here instead. IBM DFDL has rich enough validation options that effectively make a validation failure behave like a parse error. Apache Daffodil does not though.
| 2022-07-14 | Mike has created a tracker https://github.com/OpenGridForum/DFDL/issues/29. Following from Steve's suggestion, can you use an assert with dfdl:checkConstraints('.') be applied to the type?
| 2022-08-11 | Mike has created a PR for the issue. Steve to review.
| 2022-10-06 | Awaiting review by Steve
| 2022-12-01 | No further progress
| 2023-01-05 | Steve has reviewed and updated the PR (https://github.com/OpenGridForum/DFDL/pull/33) with comments. Need to clarify the order of statement annotation and format annotation 'execution' when prefix and prefix-prefix present.
| 2023-01-19 | Mike to update PR #33 with a numbered example to make the annotation execution order clear.
| 2023-03-02 | Not discussed
| 2023-03-30 | Mike to update PR #33. Need to add a definition of 'synthetic element' too.
| 2023-04-13 | PR awaiting updates.
| 2023-04-27 | Mike has created an attachment to the issue for the numbered example, which was reviewed. However Mike is concerned that the suggested approach is not sufficient because asserts are not evaluated during unparsing. Mike also thinks the suggested approach is overkill as there is one very specific use case that does not require the full generality. So, is there a simpler approach? In passing, identified an undocumented corner case; it is a Processing Error if a prefix-prefix-length type evaluates to 0.

|    330     | Decide what to do about ICU's change to calendar strict parsing (Steve) |
| ---------- | --- |
| 2022-12-01 | In strict mode, ICU release 71.1 enforces the number of digits implied by a pattern. For example, on earlier ICU releases one could parse the data '1' with pattern D or DD or DDD and it would succeed. From ICU 71.1, just '1' will give an error for DD or DDD. Data '01' or '001' respectively must be supplied for it to parse. Applies to all numeric-only pattern symbols. Affects DFDL 1.0 spec section 13.11.2 bullet d), as we explicitly document this strict mode 'deviation'. ICU won't be reverting this so realistic options for DFDL 1.0 spec are: 1) Treat as a bug which has been fixed and raise erratum, 2) Request ICU to provide an undocumented flag to maintain the old behaviour. Note this ICU release has caused several IBM DFDL test cases to fail. They mostly look to be caused by this change, but Steve would like some time to understand all the failures before deciding what to do. 
| 2023-01-05 | Steve to talk to the engineer at IBM who is making the upgrade.
| 2023-01-19 | No further progress
| 2023-03-02 | Not discussed
| 2023-03-30 | IBM engineer has paused the upgrade but will looking at it again shortly. Need to decide on 1) or 2).
| 2023-04-13 | Agreed to go with option 1, as impact is believed to be minimal to existing users. Spec update needed, issue https://github.com/OpenGridForum/DFDL/issues/42 raised.
| 2023-04-27 | No progress.

|    334     | Agree wording for other errata that should be in ISO version of DFDL 1.0 spec (All)
| ---------- | --- |
| 2023-03-30 | There are some errata not covered by specific actions, namely #25, #31, #28. Need to agree words.
| 2023-04-13 | Steve to provide words for #25 (SDE if in-scope delimiter value clashes with an escapeCharacter or escapeEscapeCharacter value). #28 is minor typos. #31 is to correct xs:dateTime constructor args.
| 2023-04-27 | Steve has written some initial words and clarified the scope. Mike to review.

### Closed actions


### Deferred actions

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

|    316     | Proposed new experimental feature 'User defined functions' (Mike) |
| ---------- | --- |
| 2020-01-09 | Version 2.5.0. of Daffodil will include this, needs writing up. Does XPath 2.0 provide for this?
| 2020-04-16 | Nothing in core XPath 2.0 that allows user-defined functions, that is left to XSL etc. A write-up is here: https://cwiki.apache.org/confluence/display/DAFFODIL/Proposal%3A+Feature+to+Support+User+Defined+Functions. Mike has an example where values need to be normalised for later comparison. Bradd has an example where floating point precision needs adjustment. Steve is concerned that DFDL is straying too far into the transformation layer, maybe "user-defined-functions-for-DFDL" should be a separate spec? 
| 2020-09-03 | No further progress. 
| 2020-09-17 | Nothing likely to happen for this action in medium term, so moving to deferred actions.

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


