//
//  SLBaseTableViewCell.h
//  SlTableView
//
//  Created by apple on 17/3/16.
//  Copyright © 2017年 lsl. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SLBaseListModel.h"
#import "UIImageView+AFNetworking.h"

@interface SLBaseTableViewCell : UITableViewCell

- (void)initWithData:(SLBaseListModel *)listModel;

+ (CGFloat)cellHeight:(SLBaseListModel *)listModel;


@end
