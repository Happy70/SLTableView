//
//  SLBaseRequest.m
//  SlTableView
//
//  Created by apple on 17/3/17.
//  Copyright © 2017年 lsl. All rights reserved.
//

#import "SLBaseRequest.h"

NSString *apiURL = @"http://www.tngou.net/";

@implementation SLBaseRequest

- (instancetype)init {
    self = [super init];
    if (self) {
        [self baseUrl];
    }
    return self;
}


- (void)postRequest:(APIBlockResponseSuccess)success
               fail:(APIBlockResponseError)fail {
    
}

- (id)requestAllArgument {
    return nil;
}

- (id)requestUrl {
    return nil;
}

- (id)requestArgument {
    return nil;
}

- (id)commonDict {
    return nil;
}

- (void)baseUrl {
    [AFNetHttpManager updateBaseUrl:apiURL];
    [AFNetHttpManager configRequestType:LSLBRequestTypePlainText responseType:LSLBResponseTypeJSON shouldAutoEncodeUrl:NO callbackOnCancelRequest:YES];
}

- (void)requestTimeoutInterval {
    
}

//获取手机网络
- (BOOL)getNetWorkStates{
    BOOL bNetWork = NO;
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *children  = [[[app valueForKeyPath:@"statusBar"]valueForKeyPath:@"foregroundView"]subviews];
    int netType = 0;
    //获取到网络返回码
    for (id child in children) {
        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            //获取到状态栏
            netType = [[child valueForKeyPath:@"dataNetworkType"]intValue];
            
            switch (netType) {
                case 0:
                    //无网模式
                    bNetWork = NO;
                    break;
                case 1:
                    //2G
                    bNetWork = YES;
                    break;
                case 2:
                    //3G
                    bNetWork = YES;
                    break;
                case 3:
                    //4G
                    bNetWork = YES;
                    break;
                case 5:
                    //Wi-Fi
                    bNetWork = YES;
                    break;
                default:
                    break;
            }
        }
    }
    return bNetWork;
}



@end
