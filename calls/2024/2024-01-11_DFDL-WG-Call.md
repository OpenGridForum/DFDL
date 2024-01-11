# OGF DFDL Working Group Call Agenda and Minutes 11 January 2024

### Meeting Time
11:00 - 12:00 EDT.US (11:00-04:00)

### Attendees
* Mike Beckerle
<!--
* Bradd Kadlecik
* Liam O'Neill
* Steve Hanson
-->


### IPR statement
"I acknowledge that participation in this meeting is subject to the OGF Intellectual Property Policy"

### Meeting closed
XX:XX EDT.US

### Next regular call
2024-01-25 @ 11:00 EDT.US(UTC-4) (15:00 UTC)

## Agenda

1. Status of ISO JTC1 PAS application
2. Discuss: fn:count argument (from email list) 
2. Implementations Update 
2. AOB

## Actions

Next action: **335**

### Actions raised at this meeting

Action 322 had been deferred. Reactivated. 

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
| 2023-05-11 | No progress
| 2023-06-08 | PAS Explanatory Report submitted for preliminary review by friendly ISO member. Comments received and incorporated and report sent back. 
| 2023-06-22 | Nothing has been received back from ISO yet. 


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


