// clang-format off

// This source file is part of the Swift.org open source project
//
// Copyright (c) 2014 - 2015 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See http://swift.org/LICENSE.txt for license information
// See http://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//

/*  CFXMLInterface.h
    Copyright (c) 2015 Apple Inc. and the Swift project authors
 */

#if !defined(__COREFOUNDATION_CFXMLINTERFACE__)
#define __COREFOUNDATION_CFXMLINTERFACE__ 1

#include <CoreFoundation/CFBase.h>
#include <CoreFoundation/CFArray.h>
#include <CoreFoundation/CFData.h>
#include <CoreFoundation/CFDictionary.h>
#include <CoreFoundation/CFTree.h>
#include <CoreFoundation/CFURL.h>

CF_IMPLICIT_BRIDGING_ENABLED
CF_ASSUME_NONNULL_BEGIN
CF_EXTERN_C_BEGIN

CF_EXPORT CFIndex _kCFXMLInterfaceRecovr;
CF_EXPORT CFIndex _kCFXMLInterfaceNoEnt;
CF_EXPORT CFIndex _kCFXMLInterfaceDTDLoad;
CF_EXPORT CFIndex _kCFXMLInterfaceDTDAttr;
CF_EXPORT CFIndex _kCFXMLInterfaceDTDValid;
CF_EXPORT CFIndex _kCFXMLInterfaceNoError;
CF_EXPORT CFIndex _kCFXMLInterfaceNoWarning;
CF_EXPORT CFIndex _kCFXMLInterfacePedantic;
CF_EXPORT CFIndex _kCFXMLInterfaceNoBlanks;
CF_EXPORT CFIndex _kCFXMLInterfaceSAX1;
CF_EXPORT CFIndex _kCFXMLInterfaceXInclude;
CF_EXPORT CFIndex _kCFXMLInterfaceNoNet;
CF_EXPORT CFIndex _kCFXMLInterfaceNoDict;
CF_EXPORT CFIndex _kCFXMLInterfaceNSClean;
CF_EXPORT CFIndex _kCFXMLInterfaceNoCdata;
CF_EXPORT CFIndex _kCFXMLInterfaceNoXIncnode;
CF_EXPORT CFIndex _kCFXMLInterfaceCompact;
CF_EXPORT CFIndex _kCFXMLInterfaceOld10;
CF_EXPORT CFIndex _kCFXMLInterfaceNoBasefix;
CF_EXPORT CFIndex _kCFXMLInterfaceHuge;
CF_EXPORT CFIndex _kCFXMLInterfaceOldsax;
CF_EXPORT CFIndex _kCFXMLInterfaceIgnoreEnc;
CF_EXPORT CFIndex _kCFXMLInterfaceBigLines;

CF_EXPORT CFIndex _kCFXMLTypeInvalid;
CF_EXPORT CFIndex _kCFXMLTypeDocument;
CF_EXPORT CFIndex _kCFXMLTypeElement;
CF_EXPORT CFIndex _kCFXMLTypeAttribute;
CF_EXPORT CFIndex _kCFXMLTypeDTD;
CF_EXPORT CFIndex _kCFXMLDocTypeHTML;

CF_EXPORT CFIndex _kCFXMLDTDNodeTypeEntity;
CF_EXPORT CFIndex _kCFXMLDTDNodeTypeAttribute;
CF_EXPORT CFIndex _kCFXMLDTDNodeTypeElement;
CF_EXPORT CFIndex _kCFXMLDTDNodeTypeNotation;

CF_EXPORT CFIndex _kCFXMLDTDNodeElementTypeUndefined;
CF_EXPORT CFIndex _kCFXMLDTDNodeElementTypeEmpty;
CF_EXPORT CFIndex _kCFXMLDTDNodeElementTypeAny;
CF_EXPORT CFIndex _kCFXMLDTDNodeElementTypeMixed;
CF_EXPORT CFIndex _kCFXMLDTDNodeElementTypeElement;

