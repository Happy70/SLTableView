//
//  SLBaseRequest.h
//  SlTableView
//
//  Created by apple on 17/3/17.
//  Copyright © 2017年 lsl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetHttpManager.h"

@interface SLBaseRequest : NSObject

typedef void (^APIBlockResponseSuccess)(id result);
typedef void (^APIBlockResponseError)(NSString *error);


/*!
 *
 *  API POST请求接口
 *
 *  @param success 接口成功请求到数据的回调
 *  @param fail    接口请求数据失败的回调
 *
 *
 */

- (void)postRequest:(APIBlockResponseSuccess)success
               fail:(APIBlockResponseError)fail;

///以下方法由子类继承来覆盖默认值

///设置url
- (id)requestUrl;

///请求的参数列表
- (id)requestArgument;

///请求的参数列表(包括公共参数)
- (id)requestAllArgument;

///请求公共参数
- (id)commonDict;

///请求的BaseURL
- (void)baseUrl;

///请求的连接超时时间，默认为30秒
- (void)requestTimeoutInterval;

//获取手机网络
- (BOOL)getNetWorkStates;

@end
