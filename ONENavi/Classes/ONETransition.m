//
//  ONETransition.m
//  ELife
//
//  Created by yanglihua on 16/8/9.
//  Copyright © 2016年 Hangzhou TaiXuan Network Technology Co., Ltd. All rights reserved.
//

#import "ONETransition.h"
#import "ONERouteLog.h"

@implementation ONETransition

+ (UIViewController *)mostUpperPresentedViewController {
    
    UIWindow *normalWindow = nil;
    NSEnumerator *frontToBackWindows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
    for (UIWindow *window in frontToBackWindows){
        BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
        BOOL windowIsVisible = !window.hidden && window.alpha > 0;
        BOOL windowLevelNormal = window.windowLevel == UIWindowLevelNormal;
        
        if (windowOnMainScreen && windowIsVisible && windowLevelNormal) {
            normalWindow = window;
            break;
        }
    }
    
    UIViewController *srcViewController = normalWindow.rootViewController;
    NSInteger howManyPresented = 0;
    while ([srcViewController presentedViewController]) {
        srcViewController = [srcViewController presentedViewController];
        howManyPresented++;
        ONERouteLogInfo(@"previous presentVC rank:%ld name:%@",(long)howManyPresented,NSStringFromClass([srcViewController class]));
    }
    
    return srcViewController;
}

+ (UINavigationController *)currentNavigationController {
    
    UIViewController *srcViewController = [ONETransition mostUpperPresentedViewController];
    
    if ([srcViewController isKindOfClass:[UITabBarController class]]) {
        
        UITabBarController *tabBarCtrl = (UITabBarController *)srcViewController;
        if ([tabBarCtrl.selectedViewController isKindOfClass:[UINavigationController class]]) {
            return (UINavigationController *)tabBarCtrl.selectedViewController;
        }
        
        return nil;
    }
    
    if ([srcViewController isKindOfClass:[UINavigationController class]]) {
        return (UINavigationController *)srcViewController;
    }
    
    return nil;
}

+ (BOOL)pushViewController:(UIViewController *)viewController
                  animated:(BOOL)animated {
    
    ONERouteLogInfo(@"pushViewController");
    UINavigationController *navigationController = [ONETransition currentNavigationController];
    
    if (navigationController == nil) {
        ONERouteLogInfo(@"can not find NavigationController");
        return NO;
    }
    
    [navigationController pushViewController:viewController
                                    animated:animated];
    return YES;
}

+ (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    
    ONERouteLogInfo(@"popViewControllerAnimated");
    UINavigationController *navigationController = [ONETransition currentNavigationController];
    
    if (navigationController == nil) {
        ONERouteLogInfo(@"can not find NavigationController");
        return nil;
    }
    
    return [navigationController popViewControllerAnimated:animated];
}

+ (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    ONERouteLogInfo(@"popToViewController");
    UINavigationController *navigationController = [ONETransition currentNavigationController];
    
    if (navigationController == nil) {
        ONERouteLogInfo(@"can not find NavigationController");
        return nil;
    }
    
    return [navigationController popToViewController:viewController animated:animated];
}

+ (NSArray *)popToRootViewControllerAnimated:(BOOL)animated {
    
    ONERouteLogInfo(@"popToRootViewControllerAnimated");
    UINavigationController *navigationController = [ONETransition currentNavigationController];
    
    if (navigationController == nil) {
        ONERouteLogInfo(@"can not find NavigationController");
        return nil;
    }
    
    return [navigationController popToRootViewControllerAnimated:animated];
}

+ (BOOL)presentViewController:(UIViewController *)viewControllerToPresent
                     animated:(BOOL)animated
                   completion:(void (^)(void))completion {
    
    ONERouteLogInfo(@"presentViewController");
    UIViewController *srcViewController = [ONETransition mostUpperPresentedViewController];
    [srcViewController presentViewController:viewControllerToPresent
                                    animated:animated
                                  completion:completion];
    
    return YES;
}

+ (BOOL)dismissViewControllerAnimated:(BOOL)animated
                           completion:(void (^)(void))completion {
    
    ONERouteLogInfo(@"dismissViewController");
    UIViewController *srcViewController = [ONETransition mostUpperPresentedViewController];
    [srcViewController dismissViewControllerAnimated:animated
                                          completion:completion];
    
    return YES;
}

@end
