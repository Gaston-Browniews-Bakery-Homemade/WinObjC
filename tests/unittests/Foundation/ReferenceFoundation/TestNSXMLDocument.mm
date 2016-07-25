//******************************************************************************
//
// Copyright (c) 2016 Microsoft Corporation. All rights reserved.
//
// This code is licensed under the MIT License (MIT).
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//
//******************************************************************************
// This source file is part of the Swift.org open source project
//
// Copyright (c) 2014 - 2016 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See http://swift.org/LICENSE.txt for license information
// See http://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//

#import <Foundation/Foundation.h>
#import <TestFramework.h>
#import "TestUtils.h"

TEST(NSXMLDocument, BasicCreation) {
     NSXMLDocument* doc = [[NSXMLDocument alloc] initWithRootElement:nil];
     ASSERT_OBJCEQ(doc.version, @"1.0");
     doc.version = @"1.1";
     ASSERT_OBJCEQ(doc.version, @"1.1");

     NSXMLElement* node = [[NSXMLElement alloc] initWithName:@"Hello" URI:@"http://www.example.com"];
     
     [doc setRootElement:node];
      
     NSXMLElement* element = [doc rootElement];
     ASSERT_OBJCEQ(element, node);
 }

TEST(NSXMLDocument, NextPreviousNode) {
    NSXMLDocument* doc = [[NSXMLDocument alloc] initWithRootElement:nil];
    NSXMLElement* node = [[NSXMLElement alloc] initWithName:@"Hello" URI:@"http://www.example.com"];

    NSXMLElement* fooNode = [[NSXMLElement alloc] initWithName:@"Foo"];
    NSXMLElement* barNode = [[NSXMLElement alloc] initWithName:@"Bar"];
    NSXMLElement* bazNode = [[NSXMLElement alloc] initWithName:@"Baz"];

    [doc setRootElement:node];
    [node addChild:fooNode];
    [fooNode addChild:bazNode];
    [node addChild:barNode];

    ASSERT_OBJCEQ(doc.nextNode, node);
    ASSERT_OBJCEQ(doc.nextNode.nextNode, fooNode);
    ASSERT_OBJCEQ(doc.nextNode.nextNode.nextNode, bazNode);
    ASSERT_OBJCEQ(doc.nextNode.nextNode.nextNode.nextNode, barNode);
    
    ASSERT_OBJCEQ(barNode.previousNode, bazNode);
    ASSERT_OBJCEQ(barNode.previousNode.previousNode, fooNode);
    ASSERT_OBJCEQ(barNode.previousNode.previousNode.previousNode, node);
    ASSERT_OBJCEQ(barNode.previousNode.previousNode.previousNode.previousNode, doc);
}

TEST(NSXMLDocument, Xpath) {
    NSXMLDocument* doc = [[NSXMLDocument alloc] initWithRootElement:nil];
    NSXMLElement* foo =  [[NSXMLElement alloc] initWithName:@"foo"];
    NSXMLElement* bar1 = [[NSXMLElement alloc] initWithName:@"bar"];
    NSXMLElement* bar2 = [[NSXMLElement alloc] initWithName:@"bar"];
    NSXMLElement* bar3 = [[NSXMLElement alloc] initWithName:@"bar"];
    NSXMLElement* baz =  [[NSXMLElement alloc] initWithName:@"baz"];

    [doc setRootElement:foo];
    [foo addChild:bar1];
    [foo addChild:bar2];
    [foo addChild:bar3];
    [bar2 addChild:baz];

    // Swift unit test is different! Actual results vary from documented results on reference platform and ported swift test
    // reference platform produces real result below but documents the expected result as "foo/bar[2]/baz"
    ASSERT_OBJCEQ(baz.XPath, @"/foo[1]/bar[2]/baz[1]");

    NSXMLElement* baz2 = [[NSXMLElement alloc] initWithName:@"baz"];
    [bar2 addChild:baz2];

    ASSERT_OBJCEQ(baz.XPath, @"/foo[1]/bar[2]/baz[1]");

    // Below tests commented out as xpath evaluation is stubbed out. libxml needs updated.
    /*
    ASSERT_OBJCEQ([[doc nodesForXPath:baz.XPath error:nil] objectAtIndex:0], baz);

    NSArray* nodes = [doc nodesForXPath:@"foo/bar"];
    ASSERT_EQ([nodes count], 3);
    ASSERT_OBJCEQ([nodes objectAtIndex:0], bar1);
    ASSERT_OBJCEQ([nodes objectAtIndex:1], bar2);
    ASSERT_OBJCEQ([nodes objectAtIndex:2], bar3);
    */
}


