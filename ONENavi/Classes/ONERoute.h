//
//  ONERoute.h
//  ELife
//
//  Created by yanglihua on 16/8/8.
//  Copyright © 2016年 Hangzhou TaiXuan Network Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RouteResult.h"


/**
 *  路由展示方式
 *
 *  - kOpenONEURLMode_Custom:  自定义打开方式；重写customizeOpeningURL:
 *  - kOpenONEURLMode_Push:    pushViewController；需要对传入参数处理 重写routeModuleSetParams:
 *  - kOpenONEURLMode_Present: presentViewController；需要对传入参数处理 重写routeModuleSetParams:
 */
typedef NS_ENUM(NSInteger, OpenONEURLMode) {
    kOpenONEURLMode_Custom,
    kOpenONEURLMode_Push,
    kOpenONEURLMode_Present
};

/**
 *  导航路由方法扩展
 */
@protocol ONERouteExtendProtocol <NSObject>

@optional

//需要对传入参数处理，可以重写方法
//
//本方法先于转场动作（Push、Present、Custom）之前调用
//params:对传入参数处理
//urlString:路由地址
- (void)routeModuleSetParams:(NSDictionary *)params toURL:(NSString *)urlString;

//
//depreciate please use -routeModuleSetParams:toURL:
//
//需要对传入参数处理，可以重写方法
//本方法先于转场动作（Push、Present、Custom）之前调用
- (void)routeModuleSetParams:(NSDictionary *)params;


//自定义打开方式
//
//kOpenONEURLMode_Custom 需要override此方法
//url:路由地址
//params:对传入参数处理，推荐直接在本方法对入参进行处理
- (void)customizeOpeningURL:(NSString *)urlString setParams:(NSDictionary *)params;

//
//depreciate please use -customizeOpeningURL:setParams:
//
- (void)customOpenMode;

@end

/**
 *  界面导航路由
 *  通过openURL方式打开界面，起到解耦效果
 *  应用场景：不同组件调用界面
 *  不适用场景：组件内部请避免滥用
 *
 *  流程：
 *  被调用方，在+(void)load方法中 将可以被调起的界面进行注册，将URL与类进行关联
 *  调用方，通过openURL请求打开界面
 *  ONERoute，根据约定规则进行处理
 *
 *  必要方法：
 *  被调用方，必须实现-(instancetype)init; 可选-(void)routeModuleSetParams:(NSDictionary *)params
 *  调用方:可以将参数直接附在链接后面，也可以在NSURL调用setONERouteURLParams: 添加参数
 */
@interface ONERoute : NSObject

+ (instancetype)sharedRoute;

/**
 *  注册
 *  界面的 +(void)load 调用此方法进行注册，将URL与类进行关联；并且已经加入白名单
 *
 *  @param url       界面关联URL
 *  @param className 类名
 *  @param mode      展示方式(OpenONEURLMode): pop/present/custom
 *
 *  @return 是否成功
 */
- (BOOL)registerONEURL:(NSURL *)url class:(NSString *)className mode:(OpenONEURLMode)mode;

//注销
- (BOOL)unregisterONEURL:(NSURL *)url;


/**
 *  检查是否满足打开开放界面的条件
 *
 *  @param url 与openONEURL方法的url相同
 *
 *  @return 是否满足条件
 */
- (BOOL)canOpenONEURL:(NSURL *)url;

/**
 *  【统一入口】调起开放界面
 *  打开开放界面的前提条件：该开放界面对应的Class已经被注册，具体参见registerONEURL:class:mode:
 *
 *  @param url 界面提前约定URL,具体参见各界面说明
 *             必须保证参数规范一致性，具体参见各界面说明
 *             可以将参数直接附在链接后面，也可以在NSURL调用setONERouteURLParams: 添加参数
 *             对于基本参数类型的，可以直接在链接后面进行添加
 *             复杂参数类型，需要通过调用NSURL方法进行添加
 *
 *  @return 结果
 */
- (RouteResult *)openONEURL:(NSURL *)url;

@end

@interface NSURL (setAdditionalParams)

//简单参数类型可以直接通过url query方式，复杂参数类型的配置可以通过该属性
@property (nonatomic, copy) NSDictionary *ONERouteURLParams;

@end
