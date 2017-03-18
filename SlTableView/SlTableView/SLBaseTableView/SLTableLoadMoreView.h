//
//  SLTableLoadMoreView.h
//  SlTableView
//
//  Created by apple on 17/3/18.
//  Copyright © 2017年 lsl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLTableLoadMoreView : UIView

@property (nonatomic, weak) UIActivityIndicatorView     *activityView;

@property (nonatomic, weak) UILabel                     *titleLb;

@property (nonatomic, assign) BOOL                      bLoading;

- (void)startLoadMore;

- (void)stopLoadMore;

@end
