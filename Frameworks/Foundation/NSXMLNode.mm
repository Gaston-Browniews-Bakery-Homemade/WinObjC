//******************************************************************************
//
// Copyright (c) 2015 Microsoft Corporation. All rights reserved.
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

#include "Starboard.h"
#include <CoreFoundation/CFXMLNode.h>
#include <CoreFoundation/CFXMLInterface.h>
#include <libxml/tree.h>

@implementation NSXMLNode {
    _CFXMLNodePtr _xmlNode;
    NSMutableArray<NSXMLNode*>* _childNodes;
    NSObject* _objectValue;
}

-(_CFXMLNodePtr) _getXmlNode {
    return _xmlNode;
}

-(void) _insertChild:(NSXMLNode*) node {
    [_childNodes addObject:node];
}

-(void) _removeChild:(NSXMLNode*) node {
    _CFXMLUnlinkNode([node _getXmlNode]);
    [_childNodes removeObject:node];
}

-(void) _removeAllChildren {
    for(NSXMLNode* node in _childNodes) {
        [self _removeChild:node];
    }
}

-(void) _removeAllChildNodesExceptAttributes {
    for(NSXMLNode* node in _childNodes) {
        if(node.kind != NSXMLAttributeKind) {
            [self _removeChild:node];
        }
    }
}

-(NSUInteger) _indexOfChild:(NSXMLNode*) child {
    return [_childNodes indexOfObject:child];
}

-(NSUInteger) _indexOfChild:(NSXMLNode*)childNode withName:(NSString*)name {
    NSUInteger index = 0;
    for(NSXMLNode* child in _childNodes) {
        if(child == childNode) {
            break;
        }
        if([name isEqualToString:child.name]) {
            index++;
        }
    }
    return index;
}

-(void) _detachAllChild {
    for(NSXMLNode* childNode in _childNodes) {
        [childNode detach];
    }
}

-(void) _insertChild:(NSXMLNode*)child atIndex:(NSUInteger)index {
    [_childNodes insertObject:child atIndex:index];

    if(index == 0) {
        _CFXMLNodePtr first = _CFXMLNodeGetFirstChild([self _getXmlNode]);
        _CFXMLNodeAddPrevSibling(first, [child _getXmlNode]);
    } else {
        _CFXMLNodePtr currChild = [[self _childAtIndex:(index - 1)] _getXmlNode];
        _CFXMLNodeAddNextSibling(currChild, [child _getXmlNode]);
    }
}

-(void) _insertChildren:(NSArray*)children atIndex:(NSUInteger)index {
    NSUInteger indexToInsert = index;
    for(NSXMLNode* node in children) {
        THROW_NS_IF_FALSE_MSG(E_INVALIDARG, node.parent == nil, "Child node must not have parent already.");
        _CFXMLNodeAddChild([self _getXmlNode], [node _getXmlNode]);
        [self _insertChild:node atIndex:indexToInsert];
        indexToInsert++;
    }
}

-(void) _setChildren:(NSArray*)children {
    [self _removeAllChildren];
    
    for(NSXMLNode* child in children) {
        [self _addChild:child];
    }
}

-(NSXMLNode*) _childAtIndex:(NSUInteger) index {
    return [_childNodes objectAtIndex:index];
}

-(void)_removeChildAtIndex:(NSUInteger) index {
    NSXMLNode* child = [self childAtIndex:index];
    THROW_NS_IF_FALSE_MSG(E_INVALIDARG, child != nil, "Index out of bounds.");

    [self _removeChild:child];
}

-(void) _replaceChildAtIndex:(NSUInteger) index withNode:(NSXMLNode*)node {
    NSXMLNode* child = [self _childAtIndex:index];
    [self _removeChild:child];
    _CFXMLNodeReplaceNode([child _getXmlNode], [node _getXmlNode]);
    [self _insertChild:node atIndex:index];
}

/**
 @Status Interoperable
*/
+ (NSXMLDocument*)document {
    return [[[NSXMLDocument alloc] initWithRootElement:nil] autorelease];
}

