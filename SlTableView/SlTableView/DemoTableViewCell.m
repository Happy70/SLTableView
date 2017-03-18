//
//  DemoTableViewCell.m
//  SlTableView
//
//  Created by apple on 17/3/17.
//  Copyright © 2017年 lsl. All rights reserved.
//

#import "DemoTableViewCell.h"
#import "DemoListModel.h"

@implementation DemoTableViewCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)initWithData:(SLBaseListModel *)listModel {
    DemoListModel *model = (DemoListModel *)listModel;
    self.textLabel.text = model.title;
    
}

+ (CGFloat)cellHeight:(SLBaseListModel *)listModel {
    return 60;
}

@end
