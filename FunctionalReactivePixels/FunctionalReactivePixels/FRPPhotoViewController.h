//
//  FRPPhotoViewController.h
//  FunctionalReactivePixels
//
//  Created by leoliu on 15/9/16.
//  Copyright (c) 2015年 leoliu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FRPPhotoModel;

@interface FRPPhotoViewController : UIViewController
- (instancetype)initWithPhotoModel:(FRPPhotoModel *)photoModel index:(NSInteger)photoIndex;

@property (nonatomic, readonly) NSInteger photoIndex;
@property (nonatomic, readonly) FRPPhotoModel * photoModel;

@end