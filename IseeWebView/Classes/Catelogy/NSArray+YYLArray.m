//
//  NSArray+YYLArray.m
//  IseeWebView
//
//  Created by 余友良 on 2020/11/6.
//  Copyright © 2020 dxzx. All rights reserved.
//

#import "NSArray+YYLArray.h"
#import "objc/runtime.h"

@implementation NSArray (YYLArray)
+ (void)load {
    Method fromMethod = class_getInstanceMethod(objc_getClass("__NSArrayI"), @selector(objectAtIndex:));
    Method toMethod = class_getInstanceMethod(objc_getClass("__NSArrayI"), @selector(yyl_objectAtIndex:));
    method_exchangeImplementations(fromMethod, toMethod);
}

- (id)yyl_objectAtIndex:(NSUInteger)index {
    if (self.count-1 < index) {
        // 这里做一下异常处理，不然都不知道出错了。
        @try {
            return [self yyl_objectAtIndex:index];
        }
        @catch (NSException *exception) {
            // 在崩溃后会打印崩溃信息，方便我们调试。
            NSLog(@"---------- %s Crash Because Method %s  ----------\n", class_getName(self.class), __func__);
            NSLog(@"%@", [exception callStackSymbols]);
            return nil;
        }
        @finally {}
    } else {
        return [self yyl_objectAtIndex:index];
    }
}
@end
