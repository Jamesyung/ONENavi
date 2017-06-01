//
//  ONETransition.h
//  ELife
//
//  Created by yanglihua on 16/8/9.
//  Copyright © 2016年 Hangzhou TaiXuan Network Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  转场统一调度
 *
 *  使用条件：
 *  本类所有方法均是基于UIWindowLevelNormal级别的UIWindow
 *  并且该UIWindow的rootViewController是UITabBarController+UINavigationController模式
 */
@interface ONETransition : NSObject


/**
 *  最上层控制器
 *
 *  @return 控制器
 */
+ (UIViewController *)mostUpperPresentedViewController;


/**
 *  当前导航控制器
 *
 *  @return 导航控制器
 */
+ (UINavigationController *)currentNavigationController;


/**
 *  功能：[UINavigationController pushViewController:animated:]
 *  条件：App框架必须基于UITabBarController+UINavigationController模式
 *  作为所有pushViewController:animated:事件的统一入口
 *
 *  @param viewController 需要push的控制器
 *  @param animated       是否动画
 *
 *  @return 是否成功
 */
+ (BOOL)pushViewController:(UIViewController *)viewController
                  animated:(BOOL)animated;

/**
 *  功能：[UINavigationController popViewControllerAnimated:]
 *  条件：App框架必须基于UITabBarController+UINavigationController模式
 *  作为所有popViewControllerAnimated:事件的统一入口
 *
 *  @param animated 动画
 *
 *  @return 出栈控制器
 */
+ (UIViewController *)popViewControllerAnimated:(BOOL)animated;

/**
 *  功能：[UINavigationController popToViewController:animated:]
 *  条件：App框架必须基于UITabBarController+UINavigationController模式
 *  作为所有popToViewController:animated:事件的统一入口
 *
 *  @param viewController 出栈到该控制器
 *  @param animated       动画
 *
 *  @return 出栈的控制器
 */
+ (NSArray *)popToViewController:(UIViewController *)viewController
                        animated:(BOOL)animated;

/**
 *  功能：[UINavigationController popToRootViewControllerAnimated:]
 *  条件：App框架必须基于UITabBarController+UINavigationController模式
 *  作为所有popToRootViewControllerAnimated:事件的统一入口
 *
 *  @param animated       动画
 *
 *  @return 出栈的控制器
 */
+ (NSArray *)popToRootViewControllerAnimated:(BOOL)animated;

/**
 *  功能：[UIViewController presentViewController:animated:completion:]
 *  条件：1.需要展示在UITabBarController；2.App框架必须基于UITabBarController+UINavigationController模式
 *  作为presentViewController:animated:completion:事件的统一入口
 *
 *  viewControllerToPresent将会被放置在底部UITabBarController控制之上，与UITabBarController包含的UINavigationController平级
 *
 *  @param viewControllerToPresent 被展示控制器
 *  @param flag                    动画
 *  @param completion              完成回调
 *
 *  @return 是否成功
 */
+ (BOOL)presentViewController:(UIViewController *)viewControllerToPresent
                     animated:(BOOL)flag
                   completion:(void (^)(void))completion;

/**
 *  功能：[UIViewController dismissViewControllerAnimated:completion:]
 *  条件：1.已经展示在UITabBarController；2.App框架必须基于UITabBarController+UINavigationController模式
 *  作为dismissViewControllerAnimated:completion:事件的统一入口
 *
 *  与本类的presentViewController:animated:completion:方法形成对应
 *
 *  @param animated   动画
 *  @param completion 完成回调
 *
 *  @return 是否成功
 */
+ (BOOL)dismissViewControllerAnimated:(BOOL)animated
                           completion:(void (^)(void))completion;

@end
