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
#include "Foundation/NSXMLDocument.h"
#include <CoreFoundation/CFXMLInterface.h>

@implementation NSXMLDocument

+ (Class)replacementClassForClass:(Class)aClass {
    return nil;
}

- initWithRootElement:(NSXMLElement*)element {
    if(element != nil) {
        THROW_NS_IF_FALSE(E_INVALIDARG, ([element parent] == nil));
    }

    if(self = [super initWithKind:NSXMLDocumentKind options:NSXMLNodeOptionsNone]) {
        _CFXMLDocSetRootElement([self _getXmlNode], [element _getXmlNode]);
        [self _insertChild:element];
    }
    return self;
}

- (instancetype)initWithXMLString:(NSString*)string options:(NSUInteger)options error:(NSError**)error {
    NSData* data = [string dataUsingEncoding:NSUTF8StringEncoding];
    return [self initWithData:data options:options error:error];
}

- (instancetype)initWithData:(NSData*)data options:(NSUInteger)options error:(NSError**)error{
    _CFXMLDocPtr docPtr = _CFXMLDocPtrFromDataWithOptions(static_cast<CFDataRef>(data), options);
    self = [super _initWithPointer:docPtr];

    if (options & NSXMLDocumentValidate != 0) {
        [self validateAndReturnError:error];
    }
    return self;
}

- (instancetype)initWithContentsOfURL:(NSURL*)url options:(NSUInteger)options error:(NSError**)error{
    NSData* data = [[[NSData alloc] initWithContentsOfURL:url options:NSDataReadingMappedIfSafe error:error] autorelease];

    if(data) {
        return [self initWithData:data options:options error:error];
    }
    return nil;
}

- (NSXMLDocumentContentKind)documentContentKind {
    int properties = _CFXMLDocProperties([self _getXmlNode]);

    if((properties & _kCFXMLDocTypeHTML) != 0) {
        return NSXMLDocumentHTMLKind;
    }

    return NSXMLDocumentXMLKind;
}
- (NSString*)version{
    return static_cast<NSString*>(_CFXMLDocVersion([self _getXmlNode]));
}

- (NSString*)characterEncoding{
     return static_cast<NSString*>(_CFXMLDocCharacterEncoding([self _getXmlNode]));
}

- (BOOL)isStandalone{
    return (_CFXMLDocStandalone([self _getXmlNode]) ? YES : NO);
}

- (NSXMLElement*)rootElement{
    _CFXMLNodePtr rootPtr = _CFXMLDocRootElement([self _getXmlNode]);

    if(!rootPtr) {
        return nil;
    }

    return (NSXMLElement*)[NSXMLNode _objectNodeForNodePtr:rootPtr];
}

- (NSXMLDTD*)DTD{
    return [NSXMLDTD _objectNodeForNodePtr:_CFXMLDocDTD([self _getXmlNode])];
}

- (NSString*)URI{
    return nil;
}

- (void)setDocumentContentKind:(NSXMLDocumentContentKind)kind {
    _CFXMLDocSetProperties([self _getXmlNode], kind);
}

- (void)setCharacterEncoding:(NSString*)encoding {
    _CFXMLDocSetCharacterEncoding([self _getXmlNode], reinterpret_cast<const unsigned char*>([encoding UTF8String]));
}

- (void)setVersion:(NSString*)version {
    if([version isEqualToString:@"1.0"] || [version isEqualToString:@"1.1"]) {
        _CFXMLDocSetVersion([self _getXmlNode], reinterpret_cast<const unsigned char*>([version UTF8String]));
    } else {
        _CFXMLDocSetVersion([self _getXmlNode], nil);
    }
}

- (void)setStandalone:(BOOL)flag {
    _CFXMLDocSetStandalone([self _getXmlNode], flag);
}

- (void)setRootElement:(NSXMLElement*)element {
    if(element) {
        THROW_NS_IF_FALSE(E_INVALIDARG, ([element parent] == nil));
    }

    [self _detachAllChild];

    _CFXMLDocSetRootElement([self _getXmlNode], [element _getXmlNode]);
    [self _insertChild:element];
}

- (void)setDTD:(NSXMLDTD*)dtd {
    _CFXMLDTDPtr currDTD = _CFXMLDocDTD([self _getXmlNode]);
    if(currDTD) {
        if(_CFXMLNodeGetPrivateData(currDTD) != nil) {
            [self _removeChild:([NSXMLDTD _objectNodeForNodePtr:currDTD])];
        } else {
            _CFXMLFreeDTD(currDTD);
        }
    }

    if(dtd) {
        _CFXMLDocSetDTD([self _getXmlNode], [dtd _getXmlNode]);
        [self _insertChild:dtd];
    } else {
        _CFXMLDocSetDTD([self _getXmlNode], nil);
    }
}

- (void)setURI:(NSString*)uri {
}

- (void)setChildren:(NSArray*)children {
    [self _setChildren:children];
}

- (void)addChild:(NSXMLNode*)child {
    [self _addChild:child];
}

- (void)insertChild:(NSXMLNode*)child atIndex:(NSUInteger)index {
    [self _insertChild:child atIndex:index];
}
- (void)insertChildren:(NSArray*)children atIndex:(NSUInteger)index {
    [self _insertChildren:children atIndex:index];
}
- (void)removeChildAtIndex:(NSUInteger)index {
    [self _removeChildAtIndex:index];
}
- (void)replaceChildAtIndex:(NSUInteger)index withNode:(NSXMLNode*)node {
    [self _replaceChildAtIndex:index withNode:node];
}

- (BOOL)validateAndReturnError:(NSError**)error {
    return _CFXMLDocValidate([self _getXmlNode], reinterpret_cast<CFErrorRef*>(error)) ? YES : NO;
}

- (NSData*)XMLData {
    return [self XMLDataWithOptions:NSXMLNodeOptionsNone];
}

- (NSData*)XMLDataWithOptions:(NSUInteger)options {
    NSString* string = [self XMLStringWithOptions:options];
    return [string dataUsingEncoding:NSUTF8StringEncoding];
}

////stub
- (id)objectByApplyingXSLT:(NSData*)xslt arguments:(NSDictionary*)arguments error:(NSError*)error {
    return nil;
}
////stub
- (id)objectByApplyingXSLTAtURL:(NSURL*)url arguments:(NSDictionary*)arguments error:(NSError*)error {
    return nil;
}
////stub
- (id)objectByApplyingXSLTString:(NSString*)string arguments:(NSDictionary*)arguments error:(NSError*)error {
    return nil;
}

+ (NSXMLNode*) _objectNodeForNodePtr:(_CFXMLNodePtr) ptr {
    THROW_NS_IF_FALSE(E_INVALIDARG, _CFXMLNodeGetType(ptr) == _kCFXMLTypeDocument);

    void* privateData = _CFXMLNodeGetPrivateData(ptr);
    if(privateData) {
        return (NSXMLDocument*)privateData;
    }

    return [[[NSXMLNode alloc] _initWithPointer:ptr] autorelease];
}

@end
