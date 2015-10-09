//
//  FRPFullSizePhotoViewControler.h
//  FunctionalReactivePixels
//
//  Created by leoliu on 15/9/16.
//  Copyright (c) 2015年 leoliu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FRPFullSizePhotoViewController;

@protocol FRPFullSizePhotoViewControllerDelegate <NSObject>
- (void)userDidScroll:(FRPFullSizePhotoViewController *)viewController toPhotoAtIndex:(NSInteger)index;

@end

@interface FRPFullSizePhotoViewControler : UIViewController

- (instancetype)initWithPhotoModels:(NSArray *)photoModelArray currentPhotoIndex:(NSInteger)photoIndex;

@property (nonatomic , readonly) NSArray *photoModelArray;

@property (nonatomic, weak) id<FRPFullSizePhotoViewControllerDelegate> delegate;

@end
