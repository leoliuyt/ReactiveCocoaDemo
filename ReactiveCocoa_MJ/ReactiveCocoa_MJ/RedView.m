//
//  RedView.m
//  ReactiveCocoa_MJ
//
//  Created by leoliu on 15/10/12.
//  Copyright © 2015年 leoliu. All rights reserved.
//

#import "RedView.h"

@interface RedView()

@property (nonatomic, strong) UIButton *btn;

@end

@implementation RedView

- (void)awakeFromNib
{
    self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btn setTitle:@"action" forState:UIControlStateNormal];
    self.btn.frame = CGRectMake(0, 40, 100, 40);
    @weakify(self);
    [[self.btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        NSLog(@"我被点击了");
        @strongify(self);
        [self btnClicka];
    }];
    [self addSubview:self.btn];
}

- (instancetype) init
{
    if (self = [super init]) {
        self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.btn setTitle:@"action" forState:UIControlStateNormal];
        self.btn.frame = CGRectMake(0, 40, 100, 40);
        @weakify(self);
        [[self.btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            NSLog(@"我被点击了");
            @strongify(self);
            [self btnClicka];
        }];
        [self addSubview:self.btn];
    }
    return self;
}

- (void)btnClicka
{
    NSLog(@"click");
}

@end
