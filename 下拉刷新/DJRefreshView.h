//
//  DJRefreshView.h
//  下拉刷新
//
//  Created by Mr.Deng on 16/2/18.
//  Copyright © 2016年 Mr.Deng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DJRefreshView : UIView

@property (weak, nonatomic) IBOutlet UIView *tipView;

@property (weak, nonatomic) IBOutlet UIImageView *loadIcon;


@property (weak, nonatomic) IBOutlet UIImageView *tipIcon;

@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

+ (instancetype)refreshView;
@end
