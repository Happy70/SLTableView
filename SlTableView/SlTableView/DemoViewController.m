//
//  DemoViewController.m
//  SlTableView
//
//  Created by apple on 17/3/16.
//  Copyright © 2017年 lsl. All rights reserved.
//

#import "DemoViewController.h"
#import "DemoListRequest.h"
#import "DemoTableViewDataSouce.h"
#import "DemoTableViewCell.h"
#import "DemoListModel.h"

@interface DemoViewController ()
<
ListRequestDelegate
>

@property (nonatomic , strong) DemoListRequest  *listRequst;

@end

@implementation DemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.bNeedRefreshAction = YES;
    self.bNeedLoadMoreAction= YES;
    
    [self createTableView];

}

- (void)initTableDatasource {
    __weak typeof(self) weakSelf = self;
    SLTableViewCellBlock cellBlock = ^(DemoTableViewCell *cell, DemoListModel *model) {
        //可以遍历cell上的按钮 将按钮事件传递到控制器
        [weakSelf forCellBtn:cell];
        
    };
    
    self.dataSource = [[DemoTableViewDataSouce alloc] initWithCellBlock:cellBlock];
    
    self.baseTableView.dataSource = self.dataSource;
    
    [self.baseTableView.mj_header beginRefreshing];
}

- (void)beginRefresh {
    self.bRefresh = YES;
    [self.loadMoreView stopLoadMore];
    [self.listRequst loadData:self.bRefresh];
    
}

- (void)loadMoreData {
    self.bRefresh = NO;
    [self.loadMoreView startLoadMore];
    [self.baseTableView.mj_header endRefreshing];
    [self.listRequst loadData:self.bRefresh];
}

- (void)requestDidSuccess:(NSArray *)listModels loadMore:(BOOL)bHaveMoreData {
    //请求 数据成功
    //如果是刷新，清除之前的数据
    if (self.bRefresh) {
        [self.dataSource clearAllModel];
        [self.baseTableView.mj_header endRefreshing];
        
        if (bHaveMoreData && self.bNeedLoadMoreAction) {
            //添加加载更多
            [self initLoadMore];
        } else {
            self.baseTableView.tableFooterView = [UIView new];
        }
        
    } else {
        //加载更多
        [self.loadMoreView stopLoadMore];
    }
    
    [self.dataSource nomalAppendModel:listModels];
    
    [self.baseTableView reloadData];
}

- (void)requestDidFail:(NSString *)error {
    
    //请求 数据失败
    [self.baseTableView.mj_header endRefreshing];
    [self.loadMoreView stopLoadMore];
}

- (void)forCellBtn:(DemoTableViewCell *)cell {
    for (UIView *view in cell.contentView.subviews ) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)view;
            [btn addTarget:self action:@selector(clickedCellBtn:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
}

- (void)clickedCellBtn:(UIButton *)btn {
    //处理点击事件
    NSLog(@">>>clicked cell btn");
}

- (void)clickedTableCell:(SLBaseListModel *)listModel {
    NSLog(@">>>clicked cell");
}


- (DemoListRequest *)listRequst {
    if (!_listRequst) {
        self.listRequst = [[DemoListRequest alloc] init];
        self.listRequst.delegate = self;
    }
    return _listRequst;
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