/**
 @Status Interoperable
*/
+ (NSXMLDocument*)documentWithRootElement:(NSXMLElement*)element {
    return [[[NSXMLDocument alloc] initWithRootElement:element] autorelease];
}

/**
 @Status Interoperable
*/
+ (NSXMLElement*)elementWithName:(NSString*)name {
    return [[[NSXMLElement alloc] initWithName:name] autorelease];
}

/**
 @Status Interoperable
*/
+ (NSXMLElement*)elementWithName:(NSString*)name children:(NSArray*)children attributes:(NSArray*)attributes {
    NSXMLElement* element = [[[NSXMLElement alloc] initWithName:name] autorelease];
    [element setChildren:children];
    [element setAttributes:attributes];
    return element;
}

/**
 @Status Interoperable
*/
+ (NSXMLElement*)elementWithName:(NSString*)name stringValue:(NSString*)string {
    return [[[NSXMLElement alloc] initWithName:name stringValue:string] autorelease];
}

/**
 @Status Interoperable
*/
+ (instancetype)attributeWithName:(NSString*)name stringValue:(NSString*)string {
    _CFXMLNodePtr attribute = _CFXMLNewProperty(nil, reinterpret_cast<const unsigned char*>([name UTF8String]), reinterpret_cast<const unsigned char*>([string UTF8String]));

    return [[[NSXMLNode alloc] _initWithPointer:attribute] autorelease];
}

/**
 @Status Interoperable
*/
+(instancetype)commentWithStringValue:(NSString*)string {
    _CFXMLNodePtr node = _CFXMLNewComment(reinterpret_cast<const unsigned char*>([string UTF8String]));
    return [[[NSXMLNode alloc] _initWithPointer:node] autorelease];
}

/**
 @Status Interoperable
*/
+(instancetype)textWithStringValue:(NSString*)string {
    _CFXMLNodePtr node = _CFXMLNewTextNode(reinterpret_cast<const unsigned char*>([string UTF8String]));
    return [[[NSXMLNode alloc]  _initWithPointer:node] autorelease];
}

/**
 @Status Interoperable
*/
+(instancetype)processingInstructionWithName:(NSString*)name stringValue:(NSString*)string {
    _CFXMLNodePtr node = _CFXMLNewProcessingInstruction(reinterpret_cast<const unsigned char*>([name UTF8String]), reinterpret_cast<const unsigned char*>([string UTF8String]));
    return [[[NSXMLNode alloc] _initWithPointer:node] autorelease];
}

/**
 @Status Interoperable
*/
+ (NSXMLDTDNode*)DTDNodeWithXMLString:(NSString*)string {
    _CFXMLNodePtr node = _CFXMLParseDTDNode(reinterpret_cast<const unsigned char*>([string UTF8String]));
    if(node == nullptr) {
        return nil;
    }

    return (NSXMLDTDNode*)[[[NSXMLNode alloc]  _initWithPointer:node] autorelease];
}

/**
 @Status Interoperable
*/
+ (instancetype)namespaceWithName:(NSString*)name stringValue:(NSString*)string {
    NSXMLNode* node = [NSXMLNode alloc];
    if(node = [self initWithKind:NSXMLNamespaceKind options:NSXMLNodeOptionsNone]) {
        node.URI = string;
        node.name = name;
    }
    return [node autorelease];
}

/**
 @Status Stub
*/
+ (NSXMLNode*)predefinedNamespaceForPrefix:(NSString*)prefix {
    return nil;
}

/**
 @Status Interoperable
*/
+ (NSString*)prefixForName:(NSString*)name {    
    unsigned char* result;
    xmlSplitQName2(reinterpret_cast<const unsigned char*>([name UTF8String]), &result);
    return [NSString stringWithUTF8String:reinterpret_cast<const char*>(result)];
}

/**
 @Status Interoperable
*/
+ (NSString*)localNameForName:(NSString*)name {
    int len;
    const unsigned char* result = xmlSplitQName3(reinterpret_cast<const unsigned char*>([name UTF8String]), &len);
    if(len > 0) {
        return [NSString stringWithUTF8String:reinterpret_cast<const char*>(result)];
    }
    return @"";
}

