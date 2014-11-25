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

@property (nonatomic, retain) UIImageView *imgView;

@end

@implementation ImageNetworkViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"get" style:UIBarButtonItemStyleBordered target:self action:@selector(getImage)];
	
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imgView.backgroundColor = [UIColor orangeColor];
    //imgView.dontShowActivityView = YES;
    //imgView.dontReplaceImmediately = YES;
    imgView.dontUseOriginalImage = YES;
    [self.view addSubview:imgView];
    self.imgView = imgView;
    [imgView release];
}

- (void)getImage
{
    self.imgView.imageUrl = @"http://b.hiphotos.baidu.com/image/w%3D1920%3Bcrop%3D0%2C0%2C1920%2C1080/sign=b838b9c6c0cec3fd8b3ea37ce4b8ef5c/30adcbef76094b36ad855fe7a0cc7cd98d109da0.jpg";
}

@end