TEST(NSXMLDocument, ElementCreation) {
    NSXMLElement* element = [[[NSXMLElement alloc] initWithName:@"test" stringValue:@"This is my value"] autorelease];
    ASSERT_OBJCEQ([element XMLString], @"<test>This is my value</test>");
    NSMutableArray* children = element.children;
    ASSERT_EQ([children count], 1);
    ASSERT_EQ([children count], element.childCount);
}


TEST(NSXMLDocument, ElementChildren) {
    NSXMLElement* element = [[[NSXMLElement alloc] initWithName:@"root"] autorelease];
    NSXMLElement* foo = [[[NSXMLElement alloc] initWithName: @"foo"] autorelease];
    NSXMLElement* bar = [[[NSXMLElement alloc] initWithName: @"bar"] autorelease];
    NSXMLElement* bar2 = (NSXMLElement*)[bar copy];

    [element addChild:foo];
    [element addChild:bar];
    [element addChild:bar2];

    ////ASSERT_OBJCEQ([element elementsForName:@"bar"], @[bar, bar2]);
    ASSERT_TRUE(!([[element elementsForName:@"foo"] containsObject:bar]));
    ASSERT_TRUE(!([[element elementsForName:@"foo"] containsObject:bar2]));

    NSXMLElement* baz = [[NSXMLElement alloc] initWithName:@"baz"];
    [element insertChild:baz atIndex:2];
    ASSERT_OBJCEQ(element.children[2], baz);

    [foo detach];
    [bar detach];

    [element insertChildren:@[foo, bar] atIndex:1];
    ASSERT_OBJCEQ([element.children objectAtIndex:1], foo);
    ASSERT_OBJCEQ([element.children objectAtIndex:2], bar);
    ASSERT_OBJCEQ([element.children objectAtIndex:0], baz);

    NSXMLElement* faz = [[NSXMLElement alloc] initWithName:@"faz"];
    [element replaceChildAtIndex:2 withNode:faz];
    ASSERT_OBJCEQ([element.children objectAtIndex:2], faz);
    [foo detach];
    [bar detach];
    [baz detach];
    [bar2 detach];
    [faz detach];

    ASSERT_TRUE([element.children count] == 0);

    [element setChildren:@[foo, bar, baz, bar2, faz]];
    ASSERT_TRUE([element.children count] == 5);
}

TEST(NSXMLDocument, StringValue) {
    NSXMLElement* element = [[[NSXMLElement alloc] initWithName:@"root"] autorelease];
    NSXMLElement* foo = [[[NSXMLElement alloc] initWithName:@"foo"] autorelease];
    [element addChild:foo];

    element.stringValue = @"Hello!<evil/>";
    ASSERT_OBJCEQ(element.XMLString, @"<root>Hello!&lt;evil/&gt;</root>");
    ASSERT_OBJCEQ(element.stringValue, @"Hello!<evil/>");

    element.stringValue = nil;

    //        NSXMLDocument* doc = [NSXMLDocument xMLDocumentWithRootElement:element]
    //        xmlCreateIntSubset(xmlDocPtr(doc._xmlNode), @"test.dtd", nil, nil)
    //        xmlAddDocEntity(xmlDocPtr(doc._xmlNode), @"author", int32_t(XML_INTERNAL_GENERAL_ENTITY.rawValue), nil, nil, @"Robert Thompson")
    //        NSXMLElement* author = [NSXMLElement xMLElementWithName:@"author"]
    //        [doc rootElement]?.addChild(author)
    //        [author setStringValue:@"&author;" resolvingEntities: true]
    //        ASSERT_OBJCEQ_MSG(author.stringValue, @"Robert Thompson", author.stringValue ?? @"")
}

TEST(NSXMLDocument, ObjectValue) {
    NSXMLElement* element = [[[NSXMLElement alloc] initWithName:@"root"] autorelease];
    NSDictionary* dict = @{@"hello" : @"world"};
    element.objectValue = dict;

    ASSERT_OBJCEQ(element.XMLString, @"<root>{\n    hello = world;\n}</root>");
}