/**
 @Status Interoperable
*/
- (instancetype)initWithKind:(NSXMLNodeKind)kind {
    return [self initWithKind:kind options:NSXMLNodeOptionsNone];
}

/**
 @Status Interoperable
*/
- (instancetype)initWithKind:(NSXMLNodeKind)kind options:(NSUInteger)options {
    if(self = [super init]) {
        switch(kind) {
            case NSXMLDocumentKind: {
                _CFXMLDocPtr docPtr = _CFXMLNewDoc(reinterpret_cast<const unsigned char*>("1.0"));
                _CFXMLDocSetStandalone(docPtr, false);
                _xmlNode = docPtr;
                break;
            }
            case NSXMLElementKind:
                _xmlNode = _CFXMLNewNode(nil, "");
                break;
            case NSXMLAttributeKind:
                _xmlNode = _CFXMLNewProperty(nil, reinterpret_cast<const unsigned char*>(""), reinterpret_cast<const unsigned char*>(""));
                break;
            case NSXMLDTDKind:
                _xmlNode = _CFXMLNewDTD(nil, reinterpret_cast<const unsigned char*>(""), reinterpret_cast<const unsigned char*>(""), reinterpret_cast<const unsigned char*>(""));
                break;
            case NSXMLNamespaceKind:
                _xmlNode = _CFXMLNewNamespace(nil, reinterpret_cast<const unsigned char*>(""), reinterpret_cast<const unsigned char*>(""));
            default:
                THROW_NS_HR_MSG(E_INVALIDARG, "Invalid NSXMLNodeKind");
        }
        _childNodes = [NSMutableArray array];
    }
    _CFXMLNodeSetPrivateData(_xmlNode, self);
    return self;
}

/**
 @Status Interoperable
*/
- (NSUInteger)index {
    return 0;
}

/**
 @Status Interoperable
*/
- (NSXMLNodeKind)kind {
    CFIndex kind = _CFXMLNodeGetType([self _getXmlNode]);
    if(kind == _kCFXMLTypeElement) {
        return NSXMLElementKind;
    } else if(kind == _kCFXMLTypeAttribute) {
        return NSXMLAttributeKind;
    } else if(kind == _kCFXMLTypeDocument) {
        return NSXMLDocumentKind;
    } else if(kind == _kCFXMLTypeDTD) {
        return NSXMLDTDKind;
    } else if(kind == _kCFXMLDTDNodeTypeElement) {
        return NSXMLElementDeclarationKind;
    } else if(kind == _kCFXMLDTDNodeTypeEntity) {
        return NSXMLEntityDeclarationKind;
    } else if(kind == _kCFXMLDTDNodeTypeNotation) {
        return NSXMLNotationDeclarationKind;
    } else if(kind == _kCFXMLDTDNodeTypeAttribute) {
        return NSXMLAttributeDeclarationKind;
    } else {
        return NSXMLInvalidKind;
    }
}

/**
 @Status Interoperable
*/
- (NSUInteger)level {
    NSUInteger result = 0;
    _CFXMLNodePtr nextParent = _CFXMLNodeGetParent([self _getXmlNode]);
    while(_CFXMLNodePtr parent = nextParent) {
        result++;
        nextParent = _CFXMLNodeGetParent(parent);
    }
    return result;
}

/**
 @Status Interoperable
*/
- (NSString*)localName {
    return static_cast<NSString*>(_CFXMLNodeLocalName([self _getXmlNode]));
}

/**
 @Status Interoperable
*/
- (NSString*)name {
    const char* cname = _CFXMLNodeGetName([self _getXmlNode]);
    if(cname) {
        return [NSString stringWithUTF8String:cname];
    } else {
        return nil;
    }
}

/**
 @Status Interoperable
*/
- (NSXMLNode*)nextNode {
    _CFXMLNodePtr firstChild = _CFXMLNodeGetFirstChild([self _getXmlNode]);
    if(firstChild) {
        return [NSXMLNode _objectNodeForNodePtr:firstChild];
    }

    NSXMLNode* thisNextSibling = self.nextSibling;
    if(thisNextSibling) {
        return thisNextSibling;
    }

    NSXMLNode* thisParent = self.parent;
    if(thisParent) {
        return thisParent.nextSibling;
    }

    return nil;
}

