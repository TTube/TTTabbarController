//
//  TTTabBarController.h
//  TTUIBaseFrame
//
//  Created by Galvin on 16/2/29.
//  Copyright © 2016年 Galvin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTabbarItemButton.h"
@class TTTabbar, TTTabbarItemButtonConfig;
@interface TTTabBarController : UITabBarController
@property (nonatomic, strong, readonly) TTTabbar *TT_tabBar;
@property (nonatomic, assign) NSUInteger defaultIndex;

- (void)refreshView;
- (void)refreshView:(BOOL)force;
- (void)addController:(UIViewController *)controller withTabBarConfig:(TTTabbarItemButtonConfig *)config;
- (void)removeController:(UIViewController *)controller;
@end
