//
//  ViewController.m
//  ReactiveCocoaDemo
//
//  Created by leoliu on 15/9/15.
//  Copyright (c) 2015年 leoliu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *createAccountBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *array = @[@1,@2,@3];
    RACSequence *stream = [array rac_sequence];
    
    //map
    NSLog(@"------map------");
    RACSequence *streamArr = [stream map:^id(id value) {
        return @(pow([value intValue], 2));
    }];
    NSLog(@"stream map = %@",[streamArr array]);
    
    //filter
    RACSequence *StreamFilter = [stream filter:^BOOL(id value) {
        return @([value intValue] % 2 == 0);
    }];
    NSLog(@"stream filter = %@",[StreamFilter array]);
    
    //flod
    NSLog(@"------flod------");
    RACSequence *streamFlod = [stream foldLeftWithStart:@0 reduce:^id(id accumulator, id value) {
        return @([accumulator intValue] + [value intValue]);
    }];
    NSLog(@"streamFlod = %@",streamFlod);
    
    //fold
    NSLog(@"------map-fold-----");
    RACSequence *streamMapFold = [[stream map:^id(id value) {
        return [value stringValue];
    }] foldLeftWithStart:@"" reduce:^id(id accumulator, id value) {
        return [accumulator stringByAppendingString:value];
    }];
    NSLog(@"streamMapFold = %@",streamMapFold);
    
    
    NSLog(@"------textFiled-----");
    [self.textField.rac_textSignal subscribeNext:^(NSString *x) {
        NSLog(@"输出 %@",x);
    }];
    
    RACSignal *validSignal = [self.textField.rac_textSignal map:^id(NSString *value) {
        return @([value rangeOfString:@"@"].location != NSNotFound);
    }];
    
//    //状态推导
//    RAC(self.createAccountBtn,enabled) = validSignal;
    
    //指令 RACCommand
    self.createAccountBtn.rac_command = [[RACCommand alloc]initWithEnabled:validSignal signalBlock:^RACSignal *(id input) {
        NSLog(@"button is pressed");
        return [RACSignal empty];
    }];
    
    //状态推导
    RAC(self.textField, textColor) = [validSignal map:^id(id value) {
        if ([value boolValue]) {
            return [UIColor greenColor];
        }else
            return [UIColor redColor];
    }];
    
    //RACSubject 一个可变的状态。她是一个你可以主动发送新值的信号。出于这个原因，除非情况特殊，我们不推荐使用她
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
