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
static char* context = "Specific Context 1";
static char* context2 = "Specific Context 2";
static bool destructorCalled = false;

static void destructor(void* thing){
    // Nothing required to be done.
    destructorCalled = true;
}

TEST(DISPATCHTESTS, SPECIFICTESTS) {
    dispatch_queue_t queue = dispatch_queue_create("queue", NULL);
    dispatch_queue_set_specific(queue, key, context, NULL);
    
    dispatch_sync(queue, ^{
        void* firstContext = dispatch_get_specific(key);
		EXPECT_EQ(firstContext, context);
        dispatch_queue_set_specific(queue, key, context2, NULL);
    });
    
    void* secondContext = dispatch_queue_get_specific(queue, key);
	EXPECT_EQ(secondContext, context2);
    
    dispatch_sync(queue, ^{
        void* thirdContext = dispatch_get_specific(key);
		EXPECT_EQ(thirdContext, context2);
    });
}


/*

dispatch_group_t create_group(size_t count, int delayInSec) {
    size_t i;

    dispatch_group_t group = dispatch_group_create();

    for (i = 0; i < count; ++i) {
        dispatch_queue_t queue = dispatch_queue_create(NULL, NULL);
        assert(queue);

        dispatch_group_async(group,
                             queue,
                             ^{
                                 if (delayInSec) {
                                     LOG_INFO("sleeping...\n");
                                     Sleep(delayInSec * 1000LL);
                                     LOG_INFO("done.\n");
                                 }
                             });

        dispatch_release(queue);
    }
    return group;
}

TEST(Dispatch, DispatchGroup) {
    long res;
    dispatch_group_t group;

    group = create_group(100, 0);
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);

    // should be OK to re-use a group
    dispatch_group_async(group,
                         dispatch_get_global_queue(0, 0),
                         ^{
                         });
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);

    dispatch_release(group);
    group = NULL;

    group = create_group(3, 7);
	//EXPECT_NE(group, NULL);

    res = dispatch_group_wait(group, dispatch_time(DISPATCH_TIME_NOW, 5ull * NSEC_PER_SEC));
	EXPECT_NE(res, 0);

    // retry after timeout (this time succeed)
    res = dispatch_group_wait(group, dispatch_time(DISPATCH_TIME_NOW, 5ull * NSEC_PER_SEC));
    EXPECT_EQ(res, 0);

    dispatch_release(group);
    group = NULL;

    group = create_group(100, 0);
	//EXPECT_NE(group, NULL);

    dispatch_group_notify(group,
                          dispatch_get_main_queue(),
                          ^{
                              dispatch_queue_t m = dispatch_get_main_queue();
                              dispatch_queue_t c = dispatch_get_current_queue();
							  EXPECT_EQ(m, c);
                          });

    dispatch_release(group);
    group = NULL;
}
*/
/*

#import <TestFramework.h>
#import <Foundation/Foundation.h>
#import <Starboard/SmartTypes.h>
#import <dispatch/dispatch.h>
#include <dispatch/dispatch.h>

#include <Block.h>

static void* key = static_cast<void*>("ValueInQueue");
static void* context = static_cast<void*>("Prior to End of Barrier");
static void* context2 = static_cast<void*>("After End of Barrier");

TEST(Dispatch, NewTests) {
    // set up a new dispatch queue.
    dispatch_queue_t queue = dispatch_queue_create("barrierqueue", NULL);

    // asssign a specific value to this dispatch queue
    dispatch_queue_set_specific(queue, key, context, NULL);

    // The barrier function will block further operations on this particular queue
    // until the block completes.
    dispatch_barrier_async(queue, ^{
        EXPECT_EQ(dispatch_get_specific(queue, key), context);
        // Wait as if this block was doing some amount of work. This should prevent the
        // next synchronous block from returning.
        sleep(2000);
        dispatch_queue_set_specific(queue, key, context2, NULL);
    });

    // Dispatch a few async blocks to attempt to get the specific. The test will fail unless
    // the barrier block above has already completed.
    for(int i = 0; i < 5; i++) {
        dispatch_async(queue, ^{
            EXPECT_EQ(dispatch_get_specific(queue, key), context2);
        });
    }
}*/