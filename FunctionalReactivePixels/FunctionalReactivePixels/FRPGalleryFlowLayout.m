//
//  FRPGalleryFlowLayout.m
//  FunctionalReactivePixels
//
//  Created by leoliu on 15/9/15.
//  Copyright (c) 2015年 leoliu. All rights reserved.
//

#import "FRPGalleryFlowLayout.h"

@implementation FRPGalleryFlowLayout

- (instancetype)init
{
    if (!(self = [super init])) {
        return nil;
    }
    self.itemSize = CGSizeMake(145, 145);
    self.minimumInteritemSpacing = 10;
    self.minimumLineSpacing = 10;
    self.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    return self;
}

@end
