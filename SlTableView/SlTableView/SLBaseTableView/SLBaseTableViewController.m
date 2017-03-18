//
//  SLBaseTableViewController.m
//  SlTableView
//
//  Created by apple on 17/3/16.
//  Copyright © 2017年 lsl. All rights reserved.
//

#import "SLBaseTableViewController.h"

static const CGFloat  f_scrollV_contentOffset_y = 50.0;

@interface SLBaseTableViewController ()

@end

@implementation SLBaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //初始化table属性
    self.tableViewStyle = UITableViewStylePlain;
    self.tableViewCellSeparatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableViewBackgroundColor = [UIColor whiteColor];
    _bNeedRefreshAction = NO;
    _bNeedLoadMoreAction= NO;
    _bRefresh           = NO;
    
    [self createTableView];
}

- (void)createTableView {
    
    
    if (_bNeedRefreshAction) {
        [self initMJRefresh];
    }
    
    self.baseTableView.separatorStyle  = _tableViewCellSeparatorStyle;
    self.baseTableView.backgroundColor = self.tableViewBackgroundColor;
    
    [self initTableDatasource];
}

- (void)initTableDatasource {
    SLTableViewCellBlock cellBlock = ^(SLBaseTableViewCell *cell, SLBaseListModel *model) {
        //add code
    };
    
    self.dataSource = [[SLTableViewDataSouce alloc] initWithCellBlock:cellBlock];
    
    self.baseTableView.dataSource = self.dataSource;
}

- (void)initMJRefresh {
    MJRefreshNormalHeader   *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(beginRefresh)];
    self.baseTableView.mj_header = header;
}

- (void)initLoadMore {
    self.baseTableView.tableFooterView = self.loadMoreView;
}

- (void)beginRefresh {
    //子类重写
}

- (void)loadMoreData {
    //子类重写
}


#pragma mark - Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //获取table datasource
    id<LslTableVDataSource> dataSource = (id<LslTableVDataSource>)tableView.dataSource;
    
    SLBaseListModel *listModel = [dataSource tableView:tableView objectForRowAtIndexPath:indexPath];
    Class cls = [dataSource tableView:tableView cellClassForObject:listModel];
    
    if (listModel.cellHeight == 0.0f) { // 没有高度缓存
        listModel.cellHeight = [cls cellHeight:listModel];
    }
    return listModel.cellHeight;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.headerView;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return self.footerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    id<LslTableVDataSource> dataSource = (id<LslTableVDataSource>)tableView.dataSource;
    
    SLBaseListModel *listModel = [dataSource tableView:tableView objectForRowAtIndexPath:indexPath];
    
    [self clickedTableCell:listModel];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView.contentOffset.y > (scrollView.contentSize.height - scrollView.frame.size.height)+f_scrollV_contentOffset_y && !self.loadMoreView.bLoading && scrollView.contentOffset.y > 10 &&[self.baseTableView.tableFooterView isKindOfClass:[SLTableLoadMoreView class]]) {
        [self loadMoreData];
    }
}

- (void)clickedTableCell:(SLBaseListModel *)listModel {
    //子类可重写
}

#pragma mark - LazyLoad
- (UITableView *)baseTableView {
    if (!_baseTableView) {
        self.baseTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:_tableViewStyle];
        
        self.baseTableView.delegate   = self;
        [self.view addSubview:self.baseTableView];
    }
    return _baseTableView;
}

- (SLTableLoadMoreView *)loadMoreView {
    if (!_loadMoreView) {
        self.loadMoreView = [[SLTableLoadMoreView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, f_scrollV_contentOffset_y)];
    }
    return _loadMoreView;
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
