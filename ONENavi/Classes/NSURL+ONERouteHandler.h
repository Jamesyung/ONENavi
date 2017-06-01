//
//  NSURL+ONERouteHandler.h
//  ELife
//
//  Created by yanglihua on 16/8/8.
//  Copyright © 2016年 Hangzhou TaiXuan Network Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (ONERouteHandler)

/**
 *  对NSURL进行标准化处理，有且仅有[NSURL scheme] [NSURL host] [NSURL path]
 *
 *  @return 标准化处理 sample scheme://host+path
 *          如果返回为空，代表处理错误
 */
- (NSString *)ONERoutePathNoQuery;

/**
 *  NSURL参数字典化
 *
 *  @return 对参数进行字典化
 */
- (NSDictionary *)queryParams;

@end
