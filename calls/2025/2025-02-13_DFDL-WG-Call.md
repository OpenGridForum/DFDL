# OGF DFDL Working Group Call Agenda and Minutes 13 Feb 2025

### Meeting Time
11:00 - 12:00 EST.US (UTC-5)

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

12:00 EST.US (UTC-5)

### Next regular call (Normally, monthly on 2nd Thursday)

13 Mar 2025 11:00 EST.US (UTC-5)

## Agenda (with Minutes/notes added after the meeting)

1. Suggestion to withdraw https://github.com/OpenGridForum/DFDL/issues/15 (Experimental BLOB
   feature)

   Last call we discussed and recommended survey of Daffodil users. This was done.
   Mike Beckerle did a quick email survey of Daffodil users. Turns out this feature is used. (1
   user replied they are using it.) Based on this the "Suggestion to withdraw
   the experimental feature", is withdrawn.

1. Review of open action items (see dated comments below)

   Action item 345 to be converted into an issue ticket (By Steve H.)

1. Any other business

- Clarifying Discussions vs. Good Spec Index - As part of the discussion of Action item 345, the 
  idea was proposed that if the DFDL spec had 
  a comprehensive and well-constructed index, that this would reduce the need for these sorts of 
  detailed clarification discussions substantially. This raises the importance of the next 
  version of the DFDL specification having an index. We also discussed that an AI system like 
  chatgpt or other could help provide a high quality index since it's ability to read and 
  understand would allow it to distinguish part of the document discussing say, the 
  dfdl:representation property, from the general use of the term representation, which occurs 
  all over the DFDL specification in contexts where the dfdl:representation property is not the 
  context.  

- Simplify Discussion-to-Action-to-Issue process
  Mike proposed that we change our procedures. Currently we start an email thread 
  discussion first, then create an action item for these agendas, and then create github 
  issues, and that this is too many steps. 

  - Steve H. suggested that we just send an email pointing 
  out a new github issue where all the discussion happens. These agendas can then highlight any
  issues that need specific discussion on a call. 

  - A concern was discussed that both we and users need to be able to search the issue discussions 
  that come up, and that this is currently supported by web search engines being able to index the 
  OGF mailing lists. If we switch to github issues for all the discussion, only things that can 
  search github issues would be able to index them. 
  We determined that while general web search (by google anyway) does not index github issues, the 
  public search engine provided by github does let a user search github issues without being 
  logged in.
  (Also since github is Microsoft, perhaps their Bing search engine does index github content.)

  - Resolved: recreating Action 345 and it's prior email discussion as a github issue 
  
  - Email to the work-group is needed, as email list participants will not be notified about 
    discussion entries on issues unless they are subscribed to the OpenGridForum/DFDL project 
    notifications in their github accounts.  

- IBM Mainframe SMF Format - Steve H. reported investigating this format for a DFDL user. This 
  format has offsets in it (from start of record, not start of file) which makes it challenging 
  for DFDL v1.0. 

## Actions

We will be using Github issues going forward, not action items tracked in this agenda/minutes
document. 

Next action number: **346**

### Actions raised at this meeting

* none 

### Current actions

All actions converted into github issues for further tracking outside of this document where 
discussion is more readily captured and progress tracked. 

### Closed actions

Below is just closing out all "action items" but does not signify that all work is complete, only 
that we've moved the tracking of the work to github issues. 

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
| 2025-01-09 | No progress reported. Ditto. 
| 2025-02-13 | No progress reported. Closing - This action is github issue https://github.com/OpenGridForum/DFDL/issues/27, and will be tracked there.


