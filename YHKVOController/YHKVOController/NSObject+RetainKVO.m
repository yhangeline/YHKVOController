//
//  NSObject+RetainKVO.m
//  Block_KVO
//
//  Created by yh on 2017/12/14.
//  Copyright © 2017年 yh. All rights reserved.
//

#import "NSObject+RetainKVO.h"
#import <objc/runtime.h>
#import <pthread.h>

static void *_YHKVOControllerKey = &_YHKVOControllerKey;

/*****************************************************************************/

@interface _YHKVOInfo : NSObject

@property (nonatomic, weak) id object;
@property (nonatomic, copy) YHKVOChangedBlock block;
@property (nonatomic, copy) NSString *keyPath;
@property (nonatomic, assign) NSKeyValueObservingOptions options;

@end

@implementation _YHKVOInfo

- (instancetype)initWithObject:(id)object keyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options block:(YHKVOChangedBlock)block
{
    self = [super init];
    if (self) {
        _object = object;
        _keyPath = [keyPath copy];
        _options = options;
        _block = [block copy];
    }
    return self;
}

- (BOOL)isEqual:(id)object
{
    if (nil == object) {
        return NO;
    }
    if (self == object) {
        return YES;
    }
    if (![object isKindOfClass:[self class]]) {
        return NO;
    }
    return [_keyPath isEqualToString:((_YHKVOInfo *)object).keyPath];
}

- (NSUInteger)hash
{
    return [_keyPath hash];
}

@end

/*****************************************************************************/
@interface _YHKVOController : NSObject


@end

@implementation _YHKVOController
{
    NSMapTable *_mapTable;
    pthread_mutex_t _mutex;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _mapTable = [[NSMapTable alloc] initWithKeyOptions:NSPointerFunctionsStrongMemory|NSPointerFunctionsObjectPointerPersonality valueOptions:NSPointerFunctionsStrongMemory|NSPointerFunctionsObjectPointerPersonality capacity:0];
        pthread_mutex_init(&_mutex, NULL);
    }
    return self;
}

- (void)observeObject:(id)object forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options block:(YHKVOChangedBlock)block
{

    pthread_mutex_lock(&_mutex);
    
    NSMutableSet *infoSet = [_mapTable objectForKey:object];
    if (!infoSet) {
        infoSet = [NSMutableSet set];
        [_mapTable setObject:infoSet forKey:object];
    }
    _YHKVOInfo *info = [[_YHKVOInfo alloc] initWithObject:object keyPath:keyPath options:options block:block];
    if ([infoSet member:info]) {
        pthread_mutex_unlock(&_mutex);
        return;
    }
    [infoSet addObject:info];
    
    pthread_mutex_unlock(&_mutex);
    
    [object addObserver:self forKeyPath:keyPath options:options context:(void *)info];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    _YHKVOInfo *info;
    pthread_mutex_lock(&_mutex);
    NSMutableSet *infoSet = [_mapTable objectForKey:object];
    info = [infoSet member:(__bridge id)context];
    pthread_mutex_unlock(&_mutex);
    
    if (info.block) {
        info.block(keyPath, object, change);
    }
}

- (void)dealloc
{
    [self removeAllObserver];
    pthread_mutex_destroy(&_mutex);
}

- (void)removeAllObserver
{
    pthread_mutex_lock(&_mutex);
    NSMapTable *mapTable = [_mapTable copy];
    [_mapTable removeAllObjects];
    
    for (id object in mapTable) {
        NSMutableSet *set = [mapTable objectForKey:object];
        for (_YHKVOInfo *info in set) {
            [info.object removeObserver:self forKeyPath:info.keyPath];
        }
    }
    
    pthread_mutex_unlock(&_mutex);
}

@end

/*****************************************************************************/

@implementation NSObject (RetainKVO)

- (void)yh_observeObject:(id)object forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options block:(YHKVOChangedBlock)block
{
    NSParameterAssert(block != nil);
    
    _YHKVOController *kvoController = objc_getAssociatedObject(self, _YHKVOControllerKey);
    if (!kvoController) {
        kvoController = [[_YHKVOController alloc] init];
        objc_setAssociatedObject(self, _YHKVOControllerKey, kvoController, OBJC_ASSOCIATION_RETAIN);
    }
    [kvoController observeObject:object forKeyPath:keyPath options:options block:block];
}

@end

/*****************************************************************************/