CF_EXPORT CFIndex _kCFXMLDTDNodeEntityTypeInternalGeneral;
CF_EXPORT CFIndex _kCFXMLDTDNodeEntityTypeExternalGeneralParsed;
CF_EXPORT CFIndex _kCFXMLDTDNodeEntityTypeExternalGeneralUnparsed;
CF_EXPORT CFIndex _kCFXMLDTDNodeEntityTypeInternalParameter;
CF_EXPORT CFIndex _kCFXMLDTDNodeEntityTypeExternalParameter;
CF_EXPORT CFIndex _kCFXMLDTDNodeEntityTypeInternalPredefined;

CF_EXPORT CFIndex _kCFXMLDTDNodeAttributeTypeCData;
CF_EXPORT CFIndex _kCFXMLDTDNodeAttributeTypeID;
CF_EXPORT CFIndex _kCFXMLDTDNodeAttributeTypeIDRef;
CF_EXPORT CFIndex _kCFXMLDTDNodeAttributeTypeIDRefs;
CF_EXPORT CFIndex _kCFXMLDTDNodeAttributeTypeEntity;
CF_EXPORT CFIndex _kCFXMLDTDNodeAttributeTypeEntities;
CF_EXPORT CFIndex _kCFXMLDTDNodeAttributeTypeNMToken;
CF_EXPORT CFIndex _kCFXMLDTDNodeAttributeTypeNMTokens;
CF_EXPORT CFIndex _kCFXMLDTDNodeAttributeTypeEnumeration;
CF_EXPORT CFIndex _kCFXMLDTDNodeAttributeTypeNotation;

typedef struct _xmlParserInput *_CFXMLInterfaceParserInput;
typedef struct _xmlParserCtxt *_CFXMLInterfaceParserContext;
typedef struct _xmlSAXHandler *_CFXMLInterfaceSAXHandler;
typedef struct _xmlEntity *_CFXMLInterfaceEntity;
typedef struct _xmlEnumeration *_CFXMLInterfaceEnumeration;
typedef struct _xmlElementContent *_CFXMLInterfaceElementContent;
typedef struct _xmlError *_CFXMLInterfaceError;
typedef struct __CFXMLInterface *_CFXMLInterface;

typedef _CFXMLInterfaceParserInput _Nonnull (*_CFXMLInterfaceExternalEntityLoader)(const char *URL, const char *ID, _CFXMLInterfaceParserContext);
typedef void (*_CFXMLInterfaceStructuredErrorFunc)(_CFXMLInterface ctx, _CFXMLInterfaceError error);

void _CFSetupXMLInterface(void);
_CFXMLInterfaceParserInput _CFXMLInterfaceNoNetExternalEntityLoader(const char *URL, const char *ID, _CFXMLInterfaceParserContext ctxt);
_CFXMLInterfaceSAXHandler _CFXMLInterfaceCreateSAXHandler();
void _CFXMLInterfaceDestroySAXHandler(_CFXMLInterfaceSAXHandler handler);
void _CFXMLInterfaceSetStructuredErrorFunc(_CFXMLInterface ctx, _CFXMLInterfaceStructuredErrorFunc _Nullable  handler);
_CFXMLInterfaceParserContext  _CFXMLInterfaceCreatePushParserCtxt(_CFXMLInterfaceSAXHandler _Nullable sax, _CFXMLInterface  user_data, const char * chunk, int size, const char *_Nullable filename);
void _CFXMLInterfaceCtxtUseOptions(_CFXMLInterfaceParserContext _Nullable ctx, CFIndex options);
int _CFXMLInterfaceParseChunk(_CFXMLInterfaceParserContext _Nullable ctxt, const char * chunk, int size, int terminate);
void _CFXMLInterfaceStopParser(_CFXMLInterfaceParserContext _Nullable ctx);
void _CFXMLInterfaceDestroyContext(_CFXMLInterfaceParserContext _Nullable ctx);
int _CFXMLInterfaceSAX2GetColumnNumber(_CFXMLInterfaceParserContext _Nullable ctx);
int _CFXMLInterfaceSAX2GetLineNumber(_CFXMLInterfaceParserContext _Nullable ctx);
void _CFXMLInterfaceSAX2InternalSubset(_CFXMLInterfaceParserContext _Nullable ctx,
                                       const unsigned char * name,
                                       const unsigned char * ExternalID,
                                       const unsigned char * SystemID);
