//
//  RouteWhiteListItem.h
//  ELife
//
//  Created by yanglihua on 16/8/10.
//  Copyright © 2016年 Hangzhou TaiXuan Network Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  ONERoute URL 白名单
 */
@interface RouteWhiteListItem : NSObject

/**
 *  URL路径
 */
@property (nonatomic, copy) NSString *urlPath;

/**
 *  描述
 */
@property (nonatomic, copy) NSString *urlDescription;

+ (RouteWhiteListItem *)toObject:(NSDictionary *)json;

@end
