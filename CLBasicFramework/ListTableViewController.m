//
//  ListTableViewController.m
//  CLBasicFramework
//
//  Created by L on 14/12/22.
//  Copyright (c) 2014年 L. All rights reserved.
//

#import "ListTableViewController.h"
#import "CLNetwork.h"
#import "CLUIImageView+CLNetwork.h"

@interface ListTableViewController ()

@property (nonatomic, retain) NSMutableArray *listArray;

@end

@implementation ListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = 100;
    self.listArray = [NSMutableArray array];
    
    [CLNetwork getRequestWithUrl:@"http://sp.autohome.com.cn/cars/APP/BrandAll.ashx" withTag:nil requestResult:^(id object, NSError *error) {
        NSDictionary *dic1 = [object objectForKey:@"body"];
        NSArray *array = [dic1 objectForKey:@"brandlist"];
        for (NSDictionary *dic2 in array) {
            [self.listArray addObjectsFromArray:[dic2 objectForKey:@"Item"]];
        }
        [self.tableView reloadData];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *iden = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden] autorelease];
    }
    
    NSDictionary *dic = [self.listArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [dic objectForKey:@"Name"];
    cell.imageView.image = [UIImage imageNamed:@"applyicon"];
    cell.imageView.activityStyle = UIActivityIndicatorViewStyleGray;
    cell.imageView.imageUrl = [dic objectForKey:@"ImgUrl"];
    
    return cell;
}

@end