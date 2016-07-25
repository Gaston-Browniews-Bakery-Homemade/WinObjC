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
    _CFXMLDTDNodePtr ptr = _CFXMLParseDTDNode(reinterpret_cast<const unsigned char*>[string UTF8String]);
    if(ptr) {
        return [super _initWithPointer:ptr];
    }
    return nil;
}

-(NSXMLDTDNodeKind)DTDKind {
    switch _CFXMLNodeGetType([self _getXmlNode]) {
        case _kCFXMLDTDNodeTypeElement:
            switch _CFXMLDTDElementNodeGetType([self _getXmlNode]) {
            case _kCFXMLDTDNodeElementTypeAny:
                return .anyDeclaration
                
            case _kCFXMLDTDNodeElementTypeEmpty:
                return .emptyDeclaration
                
            case _kCFXMLDTDNodeElementTypeMixed:
                return .mixedDeclaration
                
            case _kCFXMLDTDNodeElementTypeElement:
                return .elementDeclaration
                
            default:
                return .undefinedDeclaration
            }
            
        case _kCFXMLDTDNodeTypeEntity:
            switch _CFXMLDTDEntityNodeGetType([self _getXmlNode]) {
            case _kCFXMLDTDNodeEntityTypeInternalGeneral:
                return .general
                
            case _kCFXMLDTDNodeEntityTypeExternalGeneralUnparsed:
                return .unparsed
                
            case _kCFXMLDTDNodeEntityTypeExternalParameter:
                fallthrough
            case _kCFXMLDTDNodeEntityTypeInternalParameter:
                return .parameter
                
            case _kCFXMLDTDNodeEntityTypeInternalPredefined:
                return .predefined
                
            case _kCFXMLDTDNodeEntityTypeExternalGeneralParsed:
                return .general
                
            default:
                fatalError("Invalid entity declaration type")
            }
            
        case _kCFXMLDTDNodeTypeAttribute:
            switch _CFXMLDTDAttributeNodeGetType([self _getXmlNode]) {
            case _kCFXMLDTDNodeAttributeTypeCData:
                return .cdataAttribute
                
            case _kCFXMLDTDNodeAttributeTypeID:
                return .idAttribute
                
            case _kCFXMLDTDNodeAttributeTypeIDRef:
                return .idRefAttribute
                
            case _kCFXMLDTDNodeAttributeTypeIDRefs:
                return .idRefsAttribute
                
            case _kCFXMLDTDNodeAttributeTypeEntity:
                return .entityAttribute
                
            case _kCFXMLDTDNodeAttributeTypeEntities:
                return .entitiesAttribute
                
            case _kCFXMLDTDNodeAttributeTypeNMToken:
                return .nmTokenAttribute
                
            case _kCFXMLDTDNodeAttributeTypeNMTokens:
                return .nmTokensAttribute
                
            case _kCFXMLDTDNodeAttributeTypeEnumeration:
                return .enumerationAttribute
                
            case _kCFXMLDTDNodeAttributeTypeNotation:
                return .notationAttribute
                
            default:
                fatalError("Invalid attribute declaration type")
            }
            
        case _kCFXMLTypeInvalid:
            return unsafeBitCast(0, to: DTDKind.self) // this mirrors Darwin
            
        default:
            fatalError("This is not actually a DTD node!")
        }
}
-(BOOL)isExternal {
    return [self _systemID] != nil;
}

-(NSString *)notationName {
    if([self dtdKind] != .unparsed) {
        return nil;
    }

    return static_cast<NSString*>(_CFXMLGetEntityContent([self _getXmlNode]));
}

-(void)setNotationName:(NSString*)newNotationName {
    if([self dtdKind] != .unparsed) {
        return;
    }

    _CFXMLNodeSetContent([self _getXmlNode], reinterpret_cast<const unsigned char*>([value UTF8String]));
}

-(NSString *)publicID {
    return static_cast<NSString*>(_CFXMLDTDNodeGetPublicID([self _getXmlNode]));
}

-(void)setPublicID:(NSString*)newId {
    _CFXMLDTDNodeSetPublicID([self _getXmlNode], value)
}

-(NSString *)systemID {
    return static_cast<NSString*>(_CFXMLDTDNodeGetSystemID([self _getXmlNode]));
}

-(void)systemID:(NSString*)newSystemId {
    _CFXMLDTDNodeSetSystemID([self _getXmlNode], [newSystemId UTF8String]);
}

@end
