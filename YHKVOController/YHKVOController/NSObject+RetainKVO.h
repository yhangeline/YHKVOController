//
//  NSObject+RetainKVO.h
//  Block_KVO
//
//  Created by yh on 2017/12/14.
//  Copyright © 2017年 yh. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^YHKVOChangedBlock)(NSString *keyPath, id object, NSDictionary<NSKeyValueChangeKey,id> *change);

@interface NSObject (RetainKVO)

- (void)yh_observeObject:(id)object forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options block:(YHKVOChangedBlock)block;

@end
