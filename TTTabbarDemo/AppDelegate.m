//
//  AppDelegate.m
//  TTTabar
//
//  Created by Galvin on 16/7/19.
//  Copyright © 2016年 TTube. All rights reserved.
//

#import "AppDelegate.h"
#import "UIBaseViewController.h"
#import "TTTabBarController.h"
#import "TTTabbarItemButton.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    UIBaseViewController *bsaeVC1 = [[UIBaseViewController alloc] initWithNibName:@"UIBaseViewController" bundle:nil];
    bsaeVC1.title = @"首页";
    UIBaseViewController *bsaeVC2 = [[UIBaseViewController alloc] initWithNibName:@"UIBaseViewController" bundle:nil];
    bsaeVC2.title = @"发现";
    UIBaseViewController *bsaeVC3 = [[UIBaseViewController alloc] initWithNibName:@"UIBaseViewController" bundle:nil];
    bsaeVC3.title = @"朋友";
    UIBaseViewController *bsaeVC4 = [[UIBaseViewController alloc] initWithNibName:@"UIBaseViewController" bundle:nil];
    bsaeVC4.title = @"我";
    UINavigationController *navi1 = [[UINavigationController alloc] initWithRootViewController:bsaeVC1];
    UINavigationController *navi2 = [[UINavigationController alloc] initWithRootViewController:bsaeVC2];
    UINavigationController *navi3 = [[UINavigationController alloc] initWithRootViewController:bsaeVC3];
    UINavigationController *navi4 = [[UINavigationController alloc] initWithRootViewController:bsaeVC4];
    NSUInteger index = 0;
    NSArray *controllerArr = @[navi1,navi2,navi3,navi4];
    TTTabBarController *tabbarController = [[TTTabBarController alloc] init];
    for (UIViewController *controller in controllerArr) {
        TTTabbarItemButtonConfig *config = [self makeConfigWithIndex:index];
        [tabbarController addController:controller withTabBarConfig:config];
        index ++;
    }
    self.window.rootViewController = tabbarController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (TTTabbarItemButtonConfig *)makeConfigWithIndex:(NSUInteger)index
{
    static NSArray *configArr;
    if(!configArr){
        configArr = @[
                      @[@"首页",@"home_normal",@"home_highlight_large"],
                      @[@"股市",@"mycity_normal",@"mycity_highlight"],
                      @[@"基金",@"message_normal",@"message_highlight"],
                      @[@"我",@"account_normal",@"account_highlight"],
                      ];
    }
    TTTabbarItemButtonConfig *config = [[TTTabbarItemButtonConfig alloc] init];
    config.fontSize = 12;
    config.defaultColor = [UIColor lightGrayColor];
    config.selectColor = [UIColor orangeColor];
    config.title = configArr[index][0];
    config.normalImage = [UIImage imageNamed:configArr[index][1]];
    config.selectedImage = [UIImage imageNamed:configArr[index][2]];
    return config;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
