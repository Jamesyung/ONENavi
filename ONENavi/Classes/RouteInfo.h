//
//  RouteInfo.h
//  ELife
//
//  Created by yanglihua on 16/8/9.
//  Copyright © 2016年 Hangzhou TaiXuan Network Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  路由信息
 *  注册路由时，需要传递的必要参数
 */
@interface RouteInfo : NSObject

/**
 *  注册URL
 */
@property (nonatomic, copy) NSURL *url;

/**
 *  URL关联类
 */
@property (nonatomic, strong) NSString *relativeClassName;

/**
 *  展现方式:OpenONEURLMode
 */
@property (nonatomic, assign) NSUInteger mode;

@end
