//
//  SLTableViewDataSouce.m
//  SlTableView
//
//  Created by apple on 17/3/16.
//  Copyright © 2017年 lsl. All rights reserved.
//

#import "SLTableViewDataSouce.h"
#import "SLTableViewSectionModel.h"

#import <objc/runtime.h>

@implementation SLTableViewDataSouce

- (instancetype)initWithCellBlock:(SLTableViewCellBlock)cBlock {
    self = [super init];
    if (self) {
        self.CellBlock= [cBlock copy];
        self.sections = [[NSMutableArray alloc] init];
    }
    return self;
}

- (SLBaseListModel *)tableView:(UITableView *)tableView objectForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger section = indexPath.section;
    
    if (section < [self.sections count]) {
        SLTableViewSectionModel *model = self.sections[section];
        
         NSUInteger row = indexPath.row;
        if (row < [model.listModels count]) {
            
            SLBaseListModel *listModel = model.listModels[row];
            return listModel;
        }
        
    }
    return nil;
}

- (Class)tableView:(UITableView *)tableView cellClassForObject:(SLBaseListModel *)model {
    // 这个方法会子类有机会重写，默认的 Cell 类型是 SLBaseTableViewCell
    // 这里可以实现table加载不同的cell
    
    if ([model isKindOfClass:[SLBaseListModel class]]) {
        return [SLBaseTableViewCell class];
    }
    /*
    if (other class) {
       return other cell
    }
    */
    return nil;
}

- (void)nomalAppendModel:(NSArray *)models {
    if ([self.sections count] == 0) {
        //只有一个分组 添加数据
        self.sections = [NSMutableArray arrayWithObject:[[SLTableViewSectionModel alloc] init]];
    }
    SLTableViewSectionModel *firstSectionObject = [self.sections firstObject];
    [firstSectionObject.listModels addObjectsFromArray:models];

}

- (void)clearAllModel {
    self.sections = [NSMutableArray arrayWithObject:[[SLTableViewSectionModel alloc] init]];
}

#pragma mark -
#pragma mark - TableViewDataSouce
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sections ? [self.sections count] : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section < [self.sections count]) {
        SLTableViewSectionModel *sectionModel = self.sections[section];
        return [sectionModel.listModels count];
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section < self.sections.count) {
        SLTableViewSectionModel *sectionModel = [self.sections objectAtIndex:section];
        if (sectionModel != nil && sectionModel.headerTitle != nil && ![sectionModel.headerTitle isEqualToString:@""]) {
            return sectionModel.headerTitle;
        }
    }
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (section < self.sections.count) {
        SLTableViewSectionModel *sectionModel = [self.sections objectAtIndex:section];
        if (sectionModel != nil && sectionModel.footerTitle != nil && ![sectionModel.footerTitle isEqualToString:@""]) {
            return sectionModel.footerTitle;
        }
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SLBaseListModel *listModel = [self tableView:tableView objectForRowAtIndexPath:indexPath];
    
    Class class = [self tableView:tableView cellClassForObject:listModel];
    
    NSString *className = [NSString stringWithUTF8String:class_getName(class)];
    SLBaseTableViewCell *cell = (SLBaseTableViewCell *)[tableView dequeueReusableCellWithIdentifier:className];
    if (!cell) {
        cell = [[class alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:className];
    }
    
    //初始化cell数据
    [cell initWithData:listModel];
    
    
    if (self.CellBlock) {
        self.CellBlock(cell,listModel);
    }
    return cell;
}

@end
