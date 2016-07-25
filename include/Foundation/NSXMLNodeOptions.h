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



enum {
    NSXMLNodeOptionsNone = 0,
    NSXMLNodeIsCDATA = 1 << 0,
    NSXMLNodeExpandEmptyElement = 1 << 1,
    NSXMLNodeCompactEmptyElement = 1 << 2,
    NSXMLNodeUseSingleQuotes = 1 << 3,
    NSXMLNodeUseDoubleQuotes = 1 << 4,
    NSXMLNodeNeverEscapeContents = 1 << 5,
    NSXMLDocumentTidyHTML = 1 << 9,
    NSXMLDocumentTidyXML = 1 << 10,
    NSXMLDocumentValidate = 1 << 13,
    NSXMLNodeLoadExternalEntitiesAlways = 1 << 14,
    NSXMLNodeLoadExternalEntitiesSameOriginOnly = 1 << 15,
    NSXMLDocumentXInclude = 1 << 16,
    NSXMLNodePrettyPrint = 1 << 17,
    NSXMLDocumentIncludeContentTypeDeclaration = 1 << 18,
    NSXMLNodeLoadExternalEntitiesNever = 1 << 19,
    NSXMLNodePreserveNamespaceOrder = 1 << 20,
    NSXMLNodePreserveAttributeOrder = 1 << 21,
    NSXMLNodePreserveEntities = 1 << 22,
    NSXMLNodePreservePrefixes = 1 << 23,
    NSXMLNodePreserveCDATA = 1 << 24,
    NSXMLNodePreserveWhitespace = 1 << 25,
    NSXMLNodePreserveDTD = 1 << 26,
    NSXMLNodePreserveCharacterReferences = 1 << 27,
    NSXMLNodePromoteSignificantWhitespace = 1 << 28,
    NSXMLNodePreserveEmptyElements = NSXMLNodeExpandEmptyElement | NSXMLNodeCompactEmptyElement,
    NSXMLNodePreserveQuotes = NSXMLNodeUseSingleQuotes | NSXMLNodeUseDoubleQuotes,
    NSXMLNodePreserveAll = NSXMLNodePreserveNamespaceOrder |
    NSXMLNodePreserveAttributeOrder |
    NSXMLNodePreserveEntities |
    NSXMLNodePreservePrefixes |
    NSXMLNodePreserveCDATA |
    NSXMLNodePreserveEmptyElements |
    NSXMLNodePreserveQuotes |
    NSXMLNodePreserveWhitespace |
    NSXMLNodePreserveDTD |
    NSXMLNodePreserveCharacterReferences |
    0xFFF00000,
};