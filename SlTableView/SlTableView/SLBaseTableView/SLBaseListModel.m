//
//  SLBaseListModel.m
//  SlTableView
//
//  Created by apple on 17/3/16.
//  Copyright © 2017年 lsl. All rights reserved.
//

#import "SLBaseListModel.h"

@implementation SLBaseListModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _cellHeight = 0.0f;
    }
    return self;
}

- (instancetype)initWithData:(NSDictionary *)data {
    self = [self init];
    if (self) {
        //子类重写该方法
    }
    return self;
}

@end
