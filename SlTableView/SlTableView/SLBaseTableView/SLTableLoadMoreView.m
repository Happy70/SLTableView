//
//  SLTableLoadMoreView.m
//  SlTableView
//
//  Created by apple on 17/3/18.
//  Copyright © 2017年 lsl. All rights reserved.
//

#import "SLTableLoadMoreView.h"

@implementation SLTableLoadMoreView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initLoadMoreView];
    }
    return self;
}

- (void)initLoadMoreView {
    CGFloat x = (self.frame.size.width-100)/2;
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(x, 0, 100, self.frame.size.height)];
    lb.backgroundColor = [UIColor clearColor];
    lb.textAlignment     = NSTextAlignmentCenter;
    lb.textColor = [UIColor blackColor];
    lb.font = [UIFont systemFontOfSize:16.0f];
    lb.text = @"上拉加载更多";
    self.titleLb = lb;
    
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    CGRect  rect                = indicatorView.frame;
    rect.origin                 = CGPointMake(lb.frame.origin.x-40, (self.frame.size.height-indicatorView.frame.size.height)/2);
    indicatorView.frame         = rect;
    self.activityView           = indicatorView;
    
    [self addSubview:self.titleLb];
    [self addSubview:self.activityView];
    
    _bLoading = NO;
    
}

- (void)startLoadMore {
    [self.activityView startAnimating];
    self.titleLb.text = @"加载中...";
    _bLoading = YES;
}

- (void)stopLoadMore {
    [self.activityView stopAnimating];
    self.titleLb.text = @"上拉加载更多";
    _bLoading = NO;
}

@end
