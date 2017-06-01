//
//  RouteResult.h
//  ELife
//
//  Created by yanglihua on 16/8/8.
//  Copyright © 2016年 Hangzhou TaiXuan Network Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSUInteger, RouteResultCode) {
    kRouteResultCode_Success,          // 调用成功
    kRouteResultCode_Fail,             // 调用失败
    kRouteResultCode_InitError,        // 调用初始化错误，签名失败等
    kRouteResultCode_InitParamError,   // 调用参数有误，无法进行初始化，未传必要信息等
    kRouteResultCode_Unknow            // 其他
};

/**
 *  调用返回的结果
 *
 *  resultDictionary参数 可能返回含义
 *
 *  参数名                     含义
 *  result_code               结果码（RouteResultCode）
 *  result_msg                结果描述（主要是错误的场景下，错误的信息）
 *
 */
@interface RouteResult : NSObject

/**
 *  返回的结果码
 */
@property (nonatomic, assign) RouteResultCode resultCode;

/**
 *  结果信息
 */
@property (nonatomic, strong) NSDictionary *resultDictionary;

@end