//
//  ONERouteLog.h
//  ONENavi
//
//  Created by yanglihua on 2017/4/25.
//  Copyright © 2017年 Hangzhou TaiXuan Network Technology Co., Ltd. All rights reserved.
//

#ifndef ONERouteLog_h
#define ONERouteLog_h

// 日志输出

#define ONERouteLogError(fmt, ...) ONERouteLog(@"【Error】%@", [NSString stringWithFormat:(fmt), ##__VA_ARGS__])
#define ONERouteLogLogWarn(fmt, ...) ONERouteLog(@"【Warn】%@", [NSString stringWithFormat:(fmt), ##__VA_ARGS__])
#define ONERouteLogDebug(fmt, ...) ONERouteLog(@"【Debug】%@", [NSString stringWithFormat:(fmt), ##__VA_ARGS__])
#define ONERouteLogInfo(fmt, ...) ONERouteLog(@"【Info】%@", [NSString stringWithFormat:(fmt), ##__VA_ARGS__])

#ifdef DEBUG
#define ONERouteLog(format, ...) NSLog((@"\n【%s】【Line %d】" format), __func__, __LINE__, ##__VA_ARGS__)
#else
#define ONERouteLog(...)
#endif

#endif /* ONERouteLog_h */