TEST(NSXMLDocument, Attributes) {
    NSXMLElement* element = [[[NSXMLElement alloc] initWithName:@"root"] autorelease];
    NSXMLNode* attribute = (NSXMLNode*)[NSXMLNode attributeWithName:@"color" stringValue:@"#ff00ff"];
    [element addAttribute:attribute];
    ASSERT_OBJCEQ(element.XMLString, @"<root color=\"#ff00ff\"></root>");
    [element removeAttributeForName:@"color"];
    ASSERT_OBJCEQ(element.XMLString, @"<root></root>");

    [element addAttribute:attribute];

    NSXMLNode* otherAttribute = (NSXMLNode*)[NSXMLNode attributeWithName:@"foo" stringValue:@"bar"];
    [element addAttribute:otherAttribute];

    NSArray* attributes = element.attributes;

    ASSERT_EQ([attributes count], 2);
    ASSERT_OBJCEQ([attributes objectAtIndex:0], attribute);
    ASSERT_OBJCEQ([attributes objectAtIndex:1], otherAttribute);

    NSXMLNode* barAttribute = (NSXMLNode*)[NSXMLNode attributeWithName:@"bar" stringValue:@"buz"];
    NSXMLNode* bazAttribute = (NSXMLNode*)[NSXMLNode attributeWithName:@"baz" stringValue:@"fiz"];

    element.attributes = @[barAttribute, bazAttribute];
    ASSERT_EQ([element.attributes count], 2);
    ASSERT_OBJCEQ([element.attributes firstObject], barAttribute);
    ASSERT_OBJCEQ([element.attributes lastObject], bazAttribute);

    [element setAttributesWithDictionary:@{@"hello": @"world", @"foobar": @"buzbaz"}];
    ASSERT_OBJCEQ([element attributeForName:@"hello"].stringValue, @"world");
    ASSERT_OBJCEQ([element attributeForName:@"foobar"].stringValue, @"buzbaz");
}

TEST(NSXMLDocument, Comments) {
    NSXMLElement* element = [[[NSXMLElement alloc] initWithName:@"root"] autorelease];
    NSXMLNode* comment = (NSXMLNode*)[NSXMLNode commentWithStringValue:@"Here is a comment"];
    [element addChild:comment];
    ASSERT_OBJCEQ(element.XMLString, @"<root><!--Here is a comment--></root>");
}

TEST(NSXMLDocument, ProcessingInstruction) {
    NSXMLDocument* document = [[[NSXMLDocument alloc] initWithRootElement:[[[NSXMLElement alloc] initWithName:@"root"] autorelease]] autorelease];
    NSXMLNode* pi = (NSXMLNode*)[NSXMLNode processingInstructionWithName:@"xml-stylesheet" stringValue:@"type=\"text/css\" href=\"style.css\""];

    [document addChild:pi];

    ASSERT_OBJCEQ(pi.XMLString, @"<?xml-stylesheet type=\"text/css\" href=\"style.css\"?>");
}

//// Potential bug in parsing XML content. NSData returns original string + "ýýýý" resulting in failed parsing
////TEST(NSXMLDocument, ParseXMLString) {
////    NSString* string = @"<?xml version=\"1.0\" encoding=\"utf-8\"?><!DOCTYPE test.dtd [\n        <!ENTITY author \"Robert Thompson\">\n        ]><root><author>&author;</author></root>";
////
////    NSXMLDocument* doc = [[[NSXMLDocument alloc] initWithXMLString:string options:NSXMLNodeLoadExternalEntitiesNever error:nil] autorelease];
////    ASSERT_TRUE(doc.childCount == 1);
////    ASSERT_OBJCEQ([[[doc rootElement].children firstObject] stringValue], @"Robert Thompson");
////
////    NSURL* testdata = [testBundle() URLForResource:@"NSXMLDocumentTestData" withExtension:@"xml"];
////    if(!testdata) {
////        ASSERT_TRUE_MSG(false, "Could not find XML test data");
////    }
////
////    NSXMLDocument* newDoc = [[[NSXMLDocument alloc] initWithContentsOf:testdata options:0 error:nil] autorelease];
////    ASSERT_OBJCEQ([newDoc rootElement].name, @"root");
////    NSXMLElement* root = [newDoc rootElement];
////    NSArray* children = root.children;
////    ASSERT_OBJCEQ(((NSXMLNode*)[children objectAtIndex:0]).stringValue, @"Hello world");
////    ASSERT_OBJCEQ(((NSXMLNode*)[((NSXMLNode*)[children objectAtIndex:1]).children objectAtIndex:0]).stringValue, @"I'm here");
////    
////    [doc insertChild:[[[NSXMLElement alloc] initWithName:@"body"] atIndex:1]];
////    ASSERT_OBJCEQ(((NSXMLNode*)[doc.children objectAtIndex:1]).name, @"body");
////    ASSERT_OBJCEQ(((NSXMLNode*)[doc.children objectAtIndex:2]).name, @"root");
////}

