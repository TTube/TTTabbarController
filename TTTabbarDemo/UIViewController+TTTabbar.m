//
//  UIViewController+TTTabbar.m
//  TTTabbarDemo
//
//  Created by Galvin on 16/8/21.
//  Copyright © 2016年 TTube. All rights reserved.
//

#import "UIViewController+TTTabbar.h"
#import "TTTabBarController.h"
@implementation UIViewController (TTTabbar)
- (TTTabbar *)tt_tabbar {
    if (self.tabBarController && [self.tabBarController isKindOfClass:[TTTabBarController class]]){
        return ((TTTabBarController *)self.tabBarController).TT_tabBar;
    }else if ([self isKindOfClass:[TTTabBarController class]]){
        return ((TTTabBarController *)self.tabBarController).TT_tabBar;
    }
    return nil;
}
@end
