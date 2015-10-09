//
//  FRPGalleryViewController.m
//  FunctionalReactivePixels
//
//  Created by leoliu on 15/9/15.
//  Copyright (c) 2015年 leoliu. All rights reserved.
//

#import "FRPGalleryViewController.h"
#import "FRPGalleryFlowLayout.h"
#import "FRPPhotoImporter.h"
#import "FRPCell.h"
#import <RACDelegateProxy.h>
#import "FRPFullSizePhotoViewControler.h"

@interface FRPGalleryViewController ()

@property (nonatomic , strong) NSArray *photosArray;
@property (nonatomic, strong) id collectionViewDelegate;

@end

@implementation FRPGalleryViewController

static NSString * const reuseIdentifier = @"Cell";

- (id)init
{
    FRPGalleryFlowLayout *flowLayout = [[FRPGalleryFlowLayout alloc] init];
    self = [self initWithCollectionViewLayout:flowLayout];
    if(!self) return nil;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    //Configure self
    self.title = @"Popular on 500px";
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    //Reactive Stuff
    @weakify(self);
    [RACObserve(self, photosArray) subscribeNext:^(id x) {
        @strongify(self);
        [self.collectionView reloadData];
    }];
    
    RACDelegateProxy *viewControllerDelegate = [[RACDelegateProxy alloc] initWithProtocol:@protocol(UICollectionViewDelegate)];
    [[viewControllerDelegate rac_signalForSelector:@selector(collectionView:didSelectItemAtIndexPath:) fromProtocol:@protocol(UICollectionViewDelegate)] subscribeNext:^(id x) {
        @strongify(self);
        FRPFullSizePhotoViewControler *viewController = [[FRPFullSizePhotoViewControler alloc] initWithPhotoModels:self.photosArray currentPhotoIndex:[(NSIndexPath *)arguments.second item]];
        viewController.delegate = (id<FRPFullSizePhotoViewControllerDelegate>)viewControllerDelegate;
        
        [self.navigationController pushViewController:viewController animated:YES];
    }];
    
    //Load data
    [self loadPopularPhotos];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadPopularPhotos{
    [[FRPPhotoImporter importPhotos] subscribeNext:^(id x){
        self.photosArray = x;
    } error:^(NSError * error){
        NSLog(@"Couldn't fetch photofrom 500px: %@",error);
    }];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photosArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FRPCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    [cell setPhotoModel:self.photosArray[indexPath.row]];
    return cell;
}


- (void)userDidScroll:(FRPFullSizePhotoViewController *)viewController toPhotoAtIndex:(NSInteger)index{
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]
                                atScrollPosition:UICollectionViewScrollPositionCenteredVertically
                                        animated:NO];
}

@end