/**
 @Status Interoperable
*/
- (NSXMLNode*)nextSibling {
    _CFXMLNodePtr sibling = _CFXMLNodeGetNextSibling([self _getXmlNode]);
    if(sibling) {
        return [NSXMLNode _objectNodeForNodePtr:sibling];
    }
    return nil;
}

/**
 @Status Interoperable
*/
- (NSString*)stringValue {
    if(self.kind == NSXMLEntityDeclarationKind) {
        return static_cast<NSString*>(_CFXMLGetEntityContent(_CFXMLEntityPtr([self _getXmlNode])));
    } else {
        return static_cast<NSString*>(_CFXMLNodeGetContent([self _getXmlNode]));
    }
}

/**
 @Status Interoperable
*/
- (NSString*)URI {
    return static_cast<NSString*>(_CFXMLNodeURI([self _getXmlNode]));
}

/**
 @Status Stub
 @Notes Stubbed due to a lack of implementation for custom value transformers.
*/
- (id)objectValue {
    if(_objectValue) {
        return _objectValue;
    }
    return nil;
}

/**
 @Status Interoperable
*/
- (NSXMLNode*)parent {
    _CFXMLNodePtr parent = _CFXMLNodeGetParent([self _getXmlNode]);
    if(parent) {
        return [NSXMLNode _objectNodeForNodePtr:parent];
    }
    return nil;
}

/**
 @Status Interoperable
*/
- (NSString*)prefix {
    return static_cast<NSString*>(_CFXMLNodePrefix([self _getXmlNode]));
}

/**
 @Status Interoperable
*/
- (NSXMLNode*)previousNode   {
    NSXMLNode* thisPrevSibling = self.previousSibling;
    if(thisPrevSibling) {
        _CFXMLNodePtr lastChild = _CFXMLNodeGetLastChild([thisPrevSibling _getXmlNode]);
        if(lastChild) {
            return [NSXMLNode _objectNodeForNodePtr:lastChild];        
        }
        return thisPrevSibling;
    }

    NSXMLNode* thisParent = self.parent;
    if(thisParent) {
        return thisParent;
    }

    return nil;
}

/**
 @Status Interoperable
*/
- (NSXMLNode*)previousSibling{
    _CFXMLNodePtr previousSibling = _CFXMLNodeGetPrevSibling([self _getXmlNode]);
    if(previousSibling) {
        return [NSXMLNode _objectNodeForNodePtr:previousSibling];
    }
    return nil;
}

/**
 @Status Interoperable
*/
- (NSXMLDocument*)rootDocument {
     _CFXMLDocPtr doc = _CFXMLNodeGetDocument([self _getXmlNode]);

    return (NSXMLDocument*)[NSXMLNode _objectNodeForNode:doc];
}

/**
 @Status Interoperable
*/
- (NSUInteger)childCount{
    return [_childNodes count];
}

/**
 @Status Interoperable
*/
- (NSArray*)children{
    switch (self.kind) {
        case NSXMLDocumentKind:
        case NSXMLElementKind:
        case NSXMLDTDKind:
            return _childNodes;
        default:
            return nil;
    }    
}

/**
 @Status Interoperable
*/
- (NSXMLNode*)childAtIndex:(NSUInteger)index{
    return [_childNodes objectAtIndex:index];
}

/**
 @Status Interoperable
*/
- (void)setName:(NSString*)name{
    if(name) {
        _CFXMLNodeSetName([self _getXmlNode], [name UTF8String]);
    } else {
        _CFXMLNodeSetName([self _getXmlNode], "");
    }
}

/**
 @Status Stub
 @Notes Cannot be implemented properly due to a lack of support for custom value transformers.
*/
- (void)setObjectValue:(NSObject*)object{
    _objectValue = object;

    self.stringValue = [object description];
}

