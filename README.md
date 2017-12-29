
# 一句话使用KVO

#### 传统KVO：
1. 需要手动移除观察者，且移除观察者的时机必须合适；
2. 注册观察者的代码和事件发生处的代码上下文不同，传递上下文是通过 void * 指针；
3. 需要覆写 -observeValueForKeyPath:ofObject:change:context: 方法，比较麻烦；
4. 在复杂的业务逻辑中，准确判断被观察者相对比较麻烦，有多个被观测的对象和属性时，需要在方法中写大量的 if 进行判断；

#### YHKVOController：

1. 不需要手动移除观察者；
2. 实现 KVO 与事件发生处的代码上下文相同，不需要跨方法传参数；
3. 使用 block 来替代方法能够减少使用的复杂度，提升使用 KVO 的体验；
4. 每一个 keyPath 会对应一个属性，不需要在 block 中使用 if 判断 keyPath

### 使用方法

```
[self yh_observeObject:self.testObj forKeyPath:@"name" options:NSKeyValueObservingOptionNew block:^(NSString *keyPath, id object, NSDictionary<NSKeyValueChangeKey,id> *change) {
        NSLog(@"name changed : %@",change);
    }];

```

注意：

```
[self yh_observeObject:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew block:^(NSString *keyPath, id object, NSDictionary<NSKeyValueChangeKey,id> *change) {
        [weakSelf doSomething];
    }];
	
```

这里实现的时候self对block间接强引用了，使用self会造成循环引用，