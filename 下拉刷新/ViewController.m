//
//  ViewController.m
//  下拉刷新
//
//  Created by Mr.Deng on 16/2/17.
//  Copyright © 2016年 Mr.Deng. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"
#import "DJRefreshControl.h"
@interface ViewController ()

@property (strong, nonatomic) NSMutableArray *dataSource;
@end

@implementation ViewController


static NSString *const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.dataSource = [NSMutableArray array];

    for (int i = 0; i < 5; i++) {
        NSInteger num = i + arc4random_uniform(100);
        NSString *text = [NSString stringWithFormat:@"随机数据--%zd", num];
        [self.dataSource addObject:text];
    }
    
    //下拉刷新控件默认高度60
    self.refreshControl = [[DJRefreshControl alloc] init];
    
    [self.refreshControl addTarget:self action:@selector(loadMore) forControlEvents:UIControlEventValueChanged];
    [self loadMore];
}


- (void)loadMore
{
    [self.refreshControl beginRefreshing];
    
//    NSLog(@"下拉刷新加载更多");
    
    //模拟网络延时加载数据
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        //往数据源中追加数据
        for (int i = 0; i < 5; i++) {
            NSInteger num = i + arc4random_uniform(100);
            NSString *text = [NSString stringWithFormat:@"随机数据--%zd", num];
            [self.dataSource addObject:text];
        }

        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
    });

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    }
    cell.textLabel.text = self.dataSource[indexPath.row];
    return cell;
}


@end
