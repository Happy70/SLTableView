//
//  SLTableViewSectionModel.h
//  SlTableView
//
//  Created by apple on 17/3/16.
//  Copyright © 2017年 lsl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SLTableViewSectionModel : NSObject

/// UITableDataSource 协议中的 titleForHeaderInSection 方法可能会用到
@property (nonatomic, copy) NSString *headerTitle;

/// UITableDataSource 协议中的 titleForFooterInSection 方法可能会用到
@property (nonatomic, copy) NSString *footerTitle;

/// 数据model数组
@property (nonatomic, strong) NSMutableArray *listModels;

- (instancetype)initWithModelArray:(NSMutableArray *)listModels;

@end
