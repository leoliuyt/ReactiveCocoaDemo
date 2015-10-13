//
//  RACSignalSimpleUseViewController.m
//  ReactiveCocoa_MJ
//
//  Created by leoliu on 15/10/9.
//  Copyright © 2015年 leoliu. All rights reserved.
//

#import "RACSignalSimpleUseViewController.h"
#import "SecondViewController.h"

@interface RACSignalSimpleUseViewController ()

@property (nonatomic, strong) RACCommand *command;

@end

@implementation RACSignalSimpleUseViewController

- (IBAction)signalUseAction:(id)sender {
    
    // RACSignal使用步骤：
    // 1.创建信号 + (RACSignal *)createSignal:(RACDisposable * (^)(id<RACSubscriber> subscriber))didSubscribe
    // 2.发送信号 - (void)sendNext:(id)value
    // 3.订阅信号，才会激活信号 - (RACDisposable *)subscribeNext:(void (^)(id x))nextBlock
    // RACSignal底层实现：
    // 1.创建信号，首先把didSubscribe保存到信号中，还不会触发。
    // 2.当信号被订阅，也就是调用signal的subscribeNext:nextBlock
    // 2.1 subscribeNext内部会创建订阅者subscriber，并且把nextBlock保存到subscriber中。
    // 2.2 subscribeNext内部会调用siganl的didSubscribe
    // 3.siganl的didSubscribe中调用[subscriber sendNext:@1];
    // 3.1 sendNext底层其实就是执行subscriber的nextBlock
    
    //1.创建信号
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        //block调用时刻：每当有订阅者订阅信号，就会调用block
        
        //2.发送信号
        [subscriber sendNext:@(11)];
        
        //如果不再发送数据，最好发送信号完成，内部会制动调用[RACDisposable disposable]取消订阅信号。
        [subscriber sendCompleted];
        return [RACDisposable disposableWithBlock:^{
            
            //block调用时刻：当信号发送完成后者发送错误，就会自动执行这个block，取消订阅信号。
            
            //执行完block后，当前信号就不在被订阅了。
            
            NSLog(@"信号被销毁");
        }];
    }];
    
    //3.订阅信号，才会激活信号。
    [signal subscribeNext:^(id x) {
        //block调用时刻：每当有信号发出数据，就会调用block。
        NSLog(@"接收到数据:%@",x);
    }];
}

