# BizTalk Server 2013: Wrapper classes to perform Unit Testing in Maps

## Introduction
Testing is an important aspect of (BizTalk) application life cycle. Before a developer deploys his solution he needs to be confident that it will perform, and do the task(s) it is intended to do. It is a developers responsibility that he creates a robust application. Therefore he needs to unit test his BizTalk application artifacts before he deploys them for further testing.

A BizTalk developer has a couple of options when it comes to unit testing BizTalk artifacts. Testing of each can be done using a framework like BizUnit, or some of the other available tools offered through CodePlex, or Visual Studio. With BizTalk Server 2009 the unit test feature was introduced, which offered built-in developer support for testing schemas, maps and pipelines in Visual Studio. The test capabilities offered by Visual Studio in for BizTalk artifacts are the following:
* Validating an XML document instance.
* Testing a map.
* Unit test a schema, map and/or a pipeline.

Unfortunately there is a bug in BizTalk Server 2013 with Map Unit Test inside Microsoft.BizTalk.TestTools.dll.
Microsoft had missed on to upgrade TestableMapBase class. They still using the BTSXslTransform instead of using XslCompiledTransform witch will cause the TestMap() function to failed.

You can find this wrapper (provide by  shadabanwer) here: https://shadabanwer.wordpress.com/2013/06/14/map-unit-test-does-not-work-in-biztalk-2013-because-testablemapbase-class-is-not-correct/

However there is a problem with schema (input and output) validation options... so I decide to recreated a new custom wrapper based on Microsoft.BizTalk.TestTools.dll and the solution provided by shadabanwer and fixed all the problems because validating the output instance generated by the map is an important step to validate your maps using Unit Testing.

You must use this workaround until Microsoft fix this bug.

# About Me
**Sandro Pereira** | [DevScope](http://www.devscope.net/) | MVP & MCTS BizTalk Server 2010 | [https://blog.sandro-pereira.com/](https://blog.sandro-pereira.com/) | [@sandro_asp](https://twitter.com/sandro_asp)