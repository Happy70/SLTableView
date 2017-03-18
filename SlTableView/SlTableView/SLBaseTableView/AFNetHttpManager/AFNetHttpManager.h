//
//  AFNetHttpManager.h
//  AFNetHttpManager
//
//  Created by apple on 16/4/29.
//  Copyright © 2016年 lsl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@class NSURLSessionTask;

typedef NS_ENUM(NSUInteger, LSLRequestType) {
    LSLRequestTypeJSON = 1, // 默认json
    LSLBRequestTypePlainText  = 2 // 普通text/html
};

typedef NS_ENUM(NSUInteger, LSLResponseType) {
    LSLBResponseTypeJSON = 1, // 默认
    LSLBResponseTypeXML  = 2, // XML
    // 特殊情况下，一转换服务器就无法识别的，默认会尝试转换成JSON，若失败则需要自己去转换
    LSLBResponseTypeData = 3
};

// 请勿直接使用NSURLSessionDataTask,以减少对第三方的依赖
// 所有接口返回的类型都是基类NSURLSessionTask，若要接收返回值
// 且处理，请转换成对应的子类类型
typedef NSURLSessionTask LSLURLSessionTask;

typedef void (^LSLBlockResponseSuccess)(id result);

typedef void (^LSLBlockResponseError)(NSDictionary *errorInfo);


@interface AFNetHttpManager : NSObject

/*!
 *
 *  设置网络请求的baseUrl
 *
 *  通常在AppDelegate中启动时就设置一次就可以了
 */
+ (NSString *)baseUrl;

/*!
*
*  更新网络请求的baseUrl
*
*  如果接口有来源于多个服务器，可以调用更新
*/
+ (void)updateBaseUrl:(NSString *)baseUrl;

/*!
 *
 *  设置网络请求的超时时间
 *
 *  默认 60s
 */
+ (void)setTimeout:(NSTimeInterval)timeout;

/*!
 *
 *  配置公共的请求头，只调用一次即可，通常放在应用启动的时候配置就可以了
 *
 *  @param httpHeaders 只需要将与服务器商定的固定参数设置即可
 *
 *  可以不设置
 */
+ (void)configCommonHttpHeaders:(NSDictionary *)httpHeaders;

/*!
 *
 *  网络请求，若不指定baseurl，可传完整的url
 *
 *  @param url     接口路径，如http/non/auth/serviceManager
 *  @param params  接口中所需的参数，如@{"categoryid" : @(12)}
 *  @param httpMethod 1:get  2:post
 *  @param success 接口成功请求到数据的回调
 *  @param fail    接口请求数据失败的回调
 *
 *  @return 返回的对象中有可取消请求的API
 */

+ (LSLURLSessionTask *)_requestWithUrl:(NSString *)url
                             httpMedth:(NSUInteger)httpMethod
                                params:(NSDictionary *)params
                               success:(LSLBlockResponseSuccess)success
                                  fail:(LSLBlockResponseError)fail;

/*!
 *
 *  post请求,若不指定baseurl，可传完整的url
 *
 *  @param url     接口路径，如http/non/auth/serviceManager
 *  @param params  接口中所需的参数，如@{"categoryid" : @(12)}
 *  @param success 接口成功请求到数据的回调
 *  @param fail    接口请求数据失败的回调
 *
 *  @return 返回的对象中有可取消请求的API
 */
+ (LSLURLSessionTask *)postWithUrl:(NSString *)url
                            params:(NSDictionary *)params
                           success:(LSLBlockResponseSuccess)success
                              fail:(LSLBlockResponseError)fail;

/*!
 *
 *  get请求,若不指定baseurl，可传完整的url
 *
 *  @param url     接口路径，如http/non/auth/serviceManager
 *  @param params  接口中所需的参数，如@{"categoryid" : @(12)}
 *  @param success 接口成功请求到数据的回调
 *  @param fail    接口请求数据失败的回调
 *
 *  @return 返回的对象中有可取消请求的API
 */
+ (LSLURLSessionTask *)getWithUrl:(NSString *)url
                            params:(NSDictionary *)params
                           success:(LSLBlockResponseSuccess)success
                              fail:(LSLBlockResponseError)fail;


/*!
 *
 *  配置请求格式，默认为JSON。如果要求传XML或者PLIST，请在全局配置一下
 *
 *  @param requestType 请求格式，默认为JSON
 *  @param responseType 响应格式，默认为JSON，
 *  @param shouldAutoEncode YES or NO,默认为NO，是否自动encode url
 *  @param shouldCallbackOnCancelRequest 当取消请求时，是否要回调，默认为YES
 */
+ (void)configRequestType:(LSLRequestType)requestType
             responseType:(LSLResponseType)responseType
      shouldAutoEncodeUrl:(BOOL)shouldAutoEncode
  callbackOnCancelRequest:(BOOL)shouldCallbackOnCancelRequest;
@end
