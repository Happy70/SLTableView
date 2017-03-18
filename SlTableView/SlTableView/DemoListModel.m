//
//  DemoListModel.m
//  SlTableView
//
//  Created by apple on 17/3/17.
//  Copyright © 2017年 lsl. All rights reserved.
//

#import "DemoListModel.h"

@implementation DemoListModel

- (instancetype)initWithData:(NSDictionary *)data {
    if (data) {
        self.title = data[@"title"];
        self.imageUrl = [NSString stringWithFormat:@"http://tnfs.tngou.net/image%@",data[@"img"]];
    }
    return self;
}

@end