TEST(NSXMLDocument, Prefixes) {
    NSXMLElement* element = [[[NSXMLElement alloc] initWithName:@"xml:root"] autorelease];
    ASSERT_OBJCEQ(element.prefix, @"xml");
    ASSERT_OBJCEQ(element.localName, @"root");
}

////TEST(NSXMLDocument, Validation_success) {
////    NSString* validString = @"<?xml version=\"1.0\" standalone=\"yes\"?><!DOCTYPE foo [ <!ELEMENT foo (#PCDATA)> ]><foo>Hello world</foo>";
////    NSError* err = [[[NSError alloc] init] autorelease];
////    try {
////        NSXMLDocument* doc = [NSXMLDocument alloc] initWithXMLString:validString options:0 error:err] autorelease];
////        [doc validateAndReturnError:err];
////    } catch (NSException e) {
////        ASSERT_TRUE(false);
////    }
////
////    NSString* plistDocString = @"<?xml version='1.0' encoding='utf-8'?><!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\"> <plist version='1.0'><dict><key>MyKey</key><string>Hello!</string></dict></plist>";
////    NSXMLDocument* plistDoc = [[[NSXMLDocument alloc] initWithXMLString:plistDocString options:0 error:err] autorelease];
////    try {
////        [doc validateAndReturnError:err];
////        ASSERT_OBJCEQ([plistDoc rootElement].name, @"plist");
////        NSPropertyListSerialization* plist = [NSPropertyListSerialization propertyListFromData:plistDoc.xmlData options:0 format:nil];
////        ASSERT_TRUE([plist[@"MyKey"] isKindOfClass:[NSString class]]);
////        ASSERT_OBJCEQ((NSString*)(plist[@"MyKey"]), @"Hello!");
////    } catch (NSError* e) {
////        ASSERT_TRUE(false);
////    }
////}
////
////TEST(NSXMLDocument, Validation_failure) throws {
////    auto xmlString = @"<?xml version=\"1.0\@" standalone=\"yes\@"?><!DOCTYPE foo [ <!ELEMENT img EMPTY> ]><foo><img>not empty</img></foo>";
////    do {
////        auto doc = try XMLDocument(xmlString: xmlString options: 0);
////        try [doc validate];
////        ASSERT_TRUE_MSG(false, @"Should have thrown");
////    } catch let nsError as NSError {
////        ASSERT_TRUE(nsError.code == XMLParser.ErrorCode.internalError.rawValue);
////        ASSERT_TRUE(nsError.domain == XMLParser.ErrorDomain);
////        ASSERT_TRUE((NSString*)(nsError.userInfo[NSLocalizedDescriptionKey]) contains:@"Element img was declared EMPTY this one has content"));
////    }
////
////    auto plistDocString = @"<?xml version='1.0' encoding='utf-8'?><!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\@" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\@"> <plist version='1.0'><dict><key>MyKey</key><string>Hello!</string><key>MyBooleanThing</key><true>foobar</true></dict></plist>";
////    auto plistDoc = try XMLDocument(xmlString: plistDocString options: 0);
////    do {
////        try [plistDoc validate];
////        ASSERT_TRUE_MSG(false, @"Should have thrown!");
////    } catch let error as NSError {
////        ASSERT_TRUE((NSString*)(error.userInfo[NSLocalizedDescriptionKey]) contains:@"Element true was declared EMPTY this one has content")];
////    }
////}
////


