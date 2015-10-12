//
//  SecondViewController.h
//  ReactiveCocoa_MJ
//
//  Created by leoliu on 15/10/9.
//  Copyright © 2015年 leoliu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecondViewController : UIViewController

@property (nonatomic, strong) RACSubject *delegateSignal;

@end
