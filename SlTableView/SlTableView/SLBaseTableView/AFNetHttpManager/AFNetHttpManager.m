//
//  AFNetHttpManager.m
//  AFNetHttpManager
//
//  Created by apple on 16/4/29.
//  Copyright © 2016年 lsl. All rights reserved.
//

#import "AFNetHttpManager.h"

static NSString *NET_NetworkBaseUrl = nil;
static NSTimeInterval NET_Timeout   = 60.0f;
static NSDictionary *NET_HttpHeaders= nil;
static NSMutableArray *NET_RequestTasks;
static BOOL NET_ShouldAutoEncode                = NO;
static BOOL NET_ShouldCallbackOnCancelRequest   = YES;
static LSLRequestType  NET_RequestType  = LSLRequestTypeJSON;
static LSLResponseType NET_ResponseType = LSLBResponseTypeJSON;

@implementation AFNetHttpManager

+ (void)updateBaseUrl:(NSString *)baseUrl {
    NET_NetworkBaseUrl = baseUrl;
}

+ (NSString *)baseUrl {
    return NET_NetworkBaseUrl;
}

+ (void)setTimeout:(NSTimeInterval)timeout {
    NET_Timeout = timeout;
}


+ (LSLURLSessionTask *)postWithUrl:(NSString *)url
                            params:(NSDictionary *)params
                           success:(LSLBlockResponseSuccess)success
                              fail:(LSLBlockResponseError)fail {
   return [self _requestWithUrl:url
                httpMedth:2
                   params:params
                  success:success
                     fail:fail];
}


+ (LSLURLSessionTask *)getWithUrl:(NSString *)url
                           params:(NSDictionary *)params
                          success:(LSLBlockResponseSuccess)success
                             fail:(LSLBlockResponseError)fail {
    return [self _requestWithUrl:url
                       httpMedth:1
                          params:params
                         success:success
                            fail:fail];
}

+ (LSLURLSessionTask *)_requestWithUrl:(NSString *)url
                             httpMedth:(NSUInteger)httpMethod
                                params:(NSDictionary *)params
                               success:(LSLBlockResponseSuccess)success
                                  fail:(LSLBlockResponseError)fail{
    AFHTTPSessionManager *manager = [self manager];
    NSString *absolute = [self absoluteUrlWithPath:url];
    if ([self baseUrl] == nil) {
        if ([NSURL URLWithString:url] == nil) {
            NSLog(@"URLString无效，无法生成URL。可能是URL中有中文，请尝试Encode URL");
            return nil;
        }
    } else {
        NSURL *absouluteURL = [NSURL URLWithString:absolute];
        
        if (absouluteURL == nil) {
            NSLog(@"URLString无效，无法生成URL。可能是URL中有中文，请尝试Encode URL");
            return nil;
        }
    }
    if ([self shouldEncode]) {
        url = [self lslURLEncode:url];
    }
    LSLURLSessionTask *session = nil;
    
    if (httpMethod == 1) {
        session = [manager GET:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
            //请求的进度（暂时不需要，可不写）
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            
            [self successResponse:responseObject callback:success];
            
            [[self allTasks] removeObject:task];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            
            [[self allTasks] removeObject:task];
            
            //需要errorcode 和 allHeaderFields
            NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
            [self handleCallbackWithError:[self getInfoWithFail:response errorCode:[error code]] fail:fail];
            
            //        LNBLog(@"_______%@",error);
        }];
    }
    else if (httpMethod == 2) {
        session = [manager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
            //请求的进度（暂时不需要，可不写）
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            
            [self successResponse:responseObject callback:success];
            
            [[self allTasks] removeObject:task];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            
            [[self allTasks] removeObject:task];
            
            //需要errorcode 和 allHeaderFields
            NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
            [self handleCallbackWithError:[self getInfoWithFail:response errorCode:[error code]] fail:fail];
            
            //        LNBLog(@"_______%@",error);
        }];
    }
    
    if (session) {
        [[self allTasks] addObject:session];
    }
    return session;

}

