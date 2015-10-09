//
//  FRPFullSizePhotoViewControler.m
//  FunctionalReactivePixels
//
//  Created by leoliu on 15/9/16.
//  Copyright (c) 2015年 leoliu. All rights reserved.
//

#import "FRPFullSizePhotoViewControler.h"
#import "FRPPhotoViewController.h"
#import "FRPPhotoModel.h"

@interface FRPFullSizePhotoViewControler ()<UIPageViewControllerDataSource, UIPageViewControllerDelegate>
//Private assignment
@property (nonatomic, strong) NSArray *photoModeArray;
//Private properties
@property (nonatomic, strong) UIPageViewController *pageViewController;

@end


@implementation FRPFullSizePhotoViewControler

- (instancetype)initWithPhotoModels:(NSArray *)photoModelArray currentPhotoIndex:(NSInteger)photoIndex{
    self = [self init];
    if (!self) return nil;
    
    //Initialized, read-only properties
    self.photoModeArray = photoModelArray;
    
    //Configure self
//    self.title = [self.photoModelArray[photoIndex] photoName];
    
    //ViewControllers
    self.pageViewController = [[UIPageViewController alloc]
        initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
        navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
        options:@{ UIPageViewControllerOptionInterPageSpacingKey: @(30)}];
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;
    [self addChildViewController:self.pageViewController];
    
//    [self.pageViewController setViewController:@[[self photoViewControllerForIndex:photoIndex]]
//                                     direction:UIPageViewControllerNavigationDirectionForward
//                                      animated:NO completion:nil ];
    [self.pageViewController setViewControllers:@[[self photoViewControllerForIndex:photoIndex]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    self.pageViewController.view.frame = self.view.bounds;
    
    [self.view addSubview:self.pageViewController.view];
}

- (void)pageViewController:(UIPageViewController *)pageViewController
        didFinishAnimating: (BOOL)finished
   previousViewControllers:(NSArray *)previousViewControllers
       transitionCompleted:(BOOL)completed{
    self.title = [[self.pageViewController.viewControllers.firstObject photoModel] photoName];
    [self.delegate userDidScroll:self toPhotoAtIndex:[self.pageViewController.viewControllers.firstObject photoIndex]];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(FRPPhotoViewController *)viewController{
    return [self photoViewControllerForIndex:viewController.photoIndex - 1];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(FRPPhotoViewController *)viewController {
    return [self photoViewControllerForIndex:viewController.photoIndex + 1];
}


- (FRPPhotoViewController *)photoViewControllerForIndex:(NSInteger)index{
    if (index >= 0 && index < self.photoModelArray.count){
        FRPPhotoModel *photoModel = self.photoModelArray[index];
        
        FRPPhotoViewController *photoViewController = [[FRPPhotoViewController alloc] initWithPhotoModel:photoModel index:index];
        
        return photoViewController;
    }
    
    //Index was out of bounds, return nil
    return nil;
}
@end
