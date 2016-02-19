//
//  DJRefreshControl.m
//  下拉刷新
//
//  Created by Mr.Deng on 16/2/17.
//  Copyright © 2016年 Mr.Deng. All rights reserved.
//

#import "DJRefreshControl.h"
#import "Masonry.h"
#import "DJRefreshView.h"

static const CGFloat DJRefreshControlOffset = -60;

@interface DJRefreshControl()

@property (strong, nonatomic) DJRefreshView *refreshView;

@property (nonatomic, getter=isRonateFlag) BOOL ronateFlag;

@end

@implementation DJRefreshControl

//刷新控件默认指定构造函数是init不是initWithFrame...
- (instancetype)init
{
    if (self = [super init]) {
        [self setupUI];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    self.tintColor = [UIColor clearColor];
    [self addSubview:self.refreshView];
    [self.refreshView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.mas_centerY);
        //XIB中已经设置好，布局的时候需要再次指定一次
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(60);
    }];
    
    //注册KVO
    [self addObserver:self forKeyPath:@"frame" options:0 context:nil];
    
}

- (void)ronateIcon
{
    CGFloat angle = M_PI;
    //在此做角度调整是因为块动画中有`就近原则`与`顺时针优先原则`,进行角度调整可以控制旋转方向!
    angle += self.ronateFlag ? 0.001 : -0.001;
    [UIView animateWithDuration:0.3 animations:^{
        self.refreshView.tipIcon.transform = CGAffineTransformRotate(self.refreshView.tipIcon.transform, angle);
    }];
}

- (void)startLoadingAnim
{
    NSString *keyPath = @"transform.rotation";
    //过滤重复加载动画
    if ([self.refreshView.loadIcon.layer animationForKey:keyPath] != nil) {
        return;
    }
    self.refreshView.tipView.hidden = YES;
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:keyPath];
    anim.toValue = @(2 * M_PI);
    anim.duration = 0.5;
    anim.removedOnCompletion = NO;
    anim.repeatCount = MAXFLOAT;
    [self.refreshView.loadIcon.layer addAnimation:anim forKey:keyPath];
}

- (void)stopLoadingAnim
{
    self.refreshView.tipView.hidden = NO;
    [self.refreshView.loadIcon.layer removeAllAnimations];
}

- (void)endRefreshing
{
    [super endRefreshing];
    //停止动画
    [self stopLoadingAnim];
}


# pragma mark - KVO方法，临界值y==0
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    //过滤正值
    if(self.frame.origin.y > 0) return;
    
    if (self.isRefreshing) {
        [self startLoadingAnim];
        return;
    }
    
    if (self.frame.origin.y < DJRefreshControlOffset && !self.ronateFlag)
    {
        self.ronateFlag = YES;
    }
    else if(self.frame.origin.y >= DJRefreshControlOffset && self.ronateFlag)
    {
        self.ronateFlag = NO;
    }
    
//    NSLog(@"%@", NSStringFromCGRect(self.frame));
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"frame"];
}


# pragma mark - Getter & Setter
- (void)setRonateFlag:(BOOL)ronateFlag
{
    _ronateFlag = ronateFlag;
    self.refreshView.tipLabel.text = self.ronateFlag == YES ? @"释放更新" : @"下拉刷新";
    //执行翻转
    [self ronateIcon];
}

- (DJRefreshView *)refreshView
{
    if (!_refreshView) {
        _refreshView = [DJRefreshView refreshView];
    }
    return _refreshView;
}

@end