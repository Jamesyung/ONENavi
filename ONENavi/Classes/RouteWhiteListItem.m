//
//  RouteWhiteListItem.m
//  ELife
//
//  Created by yanglihua on 16/8/10.
//  Copyright © 2016年 Hangzhou TaiXuan Network Technology Co., Ltd. All rights reserved.
//

#import "RouteWhiteListItem.h"
#import "DCKeyValueObjectMapping.h"

@implementation RouteWhiteListItem

+ (RouteWhiteListItem *)toObject:(NSDictionary *)json {
    DCKeyValueObjectMapping * parser = [DCKeyValueObjectMapping mapperForClass:[RouteWhiteListItem class]];
    return [parser parseDictionary:json];
}

@end