+ (AFHTTPSessionManager *)manager {

    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    AFHTTPSessionManager *manager = nil;;
    if ([self baseUrl] != nil) {
        manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:[self baseUrl]]];
    } else {
        manager = [AFHTTPSessionManager manager];
    }
    
    switch (NET_RequestType) {
        case LSLRequestTypeJSON: {
            manager.requestSerializer = [AFJSONRequestSerializer serializer];
            break;
        }
        case LSLBRequestTypePlainText: {
            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            break;
        }
        default: {
            break;
        }
    }
    
    switch (NET_ResponseType) {
        case LSLBResponseTypeJSON: {
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
            break;
        }
        case LSLBResponseTypeXML: {
            manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
            break;
        }
        case LSLBResponseTypeData: {
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            break;
        }
        default: {
            break;
        }
    }
    
    manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
    
    
    for (NSString *key in NET_HttpHeaders.allKeys) {
        if (NET_HttpHeaders[key] != nil) {
            [manager.requestSerializer setValue:NET_HttpHeaders[key] forHTTPHeaderField:key];
        }
    }
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",
                                                                              @"text/html",
                                                                              @"text/json",
                                                                              @"text/plain",
                                                                              @"text/javascript",
                                                                              @"text/xml",
                                                                              @"image/*"]];
    
    manager.requestSerializer.timeoutInterval = NET_Timeout;
    
    // 设置允许同时最大并发数量，过大容易出问题
    manager.operationQueue.maxConcurrentOperationCount = 3;
    return manager;
}

+ (NSString *)absoluteUrlWithPath:(NSString *)path {
    if (path == nil || path.length == 0) {
        return @"";
    }
    
    if ([self baseUrl] == nil || [[self baseUrl] length] == 0) {
        return path;
    }
    
    NSString *absoluteUrl = path;
    
    if (![path hasPrefix:@"http://"] && ![path hasPrefix:@"https://"]) {
        absoluteUrl = [NSString stringWithFormat:@"%@%@",
                       [self baseUrl], path];
    }
    
    return absoluteUrl;
}

+ (void)configRequestType:(LSLRequestType)requestType
             responseType:(LSLResponseType)responseType
      shouldAutoEncodeUrl:(BOOL)shouldAutoEncode
  callbackOnCancelRequest:(BOOL)shouldCallbackOnCancelRequest {
    NET_RequestType  = requestType;
    NET_ResponseType = responseType;
    NET_ShouldAutoEncode = shouldAutoEncode;
    NET_ShouldCallbackOnCancelRequest = shouldCallbackOnCancelRequest;
}

+ (BOOL)shouldEncode {
    return NET_ShouldAutoEncode;
}

+ (void)configCommonHttpHeaders:(NSDictionary *)httpHeaders {
    NET_HttpHeaders = httpHeaders;
}

+ (id)tryToParseData:(id)responseData {
    if ([responseData isKindOfClass:[NSData class]]) {
        // 尝试解析成JSON
        if (responseData == nil) {
            return responseData;
        } else {
            NSError *error = nil;
            NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseData
                                                                     options:NSJSONReadingMutableContainers
                                                                       error:&error];
            
            if (error != nil) {
                return responseData;
            } else {
                return response;
            }
        }
    } else {
        return responseData;
    }
}

+ (void)successResponse:(id)responseData callback:(LSLBlockResponseSuccess)success {
    if (success) {
        success([self tryToParseData:responseData]);
    }
}

+ (NSString *)lslURLEncode:(NSString *)url {
    NSString *newString =
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)url,
                                                              NULL,
                                                              CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));
    if (newString) {
        return newString;
    }
    
    return url;
}

+ (NSMutableArray *)allTasks {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (NET_RequestTasks == nil) {
            NET_RequestTasks = [[NSMutableArray alloc] init];
        }
    });
    
    return NET_RequestTasks;
}

+ (NSDictionary *)getInfoWithFail:(NSHTTPURLResponse *)response errorCode:(NSUInteger)nCode{
    if (response == nil) {
        return nil;
    }
    NSDictionary *errorInfo = @{@"statusCode":@(response.statusCode),@"headers":response.allHeaderFields,@"errorCode":@(nCode)};
    return errorInfo;
}

+ (void)handleCallbackWithError:(NSDictionary *)errorInfo  fail:(LSLBlockResponseError)fail {
    if ([errorInfo[@"errorCode"] integerValue] == NSURLErrorCancelled) {
        if (NET_ShouldCallbackOnCancelRequest) {
            if (fail) {
                fail(errorInfo);
            }
        }
    } else {
        if (fail) {
            fail(errorInfo);
        }
    }
}

@end
