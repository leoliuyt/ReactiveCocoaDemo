//
//  FRPCell.m
//  FunctionalReactivePixels
//
//  Created by leoliu on 15/9/15.
//  Copyright (c) 2015年 leoliu. All rights reserved.
//

#import "FRPCell.h"
#import "FRPPhotoModel.h"

@interface FRPCell ()
@property (nonatomic , weak) UIImageView * imageView;
@property (nonatomic , strong) RACDisposable *subscription;
@end

@implementation FRPCell

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(!self) return nil;
    
    //Configure self
    self.backgroundColor = [UIColor darkGrayColor];
    
    //Configure subviews
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.contentView addSubview:imageView];
    self.imageView = imageView;
    
    return self;
}

- (void)setPhotoModel:(FRPPhotoModel *)photoModel{
    self.subscription = [[[RACObserve(photoModel, thumbnailData)
                           filter:^ BOOL (id value){
                               return value != nil;
                           }] map:^id (id value){
                               return [UIImage imageWithData:value];
                           }] setKeyPath:@keypath(self.imageView, image) onObject:self.imageView];
}

- (void)perpareForReuse {
    [super prepareForReuse];
    
    [self.subscription dispose];
    self.subscription = nil;
}
@end
