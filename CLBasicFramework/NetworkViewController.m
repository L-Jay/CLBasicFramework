//
//  NetworkViewController.m
//  CLBasicFramework
//
//  Created by L on 14-6-21.
//  Copyright (c) 2014年 L. All rights reserved.
//

#import "NetworkViewController.h"
#import "CLNetwork.h"
#import "CLHUD.h"
#import "CLBasicFramework.h"

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
    
//    [CLNetwork getRequestWithUrl:@"http://cmhtech.ecartoon.net/book_content.php?bookid=55&id=372&imagesize=320480" withTag:@"justtest" requestResultWithTag:^(id object, NSError *error, NSString *tag) {
//        if (error) {
//            NSLog(@"object: %@", object);
//            NSLog(@"error %@", error);
//        }else
//            NSLog(@"object: %@", object);
//        
//        NSLog(@"tag  =-=-= %@", tag);
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
    
//    [CLNetwork postRequestWithTypeUrl:@"Guess/history" keyAndValues:nil withTag:@"test" requestResultWithTag:^(id object, NSError *error, NSString *tag) {
//        if (error) {
//            NSLog(@"error %@", error);
//        }else
//            NSLog(@"object: %@", object);
//        
//        NSLog(@"tag: === %@", tag);
//    }];
//    
//    [CLNetwork postRequestWithTypeUrl:@"Guess/history" keyAndValues:nil withTag:@"test" requestResultWithTag:^(id object, NSError *error, NSString *tag) {
//        if (error) {
//            NSLog(@"error %@", error);
//        }else
//            NSLog(@"object: %@", object);
//        
//        NSLog(@"tag: === %@", tag);
//    }];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"post" style:UIBarButtonItemStyleBordered target:self action:@selector(postImage)];


//    [CLNetwork registerNetWorkWithBasicUrl:@"http://www.thefront.com.cn/zqjcw2/" constValue:nil];
//    
//    NSDictionary *dic = @{@"mobile": @"18600635255", @"pwd": @"111222"};
//    [CLNetwork postRequestWithTypeUrl:@"user/login" keyAndValues:dic withTag:@"login" requestResult:^(id Object, NSError *error) {
//        if (error) {
//            NSLog(@"error %@", error);
//        }else {
//            NSLog(@"obj %@", Object);
//        }
//    }];
}

- (void)postImage
{
//    UIImage *img = [UIImage imageNamed:@"test.jpg"];
//    
//    [CLNetwork postImageRequestWithTypeUrl:@"user/change_avatar" keyAndValues:nil image:img withTag:nil requestResult:^(id object, NSError *error) {
//        if (error) {
//            NSLog(@"error %@", error);
//        }else {
//            NSLog(@"obj %@", object);
//            [CLHUD showFailedWithText:[object objectForKey:@"msg"]];
//        }
//    }];
    
//    NSData *imgData = UIImageJPEGRepresentation([UIImage imageNamed:@"lanzhu"], 0.5);
//    
//    [CLNetwork postImageRequestWithTypeUrl:@"user/change_avatar" keyAndValues:nil imageData:imgData withTag:nil requestResult:^(id object, NSError *error) {
//        if (error) {
//            NSLog(@"error %@", error);
//        }else {
//            NSLog(@"obj %@", object);
//            [CLHUD showFailedWithText:[object objectForKey:@"msg"]];
//        }
//    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
