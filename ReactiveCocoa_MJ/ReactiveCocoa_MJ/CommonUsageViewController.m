//
//  CommonUsageViewController.m
//  ReactiveCocoa_MJ
//
//  Created by leoliu on 15/10/12.
//  Copyright © 2015年 leoliu. All rights reserved.
//

#import "CommonUsageViewController.h"
#import "RedView.h"
@interface CommonUsageViewController ()
@property (weak, nonatomic) IBOutlet RedView *redView;
@property (weak, nonatomic) IBOutlet UIButton *btn;

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UILabel *label;
@end

@implementation CommonUsageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self demo3];
    
    [self demo4];
    self.view.center = CGPointMake(160, 160);
    
    [self demo5];
}

- (void)demo1
{
    // 1.代替代理
    // 需求：自定义redView,监听红色view中按钮点击
    // 之前都是需要通过代理监听，给红色View添加一个代理属性，点击按钮的时候，通知代理做事情
    // rac_signalForSelector:把调用某个对象的方法的信息转换成信号，就要调用这个方法，就会发送信号。
    // 这里表示只要redV调用btnClick:,就会发出信号，订阅就好了。
    [[self.redView rac_signalForSelector:@selector(btnClicka)]subscribeNext:^(id x) {
        NSLog(@"代理使用");
    }];
    
    
    // 2.KVO
    // 把监听redV的center属性改变转换成信号，只要值改变就会发送信号
    // observer:可以传入nil
    [[self.redView rac_valuesAndChangesForKeyPath:@"name" options:NSKeyValueObservingOptionNew observer:nil]subscribeNext:^(RACTuple *x) {
        NSLog(@"%@",x);
        
        RACTupleUnpack(NSString*name,NSDictionary *dic) = x;
        
        NSLog(@"%@-%@-%@",name,dic[@"kind"],dic[@"new"]);
    }];
    
    self.redView.name = @"leoliu";
    
    // 3.监听事件
    // 把按钮点击事件转换为信号，点击按钮，就会发送信号
    [[self.btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        NSLog(@"按钮被点击了");
    }];
    
    // 4.代替通知
    // 把监听到的通知转换信号
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillShowNotification object:nil] subscribeNext:^(id x) {
        NSLog(@"键盘弹出");
    }];
    
    [[self.textField rac_textSignal] subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
}

- (void)demo2
{
    // 6.处理多个请求，都返回结果的时候，统一做处理.
    
    RACSignal *signal1 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"请求1");
        [subscriber sendNext:@"请求1"];
        [subscriber sendCompleted];
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"over");
        }];
    }];
    
    RACSignal *signal2 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"请21");
        [subscriber sendNext:@"请求2"];
        [subscriber sendCompleted];
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"over");
        }];
    }];
    
    [self rac_liftSelector:@selector(updateUIWithData1:data2:) withSignalsFromArray:@[signal1,signal2]];
}

- (void)demo3
{
//    RAC(TARGET, [KEYPATH, [NIL_VALUE]]):用于给某个对象的某个属性绑定
    
    RAC(self.label,text) = self.textField.rac_textSignal;
}

- (void)demo4
{
//    RACObserve(self, name):监听某个对象的某个属性,返回的是信号
//    [RACObserve(self.view, center) subscribeNext:^(id x) {
//        NSLog(@"%@",x);
//    }];
    
    [RACObserve(self.label, text) subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
}

- (void)demo5
{
//    RACTuplePack：把数据包装成RACTuple（元组类）
//    RACTupleUnpack：把RACTuple（元组类）解包成对应的数据
    
    RACTuple *tupe = RACTuplePack(@"name",@"leoliu");
    RACTupleUnpack(NSString *name,NSString *str) = tupe;
    
    NSLog(@"%@,%@",name,str);
}

- (void)updateUIWithData1:(id)data1 data2:(id)data2
{
    NSLog(@"%@-%@",data1,data2);
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [self demo3];
}

@end
