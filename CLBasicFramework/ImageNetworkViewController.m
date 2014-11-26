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
    self.imgView.imageUrl = @"http://d.hiphotos.baidu.com/image/pic/item/2e2eb9389b504fc2ae148d11e7dde71190ef6d5e.jpg";
}

- (void)cacheImage
{
    UIImage *image = [UIImage imageNamed:@"test.jpg"];
    
    [UIImageView cacheImage:image withName:@"normal"];
    
    [UIImageView cacheImageData:UIImageJPEGRepresentation(image, 0.5) withName:@"jpgcache"];
    [UIImageView cacheImageData:UIImagePNGRepresentation(image) withName:@"pngcache"];
}

@end
