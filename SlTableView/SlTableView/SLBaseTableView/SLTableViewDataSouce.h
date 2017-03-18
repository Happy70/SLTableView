//
//  SLTableViewDataSouce.h
//  SlTableView
//
//  Created by apple on 17/3/16.
//  Copyright © 2017年 lsl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "SLBaseListModel.h"
#import "SLBaseTableViewCell.h"


///cell block 用于传递cell的按钮点击事件
typedef void (^SLTableViewCellBlock)(id cell, id item);


@protocol LslTableVDataSource <UITableViewDataSource>

@optional

//方便tableview delegate 调用以下方法 和 子类重写
- (SLBaseListModel *)tableView:(UITableView *)tableView objectForRowAtIndexPath:(NSIndexPath *)indexPath;

- (Class)tableView:(UITableView *)tableView cellClassForObject:(SLBaseListModel *)model;

@end

@interface SLTableViewDataSouce : NSObject
<
LslTableVDataSource
>

///section 二维数组
@property (nonatomic, strong) NSMutableArray    *sections;

///cell block
@property (nonatomic, copy) SLTableViewCellBlock CellBlock;


- (instancetype)initWithCellBlock:(SLTableViewCellBlock)cBlock;

- (void)clearAllModel;

///普通table 一个section 添加数据model
- (void)nomalAppendModel:(NSArray *)models;

///多个section 组合好了的数据model  直接赋值给sections


@end
