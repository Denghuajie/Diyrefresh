//
//  DJRefreshView.m
//  下拉刷新
//
//  Created by Mr.Deng on 16/2/18.
//  Copyright © 2016年 Mr.Deng. All rights reserved.
//

#import "DJRefreshView.h"

@implementation DJRefreshView

+ (instancetype)refreshView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"DJRefreshView" owner:nil options:nil] lastObject];
}

@end
