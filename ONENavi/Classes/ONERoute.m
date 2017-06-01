//
//  ONERoute.m
//  ELife
//
//  Created by yanglihua on 16/8/8.
//  Copyright © 2016年 Hangzhou TaiXuan Network Technology Co., Ltd. All rights reserved.
//

#import "ONERoute.h"
#import "ONERouteLog.h"
#import <objc/runtime.h>
#import "NSURL+ONERouteHandler.h"
#import "RouteInfo.h"
#import "ONETransition.h"
#import "RouteWhiteListItem.h"

@interface ONERoute ()

//URL白名单
@property (nonatomic, strong) NSArray *URLWhiteList;
@property (nonatomic, strong) NSMutableDictionary *bindSource;

@end

@implementation ONERoute

+ (instancetype)sharedRoute {
    static ONERoute *route;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        route = [[ONERoute alloc] initWithRoute];
    });
    return route;
}

- (instancetype)initWithRoute {
    if (self = [super init]) {
        self.bindSource = [NSMutableDictionary dictionary];
        
        NSString *whiteListPath = [[NSBundle mainBundle] pathForResource:@"ONERouteWhiteList" ofType:@"plist"];
        NSDictionary *file = [NSDictionary dictionaryWithContentsOfFile:whiteListPath];
        self.URLWhiteList = file[@"WhiteList"];
    }
    return self;
}

//防止外部直接调用默认init方法
- (instancetype)init {
    return nil;
}

- (BOOL)registerONEURL:(NSURL *)url class:(NSString *)className mode:(OpenONEURLMode)mode {
    
    NSString *pathForKey = [url ONERoutePathNoQuery];
    if ([pathForKey length] == 0) {
        ONERouteLogInfo(@"register failed");
        return NO;
    }
    
    if (NO == [self whiteListContainURL:pathForKey]) {
        ONERouteLogInfo(@"register failed, whitelist not contain this url");
        return NO;
    }
    
    if ([[self.bindSource allKeys] containsObject:pathForKey]) {
        ONERouteLogInfo(@"register failed, because this url registered before, pre class:%@",self.bindSource[pathForKey]);
        return NO;
    }
    
    RouteInfo *info = [RouteInfo new];
    info.url = url;
    info.relativeClassName = className;
    info.mode = mode;
    self.bindSource[pathForKey] = info;
    return YES;
}

- (BOOL)unregisterONEURL:(NSURL *)url {
    
    NSString *pathForKey = [url ONERoutePathNoQuery];
    if ([pathForKey length] == 0) {
        ONERouteLogInfo(@"unregister failed");
        return NO;
    }
    
    if (NO == [[self.bindSource allKeys] containsObject:pathForKey]) {
        ONERouteLogInfo(@"unregister failed, because this url is not registered");
        return NO;
    }
    
    [self.bindSource removeObjectForKey:pathForKey];
    return YES;
}

- (BOOL)canOpenONEURL:(NSURL *)url {
    
    NSString *pathForKey = [url ONERoutePathNoQuery];
    if ([pathForKey length] == 0) {
        ONERouteLogInfo(@"请检查URL是否符合约定定义");
        return NO;
    }
    
    RouteInfo *info = self.bindSource[pathForKey];
    if (nil == info || nil == info.url || [info.relativeClassName length] == 0) {
        ONERouteLogInfo(@"请检查URL是否已经注册");
        return NO;
    }
    
    return YES;
}

