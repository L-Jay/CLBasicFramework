//
//  ImageNetworkViewController.m
//  CLBasicFramework
//
//  Created by L on 14-6-22.
//  Copyright (c) 2014年 L. All rights reserved.
//

#import "ImageNetworkViewController.h"
#import "CLUIImageView+CLNetwork.h"

@interface ImageNetworkViewController ()

@end

@implementation ImageNetworkViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imgView.backgroundColor = [UIColor orangeColor];
    imgView.imageUrl = @"http://d.hiphotos.baidu.com/image/w%3D1920%3Bcrop%3D0%2C0%2C1920%2C1080/sign=c2d18e669e82d158bb825db8b23a22bb/d62a6059252dd42a3bec0923013b5bb5c8eab854.jpg";
    imgView.showActivityView = NO;
    [self.view addSubview:imgView];
    [imgView release];
}


@end
