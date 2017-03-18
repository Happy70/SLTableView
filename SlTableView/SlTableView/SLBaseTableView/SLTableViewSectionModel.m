//
//  SLTableViewSectionModel.m
//  SlTableView
//
//  Created by apple on 17/3/16.
//  Copyright © 2017年 lsl. All rights reserved.
//

#import "SLTableViewSectionModel.h"

@implementation SLTableViewSectionModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.headerTitle = @"";
        self.footerTitle = @"";
        self.listModels = [[NSMutableArray alloc] init];
    }
    return self;
}

- (instancetype)initWithModelArray:(NSMutableArray *)listModels {
    self = [self init];
    if (self) {
        [self.listModels addObjectsFromArray:listModels];
    }
    return self;
}

@end