| 340        | DFDL 2.0 feature priority 
|------------|---|
| 2024-05-09 | Action is to add "in use" labels to experimental features that are already being used/implemented, as a priority scheme. Also add labels for non-experimental things that are high-priority for any user community. 
| 2024-06-13 | The "in use" labels added. High-priority labels still TBD. 
| 2024-09-12 | No progress reported.
| 2024-10-10 | No progress on the "high priority" labels. Apache Daffodil project has created a new-feature request to implement the experimental offset/pointer (aka "indirection") feature (https://issues.apache.org/jira/browse/DAFFODIL-2941)
| 2024-11-14 | No progress reported. 
| 2024-11-14 | No progress reported.
| 2025-01-09 | Mike reports the "high priority" labeling is basically the same as "in use". Daffodil has 2 additional extensions that need to be considered for DFDL v2.0 - Mike has action to write these up. They are a dfdlx:lookAhead function (for which we created Action 344), and the "layering" extension (encoded regions within data and checksums/CRCs). The write ups will be what Daffodil has done now, as a start for workgroup discussion. 
| 2025-02-13 | Action closed - replaced by DFDL 2.0 feature priority https://github.com/OpenGridForum/DFDL/issues/73.



| 342        | complex types with element properties
|------------|---|
| 2024-06-13 | Action created to consider this improvement to the DFDL language. This was in reaction to recent email threads on XSD Element References which are the only way to reuse complex elements with their DFDL properties currently. A way to do this that reuses the complex type is desirable. By keeping the properties on the complex type distinct from those of the model group of that type perhaps the previously feared drawbacks of properties on complex types can be avoided. Worth consideration for DFDL 2.0. 
| 2024-09-12 | No progress reported.
| 2024-10-10 | No progress reported.
| 2024-11-14 | No progress reported.
| 2025-01-09 | No progress reported.
| 2025-02-13 | Action closed - replaced by issue https://github.com/OpenGridForum/DFDL/issues/71

| 343        | Simplified non-XSD syntax for DFDL 
|------------|---|
| 2024-06-13 | Action created. The world has moved on from XML/XSD and some developers who would otherwise be interested in DFDL are put-off by the XML/XSD complexities. A non-XML syntax, along with a simplification of language features should be considered as an available alternative for a future version of DFDL. 
| 2024-09-12 | No progress reported.
| 2024-10-10 | Discussed this need. It was observed that ASN.1 ECN is such a notation. Non-XML data structures, format annotatinos. The annotations are not at all like DFDL, but the syntax supports those annotations, so this is at least a precedent for some sort of notation like this. 
| 2024-11-14 | No progress reported.
| 2025-01-09 | No progress reported. 
| 2025-02-13 | Action closed - replaced by Issue https://github.com/OpenGridForum/DFDL/issues/70

| 344        | Clarification of lookahead extension/feature
|------------|---|
| 2025-01-09 | Action created. Daffodil has a dfdlx:lookAhead function. It is essential to many fixed-length data formats we process. Mike to create write up of existing Daffodil function as starting point for consideration. 
| 2025-02-13 | Action closed - Replaced by Issue https://github.com/OpenGridForum/DFDL/issues/69

| 345        | Clarification of evaluation order for asserts/discriminators
|------------|---|
| 2025-01-09 | Action created. We discussed the ongoing email thread topics. Steve H. analyzed the issue well. Conclusion was that we are missing a clarification about when an annotation point has multiple asserts and a single discriminator, but all of those have testKind='pattern'. The spec needs to say that the order of evaluation of asserts (whether testKind 'pattern' or 'expression') is 'Implementation Dependent'. The specific change is to this sentence in section 7.5.1 "However, within each group the order of execution among them is not specified." It should say "However, within each group the order of execution among them is not specified and is implementation dependent." That term specifically needs to be used.  
| 2025-02-13 | Action closed - Replaced by Issue https://github.com/OpenGridForum/DFDL/issues/67



### Deferred actions

This was also moved to a github issue and deferred actions will no longer be tracked in these 
meeting agendas/minutes. 

| 341        | Convert DFDL spec to XML and create ISO formatted document
|------------|---|
| 2024-06-13 | Action created. Emails from Jim Melton (ISO SQL workgroup) and materials in email thread titled "Topic: Creating ISO document from XML source".
| 2024-09-12 | Discussed and conclusion from discussion is until a new version of the DFDL spec is needed, it seems there is not enough motivation to dig into this task.
| 2024-10-10 | Reviewed discussion. Consensus remains that this be deferred until a new version is needed.
| 2025-02-13 | Action item 341 replace by github issue https://github.com/OpenGridForum/DFDL/issues/68
