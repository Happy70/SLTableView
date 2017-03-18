//
//  DemoTableViewDataSouce.m
//  SlTableView
//
//  Created by apple on 17/3/17.
//  Copyright © 2017年 lsl. All rights reserved.
//

#import "DemoTableViewDataSouce.h"
#import "DemoListModel.h"
#import "DemoTableViewCell.h"

@implementation DemoTableViewDataSouce

- (Class)tableView:(UITableView *)tableView cellClassForObject:(SLBaseListModel *)model {
    if ([model isKindOfClass:[DemoListModel class]]) {
        return [DemoTableViewCell class];
    }
    return nil;
}

@end
