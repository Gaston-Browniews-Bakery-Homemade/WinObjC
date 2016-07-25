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

#include "Starboard.h"
#include "Foundation/NSXMLElement.h"
#include <CoreFoundation/CFXMLInterface.h>

@implementation NSXMLElement

-(instancetype)initWithName:(NSString*)name {
    return [self initWithName:name URI:nil];
}

-(instancetype)initWithName:(NSString*)name stringValue:(NSString*)string {
    if([self initWithName:name URI:nil]) {
        _CFXMLNodePtr child = _CFXMLNewTextNode(reinterpret_cast<const unsigned char*>([string UTF8String]));
        NSXMLNode* childNode = [[[NSXMLNode alloc] _initWithPointer:child] autorelease];
        [self _addChild:childNode];
    }
    return self;
}

-(instancetype)initWithName:(NSString*)name URI:(NSString *)uri{
    if(self = [super initWithKind:NSXMLElementKind options:NSXMLNodeOptionsNone]) {
        self.URI = uri;
        self.name = name;
    }
    return self;
}
-(instancetype)initWithXMLString:(NSString *)xml error:(NSError **)error{
    return nil;
}

-(NSArray *)elementsForLocalName:(NSString *)localName URI:(NSString *)uri{
    return nil;
}

-(NSArray *)elementsForName:(NSString *)name{
    NSMutableArray* returnArray = [NSMutableArray array];
    for(NSXMLNode* node in [self children]) {
        if(node.kind == NSXMLElementKind) {
            if([node.name isEqualToString:name]) {
                [returnArray addObject:node];
            }
        }
    }
    return returnArray;
}

-(NSArray*)attributes{
    NSMutableArray<NSXMLNode*>* resultArray = [NSMutableArray array];
    _CFXMLNodePtr nextAttribute = _CFXMLNodeProperties([self _getXmlNode]);
    while(nextAttribute) {
        [resultArray addObject:[NSXMLNode _objectNodeForNodePtr:nextAttribute]];
        nextAttribute = _CFXMLNodeGetNextSibling(nextAttribute);
    }
    if([resultArray count] > 0) {
        return resultArray;
    }
    return nil;
}

////stub
-(NSXMLNode*)attributeForLocalName:(NSString *)name URI:(NSString *)uri{
    return [self attributeForName:name];
}
-(NSXMLNode*)attributeForName:(NSString *)name{
    _CFXMLNodePtr attribute = _CFXMLNodeHasProp([self _getXmlNode], reinterpret_cast<const unsigned char*>([name UTF8String]));
    if(attribute) {
        return [NSXMLNode _objectNodeForNodePtr:attribute];
    }
    return nil;
}

-(void) removeAttributes {
    NSArray* attributes = self.attributes;
    for(NSXMLNode* node in attributes) {
        [self _removeChild:node];
    }
}

-(void)setAttributes:(NSArray *)attributes{
    [self removeAttributes];
    
    if(attributes == nil) {
        return;
    }
    for(NSXMLNode* node in attributes) {
        [self addAttribute:node];
    }
}

-(void)setAttributesWithDictionary:(NSDictionary*)attributes{
    [self removeAttributes];
    if([attributes count] == 0) {
        return;
    }

    for(NSString* name in attributes.allKeys) {
        NSXMLNode* attributeNode = [NSXMLNode attributeWithName:name stringValue:[attributes objectForKey:name]];
        [self addAttribute:attributeNode];
    }
}

-(void)addAttribute:(NSXMLNode *)attribute{
    _CFXMLNodePtr nodeptr = _CFXMLNodeHasProp([self _getXmlNode], reinterpret_cast<const unsigned char*>(_CFXMLNodeGetName([attribute _getXmlNode])));
    if(nodeptr) {
        return;
    }
    [self addChild:attribute];
}

-(void)removeAttributeForName:(NSString *)name{
    _CFXMLNodePtr prop = _CFXMLNodeHasProp([self _getXmlNode], reinterpret_cast<const unsigned char*>([name UTF8String]));
    if(prop) {
        NSXMLNode* propNode = [NSXMLNode _objectNodeForNodePtr:prop];
        [self _removeChild:propNode];
        _CFXMLUnlinkNode(prop);
    }
}

-(void)setChildren:(NSArray *)children{
    [self _setChildren:children];   
}

-(void)addChild:(NSXMLNode *)child{
    [self _addChild:child];
}

-(void)insertChild:(NSXMLNode *)child atIndex:(NSUInteger)index {
    THROW_NS_IF_FALSE_MSG(E_INVALIDARG, child.parent == nil, "Child node must not have parent already.");
    _CFXMLNodeAddChild([self _getXmlNode], [child _getXmlNode]);
    [self _insertChild:child atIndex:index];
}

-(void)insertChildren:(NSArray*)children atIndex:(NSUInteger)index{
    [self _insertChildren:children atIndex:index];    
}
-(void)removeChildAtIndex:(NSUInteger)index{
    [self _removeChildAtIndex:index];
}

-(void)replaceChildAtIndex:(NSUInteger)index withNode:(NSXMLNode *)node{
    [self _replaceChildAtIndex:index withNode:node];
}

-(NSArray *)namespaces{
    return nil;
}
-(NSXMLNode *)namespaceForPrefix:(NSString *)prefix{
    return nil;
}

-(void)setNamespaces:(NSArray *)namespaces{
}

-(void)addNamespace:(NSXMLNode *)aNamespace{
}
-(void)removeNamespaceForPrefix:(NSString *)prefix{
}

-(void)resolveNamespaceForName:(NSString *)name{
}
-(void)resolvePrefixForNamespaceURI:(NSString *)uri{
}

-(void)normalizeAdjacentTextNodesPreservingCDATA:(BOOL)preserve{
}

+ (NSXMLNode*) _objectNodeForNodePtr:(_CFXMLNodePtr) ptr {
    THROW_NS_IF_FALSE(E_INVALIDARG, _CFXMLNodeGetType(ptr) == _kCFXMLTypeElement);

    void* privateData = _CFXMLNodeGetPrivateData(ptr);
    if(privateData) {
        return (NSXMLElement*)privateData;
    }

    return [[[NSXMLNode alloc] _initWithPointer:ptr] autorelease];
}

@end