- (RouteResult *)openONEURL:(NSURL *)url {
    
    RouteResult *result = [RouteResult new];
    
    //检查URL
    BOOL verifyUrl = [self canOpenONEURL:url];
    if (verifyUrl == NO) {
        ONERouteLogInfo(@"openONEURL failed");
        result.resultCode = kRouteResultCode_InitParamError;
        result.resultDictionary = @{@"result_code":@(result.resultCode),
                                    @"result_msg":@"请检查URL是否已经注册，或者符合约定定义"};
        return result;
    }
    
    NSString *pathForKey = [url ONERoutePathNoQuery];
    RouteInfo *info = self.bindSource[pathForKey];
    
    Class targetClass = NSClassFromString(info.relativeClassName);
    id instance = [[targetClass alloc] init];
    
    if (instance == nil) {
        result.resultCode = kRouteResultCode_InitError;
        result.resultDictionary = @{@"result_code":@(result.resultCode),
                                    @"result_msg":@"注册类初始化失败"};
        return result;
    }

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    SEL action = @selector(routeModuleSetParams:);
#pragma clang diagnostic pop

    NSDictionary *queryParams = [url queryParams];
    NSDictionary *additionalParams = [url ONERouteURLParams];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:queryParams];
    [params addEntriesFromDictionary:additionalParams];
    
    if ([instance respondsToSelector:action]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        
        [instance performSelector:action withObject:params];
#pragma clang diagnostic pop
    }

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    SEL setParamAction = @selector(routeModuleSetParams:toURL:);
#pragma clang diagnostic pop
    if ([instance respondsToSelector:setParamAction]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [instance performSelector:setParamAction withObject:params withObject:[url absoluteString]];
#pragma clang diagnostic pop
    }
    
    //对于不同OpenONEURLMode进行不同的界面展示
    //自定义展示，需要被调用方实现customOpenMode方法
    switch (info.mode) {
        case kOpenONEURLMode_Custom: {
            
            SEL customOpenSel = @selector(customizeOpeningURL:setParams:);
            if ([instance respondsToSelector:customOpenSel]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                [instance performSelector:customOpenSel withObject:[url absoluteString] withObject:params];
#pragma clang diagnostic pop
                goto displayURLSuccess;
            }
            
            goto displayURLFail;
            
            break;
        }
        case kOpenONEURLMode_Push: {
            
            if ([instance isKindOfClass:[UIViewController class]]) {
                
                BOOL transitionResult = [ONETransition pushViewController:instance animated:YES];
                if (transitionResult) {
                    goto displayURLSuccess;
                }
                else {
                    ONERouteLogInfo(@"pushViewController call failed");
                }
            }
            
            goto displayURLFail;
            
            break;
        }
        case kOpenONEURLMode_Present: {
            
            if ([instance isKindOfClass:[UIViewController class]]) {
                
                BOOL transitionResult = [ONETransition presentViewController:instance animated:YES completion:NULL];
                if (transitionResult) {
                    goto displayURLSuccess;
                }
                else {
                    ONERouteLogInfo(@"presentViewController call failed");
                }
            }
            
            goto displayURLFail;

            break;
        }
        default:
            break;
    }
    
displayURLSuccess:
    ONERouteLogInfo(@"open URL success");
    
    result.resultCode = kRouteResultCode_Success;
    result.resultDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                               @(result.resultCode),@"result_code",
                               @"调用成功",@"result_msg", nil];
    goto returnResult;
    
displayURLFail:
    ONERouteLogInfo(@"open URL fail");
    
    result.resultCode = kRouteResultCode_Fail;
    result.resultDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                               @(result.resultCode),@"result_code",
                               @"失败，可能原因：展示方法调用有误",@"result_msg", nil];
    goto returnResult;
    
returnResult:
    return result;
}

#pragma mark private

//白名单是否包含URL
- (BOOL)whiteListContainURL:(NSString *)URL {
    
    for (NSDictionary *info in self.URLWhiteList) {
        RouteWhiteListItem *item = [RouteWhiteListItem toObject:info];
        if ([item.urlPath isEqualToString:URL]) {
            return YES;
        }
    }
    
    return NO;
}

@end


@implementation NSURL (setAdditionalParams)

static void * ONERouteURLParamsKey = (void *)@"ONERouteURLParamsKey";

- (NSDictionary *)ONERouteURLParams {
    
    id obj = objc_getAssociatedObject(self, ONERouteURLParamsKey);
    return obj;
}

- (void)setONERouteURLParams:(NSDictionary *)params {
    
    objc_setAssociatedObject(self, ONERouteURLParamsKey, params, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end