void _CFXMLInterfaceSAX2ExternalSubset(_CFXMLInterfaceParserContext _Nullable ctx,
                                       const unsigned char * name,
                                       const unsigned char * ExternalID,
                                       const unsigned char * SystemID);
int _CFXMLInterfaceIsStandalone(_CFXMLInterfaceParserContext _Nullable ctx);
int _CFXMLInterfaceHasInternalSubset(_CFXMLInterfaceParserContext _Nullable ctx);
int _CFXMLInterfaceHasExternalSubset(_CFXMLInterfaceParserContext _Nullable ctx);
_CFXMLInterfaceEntity _Nullable _CFXMLInterfaceGetPredefinedEntity(const unsigned char * name);
_CFXMLInterfaceEntity _Nullable _CFXMLInterfaceSAX2GetEntity(_CFXMLInterfaceParserContext _Nullable ctx, const unsigned char *  name);
int _CFXMLInterfaceInRecursiveState(_CFXMLInterfaceParserContext ctx);
void _CFXMLInterfaceResetRecursiveState(_CFXMLInterfaceParserContext ctx);
int _CFXMLInterfaceHasDocument(_CFXMLInterfaceParserContext _Nullable ctx);
void _CFXMLInterfaceFreeEnumeration(_CFXMLInterfaceEnumeration _Nullable enumeration);
void _CFXMLInterfaceSAX2UnparsedEntityDecl(_CFXMLInterfaceParserContext _Nullable ctx, const unsigned char * name, const unsigned char *_Nullable publicId, const unsigned char *_Nullable systemId, const unsigned char *_Nullable notationName);
CFErrorRef _CFErrorCreateFromXMLInterface(_CFXMLInterfaceError err) CF_RETURNS_RETAINED;

typedef void* _CFXMLNodePtr;
typedef void* _CFXMLDocPtr;
typedef void* _CFXMLNamespacePtr;
typedef void* _CFXMLEntityPtr;
typedef void* _CFXMLDTDPtr;
typedef void* _CFXMLDTDNodePtr;

_CFXMLNodePtr _CFXMLNewNode(_CFXMLNamespacePtr xmlNamespace, const char* name);
_CFXMLNodePtr _CFXMLCopyNode(_CFXMLNodePtr node, bool recursive);

_CFXMLDocPtr _CFXMLNewDoc(const unsigned char* version);
_CFXMLNodePtr _CFXMLNewProcessingInstruction(const unsigned char* name, const unsigned char* value);
_CFXMLNodePtr _CFXMLNewTextNode(const unsigned char* value);
_CFXMLNodePtr _CFXMLNewComment(const unsigned char* value);
_CFXMLNodePtr _CFXMLNewProperty(_CFXMLNodePtr _Nullable node, const unsigned char* name, const unsigned char* value);
_CFXMLNamespacePtr _CFXMLNewNamespace(_CFXMLNodePtr _Nullable node, const unsigned char* uri, const unsigned char* prefix);

CF_RETURNS_RETAINED CFStringRef _Nullable _CFXMLNodeURI(_CFXMLNodePtr node);
void _CFXMLNodeSetURI(_CFXMLNodePtr node, const unsigned char* URI);

void _CFXMLNodeSetPrivateData(_CFXMLNodePtr node, void* data);
void* _Nullable  _CFXMLNodeGetPrivateData(_CFXMLNodePtr node);
_CFXMLNodePtr _Nullable _CFXMLNodeProperties(_CFXMLNodePtr node);
CFIndex _CFXMLNodeGetType(_CFXMLNodePtr node);
const char* _CFXMLNodeGetName(_CFXMLNodePtr node);
void _CFXMLNodeSetName(_CFXMLNodePtr node, const char* name);
CF_RETURNS_RETAINED CFStringRef _Nullable _CFXMLNodeGetContent(_CFXMLNodePtr node);
void _CFXMLNodeSetContent(_CFXMLNodePtr node,  const unsigned char* _Nullable  content);
void _CFXMLUnlinkNode(_CFXMLNodePtr node);

