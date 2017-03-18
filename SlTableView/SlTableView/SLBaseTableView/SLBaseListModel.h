//
//  SLBaseListModel.h
//  SlTableView
//
//  Created by apple on 17/3/16.
//  Copyright © 2017年 lsl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SLBaseListModel : NSObject

///cell 高度
@property (nonatomic, assign) CGFloat cellHeight;

///初始化model 需要在子类重写
- (instancetype)initWithData:(NSDictionary *)data;

@end
