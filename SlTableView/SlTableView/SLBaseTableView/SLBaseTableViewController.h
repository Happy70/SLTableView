//
//  SLBaseTableViewController.h
//  SlTableView
//
//  Created by apple on 17/3/16.
//  Copyright © 2017年 lsl. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SLTableViewDataSouce.h"
#import "SLBaseTableViewCell.h"
#import "SLTableLoadMoreView.h"
#import "MJRefresh.h"

@interface SLBaseTableViewController : UIViewController
<
UITableViewDelegate
>

/// UITableView
@property (nonatomic, strong) UITableView       *baseTableView;

/// UITableViewStyle 默认 UITableViewStylePlain
@property (nonatomic, assign) UITableViewStyle  tableViewStyle;

/// 分割线 默认 UITableViewCellSeparatorStyleSingleLine
@property (nonatomic, assign) UITableViewCellSeparatorStyle tableViewCellSeparatorStyle;

/// 背景色 默认白色
@property (nonatomic, strong) UIColor           *tableViewBackgroundColor;

/// header 默认nil
@property (nonatomic, strong) UIView            *headerView;

/// footer 默认nil
@property (nonatomic, strong) UIView            *footerView;

///SLTableViewDataSouce
@property (nonatomic, strong) SLTableViewDataSouce   *dataSource;

/// 加载更多view
@property (nonatomic, strong) SLTableLoadMoreView    *loadMoreView;

/// 是否拥有下拉刷新 默认 NO
@property (nonatomic, assign) BOOL               bNeedRefreshAction;

/// 是否拥有上拉加载更多 默认 NO
@property (nonatomic, assign) BOOL               bNeedLoadMoreAction;

/// 是否刷新加载数据 默认 NO
@property (nonatomic, assign) BOOL               bRefresh;


/// 设置table
- (void)createTableView;

/// 设置TableDatasource
- (void)initTableDatasource;

/// 初始化下拉刷新
- (void)initMJRefresh;

/// 初始化上拉加载
- (void)initLoadMore;

/// 刷新加载数据
- (void)beginRefresh;

/// 加载更多数据
- (void)loadMoreData;

/// 点击cell
- (void)clickedTableCell:(SLBaseListModel *)listModel;


@end
