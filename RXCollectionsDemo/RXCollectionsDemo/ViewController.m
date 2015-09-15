//
//  ViewController.m
//  RXCollectionsDemo
//
//  Created by leoliu on 15/9/15.
//  Copyright (c) 2015年 leoliu. All rights reserved.
//

#import "ViewController.h"
#import <RXCollections/RXCollection.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *arr = @[@1,@2,@3];
    //映射
    NSLog(@"------映射-----");
    NSArray * mappedArray = [arr rx_mapWithBlock:^id(id each){
        return @(pow([each integerValue],2));
    }];
    [mappedArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSLog(@"map = %@",obj);
    }];
    
    NSLog(@"-----过滤------");
    
    NSArray *filteredArray = [arr rx_filterWithBlock:^BOOL(id each) {
        return ([each integerValue]>=2);
    }];
    [filteredArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSLog(@"filter = %@",obj);
    }];
    
    NSLog(@"-----Flod------");
    NSNumber *sum = [arr rx_foldWithBlock:^id(id memo, id each) {
        return @([memo integerValue]+[each integerValue]);
    }];
    NSLog(@"sum = %@",sum);
    
    NSLog(@"----FlodStr-----");
    NSString *floderStr = [[arr rx_mapWithBlock:^id(id each) {
        return [each stringValue];
    }] rx_foldInitialValue:@"" block:^id(id memo, id each) {
        return [memo stringByAppendingString:each];
    }];
    NSLog(@"flodStr = %@",floderStr);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
