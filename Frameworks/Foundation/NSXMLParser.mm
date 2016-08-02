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

#include "Foundation/NSXMLParser.h"

@implementation NSXMLParser

- (instancetype)initWithContentsOfURL:(NSURL*)url {
    if(url.isFileURL) {
        NSInputStream* stream = [[[NSInputStream alloc] initWithURL:url] autorelease];
        if(stream) {
            self = [self initWithStream:stream];
            self.url = url;
        } else {
            return nil;
        }
    } else {
        NSError* err = [[[NSError alloc] init] autorelease];
        NSData* data = [[[NSData alloc] initWithContentsOf:url] autorelease error:err];
        if(data && err) {
        
        }
        self = [self initWithData:data];
        self.url = url;
        
    }
}
- (instancetype)initWithData:(NSData*)data {
    return nil;
}
- (instancetype)initWithStream:(NSInputStream*)stream  {
    return nil;
}

- (BOOL)parse {
    return NO;
}
- (void)abortParsing {

}

@end
