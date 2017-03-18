//
//  SLBaseTableViewCell.m
//  SlTableView
//
//  Created by apple on 17/3/16.
//  Copyright © 2017年 lsl. All rights reserved.
//

#import "SLBaseTableViewCell.h"

@implementation SLBaseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initWithData:(SLBaseListModel *)listModel {
    //子类重写该方法

}

+ (CGFloat)cellHeight:(SLBaseListModel *)listModel {
    //默认44，子类重写该方法
    return 44.0f;
}

@end
