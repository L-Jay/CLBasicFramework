//
//  NetworkViewController.m
//  CLBasicFramework
//
//  Created by L on 14-6-21.
//  Copyright (c) 2014年 L. All rights reserved.
//

#import "NetworkViewController.h"
#import "CLNetwork.h"

@interface NetworkViewController ()

@end

@implementation NetworkViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
//    /*http://cmhtech.ecartoon.net/book_content.php?bookid=55&id=372&imagesize=320480*/
//    /*http://sp.autohome.com.cn/cars/APP/BrandAll.ashx*/
//    [CLNetwork getRequestWithUrl:@"http://cmhtech.ecartoon.net/book_content.php?bookid=55&id=372&imagesize=320480" withTag:nil requestResult:^(id object, NSError *error){
//        
//        
//        
//        if (error) {
//            NSLog(@"object: %@", object);
//            NSLog(@"error %@", error);
//        }else
//            NSLog(@"object: %@", object);
//        
//    }];
    
//    /*http://soccer.frontnetwork.com/Guess/history*/
//    [CLNetwork registerNetWorkWithBasicUrl:@"http://soccer.frontnetwork.com/" constValue:nil];
//    [CLNetwork postRequestWithTypeUrl:@"Guess/history" keyAndValues:nil withTag:nil requestResult:^(id object, NSError *error){
//        
//        if (error) {
//            NSLog(@"error %@", error);
//        }else
//            NSLog(@"object: %@", object);
//        
//    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
