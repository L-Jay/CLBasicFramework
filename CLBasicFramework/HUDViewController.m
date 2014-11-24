//
//  HUDViewController.m
//  CLBasicFramework
//
//  Created by L on 14-11-24.
//  Copyright (c) 2014年 L. All rights reserved.
//

#import "HUDViewController.h"
#import "CLHUD.h"

@interface HUDViewController ()

@end

@implementation HUDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor orangeColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"SHOW" style:UIBarButtonItemStyleBordered target:self action:@selector(showHUD)];
}

- (void)showHUD
{
    //[[CLHUD hudForView:self.view] showSucceedWithText:@"试试"];
    //[CLHUD showFailed];
//    CLHUD *hud = [[CLHUD alloc] init];
//    [hud showSucceedWithText:@"ceshi"];
    
    //[CLHUD showActivityView];
    [CLHUD showActivityViewInView:self.view];
    //[CLHUD showSucceedWithText:@"试试"];
    
    [CLHUD hideComplete:^{
        NSLog(@"==== window hud 隐藏");
    }];
    
    [self.view.hud hideComplete:^{
        NSLog(@"==== view hud 隐藏");
    }];
    
    [self performSelector:@selector(showOther) withObject:nil afterDelay:1];
}

- (void)showOther
{
    //[CLHUD hideAnimation:YES];
    //[CLHUD showSucceedWithText:@"试试"];
    //[self.view.hud hideAnimation:YES];
    [self.view.hud showSucceedWithText:@"试试"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
