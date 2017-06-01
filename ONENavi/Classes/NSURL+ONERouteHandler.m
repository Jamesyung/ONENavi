//
//  NSURL+ONERouteHandler.m
//  ELife
//
//  Created by yanglihua on 16/8/8.
//  Copyright © 2016年 Hangzhou TaiXuan Network Technology Co., Ltd. All rights reserved.
//

#import "NSURL+ONERouteHandler.h"
#import "ONERouteLog.h"

@implementation NSURL (ONERouteHandler)

- (NSString *)ONERoutePathNoQuery {
    
    NSString *scheme = self.scheme;
    if ([scheme length] == 0) {
        ONERouteLogInfo(@"scheme is nil");
        return nil;
    }
    
    NSString *host = self.host;
    if ([host length] == 0) {
        ONERouteLogInfo(@"host is nil");
        return nil;
    }
    
    NSString *pathForKey = [NSString stringWithFormat:@"%@://%@", scheme, host];
    
    NSString *path = self.path;
    if ([path length] > 0) {
        pathForKey = [pathForKey stringByAppendingPathComponent:path];
    }
    
    return pathForKey;
}

- (NSDictionary *)queryParams {
    
    NSMutableDictionary *queryDict = [NSMutableDictionary dictionary];
    NSArray *keyValuePairs = [self.query componentsSeparatedByString:@"&"];
    
    for (NSString *keyValuePair in keyValuePairs) {
        NSArray *element = [keyValuePair componentsSeparatedByString:@"="];
        
        if (element.count != 2) {
            continue;
        }
        
        NSString *key = element[0];
        
        NSString *value = element[1];
        
        if (key.length == 0){
            continue;
        }
        
        //query 去除编码
        queryDict[[key stringByRemovingPercentEncoding]] = [value stringByRemovingPercentEncoding];
    }
    
    return [NSDictionary dictionaryWithDictionary:queryDict];
}

@end
