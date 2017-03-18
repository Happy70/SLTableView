//
//  SLBaseTableListRequest.h
//  SlTableView
//
//  Created by apple on 17/3/17.
//  Copyright © 2017年 lsl. All rights reserved.
//

#import "SLBaseRequest.h"
#import "SLBaseListModel.h"

@protocol ListRequestDelegate <NSObject>

///请求数据成功
- (void)requestDidSuccess:(NSArray *)listModels loadMore:(BOOL)bHaveMoreData;

///请求失败
- (void)requestDidFail:(NSDictionary *)error;

@end

@interface SLBaseTableListRequest : SLBaseRequest

///接口路径
@property (nonatomic, copy) NSString    *dataPath;

///页数 默认1
@property (nonatomic, assign) NSUInteger currentPage;

///每页条数 默认10
@property (nonatomic, assign) NSUInteger rows;

///请求代理
@property (nonatomic, weak) id<ListRequestDelegate> delegate;


///加载数据
- (void)loadData:(BOOL)bRefresh;


@end
