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
    
    NSLog(@"view: %@", NSStringFromCGRect(self.view.frame));
    NSLog(@"screen: %@", NSStringFromCGRect([UIScreen mainScreen].bounds));
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //[[CLHUD hudForView:self.view] showSucceed];
    //[CLHUD showActivityViewInView:self.view];
    
    [[CLHUD hudForView:self.view] showSucceedWithText:@"第一次"];
    //[CLHUD showSucceedWithText:@"第一次"];
    [self performSelector:@selector(showAc) withObject:nil afterDelay:1];
}

- (void)showAc
{
    //[self.view.hud hideAnimation:YES];
    
    //[self.view.hud showFailed];
    
    //[CLHUD showActivityView];
    [CLHUD showActivityViewInView:self.view];
    [self performSelector:@selector(showOt) withObject:nil afterDelay:3];
}

- (void)showOt
{
    //[CLHUD showActivityViewInView:self.view];
    //[self.view.hud hideAnimation:YES];
    
    //[CLHUD showSucceedWithText:@"第二次"];
    [self.view.hud showSucceedWithText:@"第二次"];
    [self performSelector:@selector(showTh) withObject:nil afterDelay:1];
}

- (void)showTh
{
    //[CLHUD showFailedWithText:@"第三次"];
    [self.view.hud showFailedWithText:@"第三次"];
}

- (void)showHUD
{
    //[[CLHUD hudForView:self.view] showSucceedWithText:@"试试"];
    //[CLHUD showFailed];
//    CLHUD *hud = [[CLHUD alloc] init];
//    [hud showSucceedWithText:@"ceshi"];
    
    //[CLHUD showActivityView];
    //[CLHUD showActivityViewInView:self.view withText:@"正在加载"];
    //[CLHUD registerAnimation:CLHUDAnimationSacleBig];
    [CLHUD showActivityViewWithBackViewInView:self.view withText:@"正在加载"];
    //[CLHUD showSucceedWithText:@"试试"];
    
    [CLHUD hideComplete:^{
        NSLog(@"==== window hud 隐藏");
    }];
    
    [self.view.hud hideComplete:^{
        NSLog(@"==== view hud 隐藏");
        
        [self performSelector:@selector(lookhud) withObject:nil afterDelay:1.0];
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

- (void)lookhud
{
    NSLog(@"=-- %@", self.view.hud);
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
