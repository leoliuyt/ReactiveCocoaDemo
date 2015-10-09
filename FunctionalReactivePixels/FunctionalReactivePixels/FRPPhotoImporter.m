//
//  FRPPhotoImporter.m
//  FunctionalReactivePixels
//
//  Created by leoliu on 15/9/15.
//  Copyright (c) 2015年 leoliu. All rights reserved.
//

#import "FRPPhotoImporter.h"
#import "FRPPhotoModel.h"
#import "AppDelegate.h"

@implementation FRPPhotoImporter

+ (RACSignal *)importPhotos
{
    RACReplaySubject *subject = [RACReplaySubject subject];
    NSURLRequest * request = [self popularURLRequest];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError){
                               if (data) {
                                   id results = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

                                   [subject sendNext:[[[results[@"photos"] rac_sequence] map:^id(NSDictionary *photoDictionary){
                                       FRPPhotoModel * model = [FRPPhotoModel new];
                                       [self configurePhotoModel:model withDictionary:photoDictionary];
                                       [self downloadThumbnailForPhotoModel:model];
                                       return model;
                                   }] array]];
                                    
                                    [subject sendCompleted];
                                    }
                                    else{
                                        [subject sendError:connectionError];
                                    }
                                    }];
    return subject;
}
                               
+ (NSURLRequest *)popularURLRequest {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    return [appDelegate.apiHelper urlRequestForPhotoFeature:PXAPIHelperPhotoFeaturePopular
                                             resultsPerPage:100 page:0
                                                 photoSizes:PXPhotoModelSizeThumbnail
                                                  sortOrder:PXAPIHelperSortOrderRating
                                                     except:PXPhotoModelCategoryNude];
}
                               
+ (void)configurePhotoModel:(FRPPhotoModel *)photomodel withDictionary:(NSDictionary *)dictionary{
    photomodel.photoName = dictionary[@"name"];
    photomodel.identifier = dictionary[@"id"];
    photomodel.photographerName = dictionary[@"user"][@"username"];
    photomodel.rating = dictionary[@"rating"];
    photomodel.thumbnailURL = [self urlForImageSize:3 inDictionary:dictionary[@"images"]];
    //Extended attributes fetched with subsequent request
    if (dictionary[@"comments_count"]){
       photomodel.fullsizedURL = [self urlForImageSize:4 inDictionary:dictionary[@"images"]];
    }
}

+ (NSString *)urlForImageSize:(NSInteger)size inDictionary:(NSArray *)array{
    return [[[[[array rac_sequence] filter:^ BOOL (NSDictionary * value){
        return [value[@"size"] integerValue] == size;
    }] map:^id (id value){
        return value[@"url"];
    }] array] firstObject];
}

+ (void)downloadThumbnailForPhotoModel:(FRPPhotoModel *)photoModel{
    NSAssert(photoModel.thumbnailURL, @"Thumbnail URL must not be nil");
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:photoModel.thumbnailURL]];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError * connectionError){
                               photoModel.thumbnailData = data;
                           }];
}

@end