- (void)setStringValue:(NSString*)string{
    [self _removeAllChildNodesExceptAttributes];
    if(string) {
        NSString* newContent = static_cast<NSString*>(_CFXMLEncodeEntities(_CFXMLNodeGetDocument([self _getXmlNode]), reinterpret_cast<const unsigned char*>([string UTF8String])));
        _CFXMLNodeSetContent([self _getXmlNode], reinterpret_cast<const unsigned char*>([newContent UTF8String]));
    } else {
        _CFXMLNodeSetContent([self _getXmlNode], nil);
    }
}

/**
 @Status Stub
*/
- (void)setStringValue:(NSString*)string resolvingEntities:(BOOL)resolveEntities{

    if(!resolveEntities) {
        self.stringValue = string;
        return;
    }

    [self _removeAllChildNodesExceptAttributes];
        
    NSMutableString* entities = @"";
    const char* buffer = [string UTF8String];
    NSLog(@"%c", buffer);

    BOOL inEntity = NO;
    int startIndex;

    for(int i = 0; i < string.length; i++) {
        if(*buffer == '&') {
            inEntity = YES;
            startIndex = i;
            continue;
        }
        if(*buffer == ';' && inEntity) {
            inEntity = NO;
            int min = startIndex;
            int max = i+1;
            NSString *s = [[[NSString alloc] initWithBytes:buffer - min length:max-min encoding:NSUTF8StringEncoding] autorelease];

            startIndex = 0;
        }
    }


    
    //var result: [Character] = Array(string.characters)
    //let doc = _CFXMLNodeGetDocument(_xmlNode)!
    //for (range, entity) in entities {
    //    var entityPtr = _CFXMLGetDocEntity(doc, entity)
    //    if entityPtr == nil {
    //        entityPtr = _CFXMLGetDTDEntity(doc, entity)
    //    }
    //    if entityPtr == nil {
    //        entityPtr = _CFXMLGetParameterEntity(doc, entity)
    //    }
    //    if let validEntity = entityPtr {
    //        let replacement = _CFXMLGetEntityContent(validEntity)?._swiftObject ?? ""
    //        result.replaceSubrange(range, with: replacement.characters)
    //    } else {
    //        result.replaceSubrange(range, with: []) // This appears to be how Darwin Foundation does it
    //    }
    //}
    //stringValue = String(result)
}

/**
 @Status Interoperable
*/
- (void)detach {
    _CFXMLNodePtr parentPtr = _CFXMLNodeGetParent([self _getXmlNode]);

    if(!parentPtr) {
        return;
    }

    _CFXMLUnlinkNode([self _getXmlNode]);
    
    void* parentNodePtrPrivate = _CFXMLNodeGetPrivateData(parentPtr);

    // If parent doesn't have more data, 
    if(!parentNodePtrPrivate) {
        return;
    }
    
    NSXMLNode* parent = (NSXMLNode*)parentNodePtrPrivate;
    [parent _removeChild:self];
}

/**
 @Status Stub
 @Notes parsing XPaths relies on an updated version of libxml
*/
- (NSArray*)nodesForXPath:(NSString*)xpath error:(NSError**)error {
    // Grab array of node pointers
    NSArray* nodes = static_cast<NSArray*>(_CFXMLNodesForXPath([self _getXmlNode], reinterpret_cast<const unsigned char*>([xpath UTF8String])));

    if(nodes) {
        // Convert node pointers into actual NSXMLNode objects
        NSMutableArray* resultNodes = [NSMutableArray arrayWithCapacity:[nodes count]];

        for(int i = 0; i < [nodes count]; i++) {
            _CFXMLNodePtr nodePointer = [nodes objectAtIndex:i];
            [resultNodes addObject:[NSXMLNode _objectNodeForNodePtr:nodePointer]];
        }
        return resultNodes;
    }
    return nil;
}


/**
 @Status Stub
 @Notes parsing XPaths relies on an updated version of libxml
*/
- (NSArray*)objectsForXQuery:(NSString*)xquery constants:(NSDictionary*)constants error:(NSError**)error{
    return nil;
}

/**
 @Status Stub
 @Notes parsing XPaths relies on an updated version of libxml
*/
- (NSArray*)objectsForXQuery:(NSString*)xquery error:(NSError**)error{
    return nil;
}

