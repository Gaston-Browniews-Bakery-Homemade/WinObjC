//******************************************************************************
//
// Copyright (c) Microsoft. All rights reserved.
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

#import <TestFramework.h>
#import <Foundation/Foundation.h>
#import <dispatch/dispatch.h>

static const char* key = "Specific Key";
static const char* key2 = "Specific Key2";
static const char* key3 = "Specific Key3";
static char* context = "Specific Context 1";
static char* context2 = "Specific Context 2";
static char* context3 = "Specific Context 3";
static int destructorCount = 0;

static void destructor(void* x){
    destructorCount++;
}

TEST(DispatchTests, SimpleSpecific) {
    dispatch_queue_t queue = dispatch_queue_create("queue", NULL);
    dispatch_queue_set_specific(queue, key, context, NULL);
    
    dispatch_sync(queue, ^{
		EXPECT_EQ(dispatch_get_specific(key), context);
        dispatch_queue_set_specific(queue, key, context2, NULL);
    });
    
	EXPECT_EQ(dispatch_queue_get_specific(queue, key), context2);
    
    dispatch_sync(queue, ^{
		EXPECT_EQ(dispatch_get_specific(key), context2);
    });
}

TEST(DispatchTests, MultipleSpecificKeys) {
    dispatch_queue_t queue = dispatch_queue_create("queue", NULL);
    dispatch_queue_set_specific(queue, key, context, NULL);
	dispatch_queue_set_specific(queue, key2, context2, NULL);
    
    dispatch_sync(queue, ^{
		EXPECT_EQ(dispatch_get_specific(key), context);
		EXPECT_EQ(dispatch_get_specific(key2), context2);
        dispatch_queue_set_specific(queue, key, context2, NULL);
		dispatch_queue_set_specific(queue, key2, context, NULL);
    });
    
	EXPECT_EQ(dispatch_queue_get_specific(queue, key), context2);
	EXPECT_EQ(dispatch_queue_get_specific(queue, key2), context);

	dispatch_queue_set_specific(queue, key3, context3, NULL);
    
    dispatch_sync(queue, ^{
		EXPECT_EQ(dispatch_get_specific(key), context2);
		EXPECT_EQ(dispatch_get_specific(key2), context);
		EXPECT_EQ(dispatch_get_specific(key3), context3);
    });
}

TEST(DispatchTests, SpecificDestructor) {
	dispatch_queue_t queue = dispatch_queue_create("queue", NULL);
    dispatch_queue_set_specific(queue, key, context, destructor);
	EXPECT_EQ(destructorCount, 0);
    
    dispatch_sync(queue, ^{
		EXPECT_EQ(dispatch_get_specific(key), context);
        dispatch_queue_set_specific(queue, key, context2, destructor);
		EXPECT_EQ(destructorCount, 1);
    });
    
	EXPECT_EQ(dispatch_queue_get_specific(queue, key), context2);
	dispatch_queue_set_specific(queue, key, context, destructor);
	EXPECT_EQ(destructorCount, 2);
    
    dispatch_sync(queue, ^{
		EXPECT_EQ(dispatch_get_specific(key), context);
		EXPECT_EQ(destructorCount, 2);
    });
}

TEST(DispatchTests, RemoveSpecific) {
	dispatch_queue_t queue = dispatch_queue_create("queue", NULL);
    dispatch_queue_set_specific(queue, key, context, NULL);
    
    dispatch_sync(queue, ^{
		EXPECT_EQ(dispatch_get_specific(key), context);
        dispatch_queue_set_specific(queue, key, NULL, NULL);
    });

	EXPECT_EQ(dispatch_queue_get_specific(queue, key), NULL);
}