- (IBAction)subjectAction:(id)sender {
    //RACSubject使用步骤
    // 1.创建信号 [RACSubject subject],跟RACSignal不一样，创建信号时没有block。
    // 2.订阅信号 - (RACDisposable *)subscribeNext:(void (^)(id x))nextBlock
    // 3.发送信号 sendNext:(id)value
    
    // RACSubject:底层实现和RACSignal不一样。
    // 1.调用subscribeNext订阅信号，只是把订阅者保存起来，并且订阅者的nextBlock已经赋值了。
    // 2.调用sendNext发送信号，遍历刚刚保存的所有订阅者，一个一个调用订阅者的nextBlock。
    
//    // 1.创建信号
//    RACSubject *subject = [RACSubject subject];
//    
//    // 2.订阅信号
//    [subject subscribeNext:^(id x) {
//        //block 调用时刻：当信号发出新值，就会调用。
//        NSLog(@"第一个订阅者%@",x);
//    }];
//    
//    [subject subscribeNext:^(id x) {
//        //block 调用时刻：当信号发出新值，就会调用。
//        NSLog(@"第二个订阅者%@",x);
//    }];
//    
//    // 3.发送信号
//    [subject sendNext:@"1"];
    
    
    // RACReplaySubject使用步骤:
    // 1.创建信号 [RACReplaySubject subject]，跟RACSiganl不一样，创建信号时没有block。
    // 2.可以先订阅信号，也可以先发送信号。
    // 2.1 订阅信号 - (RACDisposable *)subscribeNext:(void (^)(id x))nextBlock
    // 2.2 发送信号 sendNext:(id)value
    
    // RACReplaySubject:底层实现和RACSubject不一样。
    // 1.调用sendNext发送信号，把值保存起来，然后遍历刚刚保存的所有订阅者，一个一个调用订阅者的nextBlock。
    // 2.调用subscribeNext订阅信号，遍历保存的所有值，一个一个调用订阅者的nextBlock
    
    // 如果想当一个信号被订阅，就重复播放之前所有值，需要先发送信号，在订阅信号。
    // 也就是先保存值，在订阅值。
    
    //1.创建信号
    RACReplaySubject *replaySubject = [RACReplaySubject subject];
    
    //2.发送信号
    [replaySubject sendNext:@1];
    [replaySubject sendNext:@2];
    
    //3.订阅信号
    [replaySubject subscribeNext:^(id x) {
        NSLog(@"第一个订阅者接收到的数据:%@",x);
    }];
    
    [replaySubject subscribeNext:^(id x) {
        NSLog(@"第二个订阅者接收到的数据:%@",x);
    }];
}
- (IBAction)segueneAndTupleAction:(id)sender {
    // 1.遍历数组
    NSArray *numbers = @[@1,@2,@3,@4];
    
    // 这里其实是三步
    // 第一步: 把数组转换成集合RACSequence numbers.rac_sequence
    // 第二步: 把集合RACSequence转换RACSignal信号类,numbers.rac_sequence.signal
    // 第三步: 订阅信号，激活信号，会自动把集合中的所有值，遍历出来。
    
    [numbers.rac_sequence.signal subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    
    // 2.遍历字典,遍历出来的键值对会包装成RACTuple(元组对象)
    NSDictionary *dict = @{@"name":@"xmg",@"age":@18};
    [dict.rac_sequence.signal subscribeNext:^(RACTuple *x) {
        //解包元组，会把元组的值，按顺序给参数里面的变量赋值
        RACTupleUnpack(NSString *key,NSString *value) = x;
        NSLog(@"%@ %@ %@",x,key,value);
    }];
}
- (IBAction)commandAction:(id)sender {
    // 一、RACCommand使用步骤:
    // 1.创建命令 initWithSignalBlock:(RACSignal * (^)(id input))signalBlock
    // 2.在signalBlock中，创建RACSignal，并且作为signalBlock的返回值
    // 3.执行命令 - (RACSignal *)execute:(id)input
    
    // 二、RACCommand使用注意:
    // 1.signalBlock必须要返回一个信号，不能传nil.
    // 2.如果不想要传递信号，直接创建空的信号[RACSignal empty];
    // 3.RACCommand中信号如果数据传递完，必须调用[subscriber sendCompleted]，这时命令才会执行完毕，否则永远处于执行中。
    // 4.RACCommand需要被强引用，否则接收不到RACCommand中的信号，因此RACCommand中的信号是延迟发送的。
    
    // 三、RACCommand设计思想：内部signalBlock为什么要返回一个信号，这个信号有什么用。
    // 1.在RAC开发中，通常会把网络请求封装到RACCommand，直接执行某个RACCommand就能发送请求。
    // 2.当RACCommand内部请求到数据的时候，需要把请求的数据传递给外界，这时候就需要通过signalBlock返回的信号传递了。
    
    // 四、如何拿到RACCommand中返回信号发出的数据。
    // 1.RACCommand有个执行信号源executionSignals，这个是signal of signals(信号的信号),意思是信号发出的数据是信号，不是普通的类型。
    // 2.订阅executionSignals就能拿到RACCommand中返回的信号，然后订阅signalBlock返回的信号，就能获取发出的值。
    
    // 五、监听当前命令是否正在执行executing
    
    // 六、使用场景,监听按钮点击，网络请求
    
    
    // 1.创建命令
    RACCommand *command = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        NSLog(@"执行命令 传入值%@",input);
        
        // 创建空信号，必须返回信号
        // 2.创建信号用来传递数据
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendNext:@"开始请求"];
            // 注意：数据传递完，最好调用sendCompleted，这时命令才执行完毕。
            [subscriber sendCompleted];
//            return [RACDisposable disposableWithBlock:^{
//                NSLog(@"销毁");
//            }];
            return nil;
        }];
    }];
    
    //强引用command 防止被销毁 否则接受不到信号
    self.command = command;
