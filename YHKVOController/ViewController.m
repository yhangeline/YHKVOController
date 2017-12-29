//
//  ViewController.m
//  YHKVOController
//
//  Created by yh on 2017/12/15.
//  Copyright © 2017年 yh. All rights reserved.
//

#import "ViewController.h"
#import "TestClass.h"
#import "NSObject+RetainKVO.h"

@interface ViewController ()

@property (nonatomic, strong) TestClass *testObj;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self yh_observeObject:self.testObj forKeyPath:@"name" options:NSKeyValueObservingOptionNew block:^(NSString *keyPath, id object, NSDictionary<NSKeyValueChangeKey,id> *change) {
        NSLog(@"name changed : %@",change);
    }];
    
    __weak typeof(self) ws = self;
    [self yh_observeObject:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew block:^(NSString *keyPath, id object, NSDictionary<NSKeyValueChangeKey,id> *change) {
        NSLog(@"title changed : %@",change);
        NSLog(@"%@",ws.title);
    }];
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.testObj.name = @"yhyhyh";
    self.title = @"1111";
}

- (TestClass *)testObj
{
    if (!_testObj) {
        _testObj = [[TestClass alloc] init];
    }
    return _testObj;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
