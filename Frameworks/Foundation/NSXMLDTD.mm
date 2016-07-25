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
#include <CoreFoundation/CFXMLNode.h>
#include <CoreFoundation/CFXMLInterface.h>
#include <Foundation/NSXMLDTDNode.h>

@implementation NSXMLDTD

+(NSXMLDTDNode *)predefinedEntityDeclarationForName:(NSString *)name {
    _CFXMLDTDNodePtr node = _CFXMLDTDGetPredefinedEntity(reinterpret_cast<const unsigned char*>([name UTF8String]));
    if(node) {
        return [NSXMLDTDNode _objectNodeForNodePtr:node];
    }
    return nil;
}

-initWithData:(NSData *)data options:(NSUInteger)options error:(NSError **)error {
    _CFXMLDTDPtr node = _CFXMLParseDTDFromData(static_cast<CFDataRef>(data), reinterpret_cast<CFErrorRef*>(error));
    if(node) {
        return [self _initWithPointer:node];
    }
    return nil;
}

-initWithContentsOfURL:(NSURL *)url options:(NSUInteger)options error:(NSError **)error {
    return nil;
}

-(NSString *)publicID {
    return nil;
}
-(NSString *)systemID {
    return nil;
}

-(NSXMLDTDNode *)attributeDeclarationForName:(NSString *)attributeName elementName:(NSString *)elementName {
    _CFXMLDTDNodePtr node = _CFXMLDTDGetAttributeDesc([self _getXmlNode], reinterpret_cast<const unsigned char*>([elementName UTF8String]), reinterpret_cast<const unsigned char*>([attributeName UTF8String]));
    if(node) {
        return [NSXMLDTDNode _objectNodeForNodePointer:node];
    }
    return nil;
}

-(NSXMLDTDNode *)elementDeclarationForName:(NSString *)name {
    _CFXMLDTDNodePtr node = _CFXMLDTDGetElementDesc([self _getXmlNode], reinterpret_cast<const unsigned char*>([name UTF8String]));
    if(node) {
        return [NSXMLDTDNode _objectNodeForNodePointer:node];
    }
    return nil;
}

-(NSXMLDTDNode *)entityDeclarationForName:(NSString *)name {
    _CFXMLDTDNodePtr node = _CFXMLDTDGetEntityDesc([self _getXmlNode], reinterpret_cast<const unsigned char*>([name UTF8String]));
    if(node) {
        return [NSXMLDTDNode _objectNodeForNodePointer:node];
    }
    return nil;
}

-(NSXMLDTDNode *)notationDeclarationForName:(NSString *)name {
    _CFXMLDTDNodePtr node = _CFXMLDTDGetNotationDesc([self _getXmlNode], reinterpret_cast<const unsigned char*>([name UTF8String]));
    if(node) {
        return [NSXMLDTDNode _objectNodeForNodePointer:node];
    }
    return nil;
}

-(void)setPublicID:(NSString *)publicID {
}
-(void)setSystemID:(NSString *)systemID {
}

-(void)setChildren:(NSArray *)children {
}

-(void)addChild:(NSXMLNode *)node {
}
-(void)insertChild:(NSXMLNode *)child atIndex:(NSUInteger)index {
}
-(void)insertChildren:(NSArray *)children atIndex:(NSUInteger)index {
}
-(void)removeChildAtIndex:(NSUInteger)index {
}
-(void)replaceChildAtIndex:(NSUInteger)index withNode:(NSXMLNode *)node {
}

+ (NSXMLNode*) _objectNodeForNodePtr:(_CFXMLNodePtr) ptr {
    THROW_NS_IF_FALSE(E_INVALIDARG, _CFXMLNodeGetType(ptr) == _kCFXMLTypeDTD);

    void* privateData = _CFXMLNodeGetPrivateData(ptr);
    
    if(privateData) {
        return (NSXMLDTD*)privateData;
    }
    
    return [[[NSXMLDTD alloc] _initWithPointer:ptr] autorelease];
}

@end