//    [[self.command execute:@2] subscribeNext:^(id x) {
//        NSLog(@"%@",x);
//    }];
    
    // 3.订阅command中的信号
    [command.executionSignals subscribeNext:^(id x) {
        [x subscribeNext:^(id x) {
            NSLog(@"%@",x);
        }];
    }];
    
    //RAC高级用法
    //switchToLatest：用于signal of signals 获取signal of signals发出的最新信号，也就是可以直接拿到RACCommand中的信号
    [command.executionSignals.switchToLatest subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    
    
    // 4.执行命令
    [self.command execute:@1];
//    [[self.command execute:@1] subscribeNext:^(id x) {
//        NSLog(@"%@",x);
//    }];
    
    // 5.监听命令是否执行完毕，默认回来一次，可以直接跳过，skip表示跳过第一次信号
    [[command.executing skip:1] subscribeNext:^(id x) {
        if ([x boolValue] == YES) {
            NSLog(@"正在执行");
        }else
        {
            NSLog(@"执行完毕");
        }
    }];
}
- (IBAction)muticastConnectAction:(id)sender {
    // RACMulticastConnection使用步骤:
    // 1.创建信号 + (RACSignal *)createSignal:(RACDisposable * (^)(id<RACSubscriber> subscriber))didSubscribe
    // 2.创建连接 RACMulticastConnection *connect = [signal publish];
    // 3.订阅信号,注意：订阅的不在是之前的信号，而是连接的信号。 [connect.signal subscribeNext:nextBlock]
    // 4.连接 [connect connect]
    
    // RACMulticastConnection底层原理:
    // 1.创建connect，connect.sourceSignal -> RACSignal(原始信号)  connect.signal -> RACSubject
    // 2.订阅connect.signal，会调用RACSubject的subscribeNext，创建订阅者，而且把订阅者保存起来，不会执行block。
    // 3.[connect connect]内部会订阅RACSignal(原始信号)，并且订阅者是RACSubject
    // 3.1.订阅原始信号，就会调用原始信号中的didSubscribe
    // 3.2 didSubscribe，拿到订阅者调用sendNext，其实是调用RACSubject的sendNext
    // 4.RACSubject的sendNext,会遍历RACSubject所有订阅者发送信号。
    // 4.1 因为刚刚第二步，都是在订阅RACSubject，因此会拿到第二步所有的订阅者，调用他们的nextBlock
    
    
    // 需求：假设在一个信号中发送请求，每次订阅一次都会发送请求，这样就会导致多次请求。
    // 解决：使用RACMulticastConnection就能解决.
    
//    // 1.创建请求信号
//    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//        NSLog(@"--发送信号");
//        [subscriber sendNext:@"发送信号"];
//        [subscriber sendCompleted];
//        return [RACDisposable disposableWithBlock:^{
//            NSLog(@"销毁");
//        }];
//    }];
//    
//    [signal subscribeNext:^(id x) {
//        NSLog(@"订阅信号1--%@",x);
//    }];
//    
//    [signal subscribeNext:^(id x) {
//        NSLog(@"订阅信号2--%@",x);
//    }];
    
    
    
    // 1.创建请求信号
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"--发送信号");
        [subscriber sendNext:@"发送信号"];
        [subscriber sendCompleted];
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"销毁");
        }];
    }];
    
    RACMulticastConnection *connect = [signal publish];
    
    [connect.signal subscribeNext:^(id x) {
        NSLog(@"订阅信号1--%@",x);
    }];
    
    [connect.signal subscribeNext:^(id x) {
        NSLog(@"订阅信号2--%@",x);
    }];
    
    [connect connect];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"SecondVC"]) {
        SecondViewController *vc = (SecondViewController *)segue.destinationViewController;
        vc.delegateSignal = [RACSubject subject];
        [vc.delegateSignal subscribeNext:^(id x) {
            NSLog(@"接收到信息：%@",x);
        }];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