/**
 @Status Interoperable
*/
- (NSString*)XMLString{
    return [self XMLStringWithOptions:NSXMLNodeOptionsNone];
}

/**
 @Status Interoperable
*/
- (NSString*)XMLStringWithOptions:(NSUInteger)options{
    return static_cast<NSString*>(_CFXMLStringWithOptions([self _getXmlNode], UInt32(options)));
}

/**
 @Status Interoperable
*/
- (NSString*)XPath{
    _CFXMLDocPtr doc = _CFXMLNodeGetDocument([self _getXmlNode]);
    if(doc == nil) {
        return nil;
    }

    NSXMLNode* parent = self.parent;
    if(parent && parent.kind != NSXMLDocumentKind) {
        NSString* xpath = [NSString stringWithFormat:@"%@[%lu]", self.name, ([parent _indexOfChild:self withName:self.name] + 1)];
        NSString* xpathWithParent = [NSString stringWithFormat:@"%@/%@", parent.XPath, xpath];
        return xpathWithParent;
    } else {
        return [NSString stringWithFormat:@"/%@[1]", self.name];
    }
}

/**
 @Status Stub
*/
- (NSString*)canonicalXMLStringPreservingComments:(BOOL)comments{
    return nil;
}

/**
 This is an internal initializer for creating an NSXMLNode object with a CoreFoundation XML Node pointer.
*/
-(instancetype) _initWithPointer:(_CFXMLNodePtr) ptr {
    THROW_NS_IF_FALSE_MSG(E_INVALIDARG, _CFXMLNodeGetPrivateData(ptr) == nil, "Only one XMLNode per xmlNodePtr allowed");

    if([super init]) {
        _xmlNode = ptr;
        _CFXMLNodePtr parent = _CFXMLNodeGetParent(_xmlNode);
        if(parent) {
            NSXMLNode* parentNode = [NSXMLNode _objectNodeForNodePtr:parent];
            [parentNode _addChild:self];
        }
    
        _CFXMLNodeSetPrivateData(_xmlNode, self);
    }
    return self;
}

/**
 This is an internal function for producing an XMLNode of the right NSXMLNodeKind from a CoreFoundation XML Node pointer
*/
+ (NSXMLNode*) _objectNodeForNodePtr:(_CFXMLNodePtr) ptr {
    CFIndex index = _CFXMLNodeGetType(ptr);

    if(index == _kCFXMLTypeElement) {
        return [NSXMLElement _objectNodeForNodePtr:ptr];
    } else if(index == _kCFXMLTypeDocument) {
        return [NSXMLDocument _objectNodeForNodePtr:ptr];
    } else if(index == _kCFXMLTypeDTD) {
        return [NSXMLDTD _objectNodeForNodePtr:ptr];
    } else if(index == _kCFXMLDTDNodeTypeEntity || index == _kCFXMLDTDNodeTypeElement || index == _kCFXMLDTDNodeTypeNotation || index == _kCFXMLDTDNodeTypeAttribute) {
        return [NSXMLDTDNode _objectNodeForNodePtr:ptr];
    //} else if(index == _kCFXMLTypeAttribute) {
    }

    void* privateData = _CFXMLNodeGetPrivateData(ptr);
    if (privateData) {
        return (NSXMLNode*)privateData;
    }
    
    return [self _initWithPointer:ptr];
}

/**
 An internal function call for wrapping the child array container and the CoreFoundation tracking mechanism for xml nodes into one call
*/
-(void) _addChild:(NSXMLNode*) child {
    THROW_NS_IF_FALSE_MSG(E_INVALIDARG, child.parent == nil, "Child node must not have parent already.");

    _CFXMLNodeAddChild([self _getXmlNode], [child _getXmlNode]);
    [self _insertChild:child];
}

/**
 @Status Interoperable
*/
- (instancetype)copyWithZone:(NSZone*)zone {
    _CFXMLNodePtr newNode = _CFXMLCopyNode([self _getXmlNode], true);
    return [NSXMLNode _objectNodeForNodePtr:newNode];
}

@end
