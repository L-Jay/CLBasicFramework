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
    
    //[UIImageView removeImageCache];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"get" style:UIBarButtonItemStyleBordered target:self action:@selector(getImage)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"cache" style:UIBarButtonItemStyleBordered target:self action:@selector(cacheImage)];
	
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imgView.backgroundColor = [UIColor orangeColor];
    //imgView.dontShowActivityView = YES;
    //imgView.dontReplaceImmediately = YES;
    imgView.dontUseOriginalImage = YES;
    imgView.onlyWIFI = YES;
    [self.view addSubview:imgView];
    self.imgView = imgView;
    [imgView release];
}

- (void)getImage
{
    //self.imgView.imageUrl = @"http://f.hiphotos.baidu.com/image/h%3D800%3Bcrop%3D0%2C0%2C1280%2C800/sign=5811598e9058d109dbe3a4b2e163afcd/8d5494eef01f3a29a8b0ef3e9b25bc315d607cc1.jpg";
    //self.imgView.imageUrl = @"http://undefined.qiniudn.com/undefined";
    self.imgView.imageUrl = @"http://a.hiphotos.baidu.com/image/h%3D800%3Bcrop%3D0%2C0%2C1280%2C800/sign=acb2ad0a59b5c9ea7df30ee3e502d572/bf096b63f6246b60941a2975e9f81a4c510fa29f.jpg";
}

- (void)cacheImage
{
    UIImage *image = [UIImage imageNamed:@"test.jpg"];
    
    [UIImageView cacheImage:image withName:@"normal"];
    
    [UIImageView cacheImageData:UIImageJPEGRepresentation(image, 0.5) withName:@"jpgcache"];
    [UIImageView cacheImageData:UIImagePNGRepresentation(image) withName:@"pngcache"];
}

@end