_CFXMLNodePtr _Nullable _CFXMLNodeGetFirstChild(_CFXMLNodePtr node);
_CFXMLNodePtr _Nullable _CFXMLNodeGetLastChild(_CFXMLNodePtr node);
_CFXMLNodePtr _Nullable _CFXMLNodeGetNextSibling(_CFXMLNodePtr node);
_CFXMLNodePtr _Nullable _CFXMLNodeGetPrevSibling(_CFXMLNodePtr node);
_CFXMLNodePtr _Nullable _CFXMLNodeGetParent(_CFXMLNodePtr node);
CFIndex _CFXMLNodeGetElementChildCount(_CFXMLNodePtr node);
void _CFXMLNodeAddChild(_CFXMLNodePtr node, _CFXMLNodePtr child);
void _CFXMLNodeAddPrevSibling(_CFXMLNodePtr node, _CFXMLNodePtr prevSibling);
void _CFXMLNodeAddNextSibling(_CFXMLNodePtr node, _CFXMLNodePtr nextSibling);
void _CFXMLNodeReplaceNode(_CFXMLNodePtr node, _CFXMLNodePtr replacement);

_CFXMLDocPtr _Nullable _CFXMLNodeGetDocument(_CFXMLNodePtr node);

bool _CFXMLDocStandalone(_CFXMLDocPtr doc);
void _CFXMLDocSetStandalone(_CFXMLDocPtr doc, bool standalone);
_CFXMLNodePtr _Nullable _CFXMLDocRootElement(_CFXMLDocPtr doc);
void _CFXMLDocSetRootElement(_CFXMLDocPtr doc, _CFXMLNodePtr node);
CF_RETURNS_RETAINED CFStringRef _Nullable _CFXMLDocCharacterEncoding(_CFXMLDocPtr doc);
void _CFXMLDocSetCharacterEncoding(_CFXMLDocPtr doc,  const unsigned char* _Nullable  encoding);
CF_RETURNS_RETAINED CFStringRef _Nullable _CFXMLDocVersion(_CFXMLDocPtr doc);
void _CFXMLDocSetVersion(_CFXMLDocPtr doc, const unsigned char* version);
int _CFXMLDocProperties(_CFXMLDocPtr doc);
void _CFXMLDocSetProperties(_CFXMLDocPtr doc, int newProperties);
_CFXMLDTDPtr _Nullable _CFXMLDocDTD(_CFXMLDocPtr doc);
void _CFXMLDocSetDTD(_CFXMLDocPtr doc, _CFXMLDTDPtr _Nullable dtd);

CF_RETURNS_RETAINED CFStringRef _Nullable _CFXMLEncodeEntities(_CFXMLDocPtr doc, const unsigned char* string);
_CFXMLEntityPtr _Nullable _CFXMLGetDocEntity(_CFXMLDocPtr doc, const char* entity);
_CFXMLEntityPtr _Nullable _CFXMLGetDTDEntity(_CFXMLDocPtr doc, const char* entity);
_CFXMLEntityPtr _Nullable _CFXMLGetParameterEntity(_CFXMLDocPtr doc, const char* entity);

CF_RETURNS_RETAINED CFStringRef _Nullable _CFXMLGetEntityContent(_CFXMLEntityPtr entity);

CF_RETURNS_RETAINED CFStringRef _CFXMLStringWithOptions(_CFXMLNodePtr node, uint32_t options);

CF_RETURNS_RETAINED CFArrayRef _Nullable _CFXMLNodesForXPath(_CFXMLNodePtr node, const unsigned char* xpath);

_CFXMLNodePtr _Nullable _CFXMLNodeHasProp(_CFXMLNodePtr node, const unsigned char* propertyName);

