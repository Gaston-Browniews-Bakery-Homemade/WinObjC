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

@implementation NSXMLDTDNode

-(instancetype)initWithXMLString:(NSString *)string {
    _CFXMLDTDNodePtr ptr = _CFXMLParseDTDNode(reinterpret_cast<const unsigned char*>([string UTF8String]));
    if(ptr) {
        return [super _initWithPointer:ptr];
    }
    return nil;
}

-(NSXMLDTDNodeKind)DTDKind {
    CFIndex nodeType = _CFXMLNodeGetType([self _getXmlNode]);
    if(nodeType == _kCFXMLDTDNodeTypeElement) {
        CFIndex dtdType = _CFXMLDTDElementNodeGetType([self _getXmlNode]);
        if(dtdType == _kCFXMLDTDNodeElementTypeAny) {
            return NSXMLElementDeclarationAnyKind;
        } else if(dtdType == _kCFXMLDTDNodeElementTypeEmpty) {
            return NSXMLElementDeclarationEmptyKind;
        } else if(dtdType == _kCFXMLDTDNodeElementTypeMixed) {
            return NSXMLElementDeclarationEmptyKind;
        } else if(dtdType == _kCFXMLDTDNodeElementTypeElement) {
            return NSXMLElementDeclarationElementKind;
        } else  {
            return NSXMLElementDeclarationUndefinedKind;
        }
    } else if(nodeType == _kCFXMLDTDNodeTypeEntity) {
        CFIndex dtdType = _CFXMLDTDEntityNodeGetType([self _getXmlNode]);
        if(dtdType == _kCFXMLDTDNodeEntityTypeInternalGeneral) {
            return NSXMLEntityGeneralKind;
        } else if(dtdType == _kCFXMLDTDNodeEntityTypeExternalGeneralUnparsed) {
            return NSXMLEntityUnparsedKind;
        } else if(dtdType == _kCFXMLDTDNodeEntityTypeExternalParameter) {
            return NSXMLEntityParameterKind;
        } else if(dtdType == _kCFXMLDTDNodeEntityTypeInternalParameter) {
            return NSXMLEntityPredefined;
        } else if(dtdType == _kCFXMLDTDNodeEntityTypeInternalPredefined) {
            return NSXMLEntityPredefined;
        } else if(dtdType == _kCFXMLDTDNodeEntityTypeExternalGeneralParsed) {
            return NSXMLEntityParsedKind;
        } else {
            THROW_NS_IF_FALSE_MSG(E_INVALIDARG, false, "Invalid entity declaration type.");
        }
    } else if(nodeType == _kCFXMLDTDNodeTypeAttribute) {
        CFIndex dtdType = _CFXMLDTDAttributeNodeGetType([self _getXmlNode]);

        if(dtdType == _kCFXMLDTDNodeAttributeTypeCData) {
            return NSXMLAttributeCDATAKind;
        } else if(dtdType == _kCFXMLDTDNodeAttributeTypeID) {
            return NSXMLAttributeIDKind;
        } else if(dtdType == _kCFXMLDTDNodeAttributeTypeIDRef) {
            return NSXMLAttributeIDRefKind;
        } else if(dtdType == _kCFXMLDTDNodeAttributeTypeIDRefs) {
            return NSXMLAttributeIDRefsKind;
        } else if(dtdType == _kCFXMLDTDNodeAttributeTypeEntity) {
            return NSXMLAttributeEntityKind;
        } else if(dtdType == _kCFXMLDTDNodeAttributeTypeEntities) {
            return NSXMLAttributeEntitiesKind;
        } else if(dtdType == _kCFXMLDTDNodeAttributeTypeNMToken) {
            return NSXMLAttributeNMTokenKind;
        } else if(dtdType == _kCFXMLDTDNodeAttributeTypeNMTokens) {
            return NSXMLAttributeNMTokensKind;
        } else if(dtdType == _kCFXMLDTDNodeAttributeTypeEnumeration) {
            return NSXMLAttributeEnumerationKind;
        } else if(dtdType == _kCFXMLDTDNodeAttributeTypeNotation) {
            return NSXMLAttributeNotationKind;
        } else {
            THROW_NS_IF_FALSE_MSG(E_INVALIDARG, false, "Invalid attribute declaration type.");
        }
    } else if(nodeType == _kCFXMLTypeInvalid) {
        return (NSXMLDTDNodeKind)0;
    } else {
        THROW_NS_IF_FALSE_MSG(E_INVALIDARG, false, "This is not actually a DTD node!");
    }
    return (NSXMLDTDNodeKind)0;
}

-(void)setDTDKind:(NSXMLDTDNodeKind)kind {
    //Unsupported in Core Foundation
}

-(BOOL)isExternal {
    return [self _systemID] != nil;
}

-(NSString *)notationName {
    if([self DTDKind] != NSXMLEntityUnparsedKind) {
        return nil;
    }

    return static_cast<NSString*>(_CFXMLGetEntityContent([self _getXmlNode]));
}

-(void)setNotationName:(NSString*)newNotationName {
    if([self DTDKind] != NSXMLEntityUnparsedKind) {
        return;
    }

    _CFXMLNodeSetContent([self _getXmlNode], reinterpret_cast<const unsigned char*>([newNotationName UTF8String]));
}

-(NSString *)publicID {
    return static_cast<NSString*>(_CFXMLDTDNodeGetPublicID([self _getXmlNode]));
}

-(void)setPublicID:(NSString*)newId {
    _CFXMLDTDNodeSetPublicID([self _getXmlNode], reinterpret_cast<const unsigned char*>([newId UTF8String]));
}

-(NSString *)systemID {
    return static_cast<NSString*>(_CFXMLDTDNodeGetSystemID([self _getXmlNode]));
}

-(void)setSystemID:(NSString*)newSystemId {
    _CFXMLDTDNodeSetSystemID([self _getXmlNode], reinterpret_cast<const unsigned char*>([newSystemId UTF8String]));
}

+ (NSXMLNode*) _objectNodeForNodePtr:(_CFXMLNodePtr) ptr {
    CFIndex type = _CFXMLNodeGetType(ptr);

    if(!(type == _kCFXMLDTDNodeTypeAttribute || type == _kCFXMLDTDNodeTypeNotation || type == _kCFXMLDTDNodeTypeEntity || type == _kCFXMLDTDNodeTypeElement)) {
        THROW_NS_HR_MSG(E_INVALIDARG, "Invalid DTDNode type.");   
    }

    void* privateData = _CFXMLNodeGetPrivateData(ptr);
    if(privateData) {
        return (NSXMLDTDNode*)privateData;
    }

    return [[[NSXMLDTDNode alloc] _initWithPointer:ptr] autorelease];
}

@end
