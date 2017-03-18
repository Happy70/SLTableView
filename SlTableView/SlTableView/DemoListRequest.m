//
//  DemoListRequest.m
//  SlTableView
//
//  Created by apple on 17/3/17.
//  Copyright © 2017年 lsl. All rights reserved.
//

#import "DemoListRequest.h"
#import "DemoListModel.h"

@implementation DemoListRequest

- (instancetype)init {

    self = [super init];
    if (self) {
        self.dataPath = @"api/info/list";
        self.listId   = @"3";
        self.rows     = 18;
    }
    return self;
}

- (void)loadData:(BOOL)bRefresh {
    [super loadData:bRefresh];
    if (bRefresh) {
        self.currentPage = 1;
    } else {
        self.currentPage ++;
    }
    
    [self loadData];
}

- (void)loadData {
    
    __weak typeof (self) weakSelf = self;
    
    [AFNetHttpManager postWithUrl:[self requestUrl] params:[self requestAllArgument] success:^(id result) {
        
        [weakSelf dicToModel:result[@"tngou"]];
        
    } fail:^(NSDictionary *errorInfo) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(requestDidFail:)]) {
            [self.delegate requestDidFail:errorInfo];
        }
    }];
}

- (void)dicToModel:(NSArray *)list {
    NSMutableArray *listModel = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in list) {
        DemoListModel *model = [[DemoListModel alloc] initWithData:dic];
        [listModel addObject:model];
    }
    
    BOOL bMore = NO;
    if ([list count] == self.rows) {
        bMore = YES;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(requestDidSuccess:loadMore:)]) {
        [self.delegate requestDidSuccess:listModel loadMore:bMore];
    }
    
}

- (id)requestUrl {
    return self.dataPath;
}

- (id)requestAllArgument {
    NSMutableDictionary *allDic = [[NSMutableDictionary alloc] initWithDictionary:[self requestArgument]];
    
    //添加公共参数
    [allDic addEntriesFromDictionary:[self commonDict]];
    return allDic;
}

- (id)requestArgument {
    NSDictionary *dic = @{@"id":self.listId,
                          @"rows":@(self.rows),
                          @"page":@(self.currentPage)};
    return dic;
}

- (id)commonDict {
    
    //接口公共参数
    return nil;
}

@end