_CFXMLDocPtr _CFXMLDocPtrFromDataWithOptions(CFDataRef data, int options);

CF_RETURNS_RETAINED CFStringRef _Nullable _CFXMLNodeLocalName(_CFXMLNodePtr node);
CF_RETURNS_RETAINED CFStringRef _Nullable _CFXMLNodePrefix(_CFXMLNodePtr node);

bool _CFXMLDocValidate(_CFXMLDocPtr doc, CFErrorRef _Nullable * error);

_CFXMLDTDPtr _CFXMLNewDTD(_CFXMLDocPtr doc, const unsigned char* name, const unsigned char* publicID, const unsigned char* systemID);
_CFXMLDTDNodePtr _Nullable _CFXMLParseDTDNode(const unsigned char* xmlString);
_CFXMLDTDPtr _Nullable _CFXMLParseDTD(const unsigned char* URL);
_CFXMLDTDPtr _Nullable _CFXMLParseDTDFromData(CFDataRef data, CFErrorRef _Nullable * error);
CF_RETURNS_RETAINED CFStringRef _Nullable _CFXMLDTDExternalID(_CFXMLDTDPtr dtd);
void _CFXMLDTDSetExternalID(_CFXMLDTDPtr dtd, const unsigned char* externalID);
CF_RETURNS_RETAINED CFStringRef _Nullable _CFXMLDTDSystemID(_CFXMLDTDPtr dtd);
void _CFXMLDTDSetSystemID(_CFXMLDTDPtr dtd, const unsigned char* systemID);

_CFXMLDTDNodePtr _Nullable _CFXMLDTDGetElementDesc(_CFXMLDTDPtr dtd, const unsigned char* name);
_CFXMLDTDNodePtr _Nullable _CFXMLDTDGetAttributeDesc(_CFXMLDTDPtr dtd, const unsigned char* elementName, const unsigned char* name);
_CFXMLDTDNodePtr _Nullable _CFXMLDTDGetNotationDesc(_CFXMLDTDPtr dtd, const unsigned char* name);
_CFXMLDTDNodePtr _Nullable _CFXMLDTDGetEntityDesc(_CFXMLDTDPtr dtd, const unsigned char* name);
_CFXMLDTDNodePtr _Nullable _CFXMLDTDGetPredefinedEntity(const unsigned char* name);

_CFXMLDTDNodePtr _Nullable _CFXMLDTDNewElementDesc(_CFXMLDTDPtr dtd, const unsigned char* name);
_CFXMLDTDNodePtr _Nullable _CFXMLDTDNewAttributeDesc(_CFXMLDTDPtr dtd, const unsigned char* name);

CFIndex _CFXMLDTDElementNodeGetType(_CFXMLDTDNodePtr node);
CFIndex _CFXMLDTDEntityNodeGetType(_CFXMLDTDNodePtr node);
CFIndex _CFXMLDTDAttributeNodeGetType(_CFXMLDTDNodePtr node);

CF_RETURNS_RETAINED CFStringRef _Nullable _CFXMLDTDNodeGetSystemID(_CFXMLDTDNodePtr node);
void _CFXMLDTDNodeSetSystemID(_CFXMLDTDNodePtr node, const unsigned char* systemID);
CF_RETURNS_RETAINED CFStringRef _Nullable _CFXMLDTDNodeGetPublicID(_CFXMLDTDNodePtr node);
void _CFXMLDTDNodeSetPublicID(_CFXMLDTDNodePtr node, const unsigned char* publicID);

void _CFXMLFreeNode(_CFXMLNodePtr node);
void _CFXMLFreeDocument(_CFXMLDocPtr doc);
void _CFXMLFreeDTD(_CFXMLDTDPtr dtd);
void _CFXMLFreeProperty(_CFXMLNodePtr prop);

CF_EXTERN_C_END
CF_ASSUME_NONNULL_END
CF_IMPLICIT_BRIDGING_DISABLED

#endif /* __COREFOUNDATION_CFXMLINTERFACE__ */

// clang-format on