TEST(NSXMLDocument, Dtd) {
    NSXMLDTDNode* node = (NSXMLDTDNode*)[NSXMLNode DTDNodeWithXMLString:@"<!ELEMENT foo (#PCDATA)>"];
    ASSERT_OBJCEQ(node.name, @"foo");


    NSXMLDTD* dtd = [[[NSXMLDTD alloc] initWithContentsOfURL:[testBundle() URLForResource:@"PropertyList-1.0" withExtension:@"dtd"] options:0 error:nil] autorelease];
    dtd.name = @"plist";

    NSXMLDTDNode* plistNode = [dtd elementDeclarationForName:@"plist"];
    ASSERT_OBJCEQ(plistNode.name, @"plist");
    NSXMLDTDNode* plistObjectNode = [dtd entityDeclarationForName:@"plistObject"];
    ASSERT_OBJCEQ(plistObjectNode.name, @"plistObject");
    ASSERT_OBJCEQ(plistObjectNode.stringValue, @"(array | data | date | dict | real | integer | string | true | false )");
    NSXMLDTDNode* plistAttribute = [dtd attributeDeclarationForName:@"version" elementName:@"plist"];
    ASSERT_OBJCEQ(plistAttribute.name, @"version");


    //        dtd.systemID = testBundle() URLForResource:@"PropertyList-1.0" withExtension: @"dtd"]?.absoluteString
    //        dtd.publicID = @"-//Apple//DTD PLIST 1.0//EN"

    NSXMLDocument* doc = [[NSXMLDocument alloc] initWithXMLString:@"<?xml version='1.0' encoding='utf-8'?><plist version='1.0'><dict><key>hello</key><string>world</string></dict></plist>" options:0];
    doc.DTD = dtd;
    try {
        [doc validate];
    } catch (NSError* error) {
        ASSERT_TRUE(false);
    }

    NSXMLDTDNode* amp = [NSXMLDTD predefinedEntityDeclarationForName:@"amp"];
    ASSERT_OBJCEQ(amp.name, @"amp");
    ASSERT_OBJCEQ(amp.stringValue, @"&");
    NSXMLNode* entityNode = [NSXMLNode dtdNodeWithXMLString:@"<!ENTITY author 'Robert Thompson'>"];
    ASSERT_OBJCEQ(entityNode.name, @"author");
    ASSERT_OBJCEQ(entityNode.stringValue, @"Robert Thompson");

    auto elementDecl = [[[NSXMLDTDNode alloc] initWithKind:NSXMLElementDeclarationKind] autorelease];
    elementDecl.name = @"MyElement";
    elementDecl.stringValue = @"(#PCDATA | array)*";
    ASSERT_OBJCEQ(elementDecl.stringValue, @"(#PCDATA | array)*");
}
//
////TEST(NSXMLDocument, DocumentWithDTD) {
////    NSXMLDocument* doc = [[NSXMLDocument alloc] initWithContentsOfUrl:@"NSXMLDTDTestData.xml" options:0];
////    NSXMLDTD* dtd = doc.dtd;
////    ASSERT_OBJCEQ(dtd.name, @"root");
////
////    NSXMLDTDNode* notation = [dtd notationDeclarationForName:@"myNotation"];
////    ////[notation detach];
////    ASSERT_OBJCEQ(notation.name, @"myNotation");
////    ASSERT_OBJCEQ(notation.systemID, @"http://www.example.com");
////
////    do {
////        try [doc validate];
////    } catch {
////        ASSERT_TRUE(false);
////    }
////
////    NSXMLDTDNode* root = [dtd elementDeclarationForName:@"root"];
////    root.stringValue = @"(#PCDATA)";
////    do {
////        [doc validate];
////        ASSERT_TRUE_MSG(false, @"should have thrown");
////    } catch let error as NSError {
////        ASSERT_TRUE(error.code == XMLParser.ErrorCode.internalError.rawValue);
////    } catch {
////        ASSERT_TRUE(false);
////    }
////}
////
////TEST(NSXMLDocument, Dtd_attributes) {
////    NSXMLDocument* doc = [[NSXMLDocument alloc] initWithContentsOfURL:@"NSXMLDTDTestData.xml" options:0 error:nil];
////    NSXMLDTD* dtd = doc.dtd;
////    NSXMLDTDNode* attrDecl = [dtd attributeDeclarationForName:@"print" elementName:@"foo"]!;
////    ASSERT_TRUE(attrDecl.dtdKind == XML_ATTRIBUTE_ENUMERATION];
////}

TEST(NSXMLNode, tests) {
    ASSERT_OBJCEQ([NSXMLNode prefixForName:@"pre:fix"], @"pre");
    ASSERT_OBJCEQ([NSXMLNode localNameForName:@"pre:fix"], @"fix");
}