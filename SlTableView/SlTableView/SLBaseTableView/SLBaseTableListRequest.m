//
//  SLBaseTableListRequest.m
//  SlTableView
//
//  Created by apple on 17/3/17.
//  Copyright © 2017年 lsl. All rights reserved.
//

#import "SLBaseTableListRequest.h"


@implementation SLBaseTableListRequest

- (instancetype)init {
    self = [super init];
    if (self) {
        self.dataPath    = @"";
        self.rows        = 10;
        self.currentPage = 0;
    }
    return self;
}

- (void)loadData:(BOOL)bRefresh {
    //子类重写
    if (![self getNetWorkStates]) {
        NSLog(@">>>没有网络！");
        //弹出网络异常提示层
        if (self.delegate && [self.delegate respondsToSelector:@selector(requestDidFail:)]) {
            [self.delegate requestDidFail:nil];
        }
        return;
    }
}


@end
