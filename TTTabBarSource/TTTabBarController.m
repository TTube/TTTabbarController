//
//  TTTabBarController.m
//  TTUIBaseFrame
//
//  Created by Galvin on 16/2/29.
//  Copyright © 2016年 Galvin. All rights reserved.
//

#import "TTTabBarController.h"
#import "TTTabbar.h"
#import "TTTabbarItemButton.h"

@interface TTTabBarController () <TTTabbarDelegate>
@property (nonatomic, strong) NSMutableArray *configArr;
@property (nonatomic, strong) NSMutableArray *controllerArr;
@end


@implementation TTTabBarController
@synthesize TT_tabBar = _TT_tabBar;
- (instancetype)init
{
    if(self = [super init]){
        _defaultIndex = 0;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tabBar setBackgroundImage:[[UIImage alloc] init]];
    [self.tabBar  setShadowImage:[[UIImage alloc] init]];

    self.selectedIndex = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
        [self refreshView];
}


#pragma mark - public
- (void)refreshView
{
    [self setViewControllers:self.controllerArr animated:NO];
    for (UIView *subView in self.tabBar.subviews) {
        if(![subView isKindOfClass:NSClassFromString(@"TTTabbar")]){
            [subView removeFromSuperview];
        }
    }
    [self.tabBar bringSubviewToFront:self.TT_tabBar];
    self.TT_tabBar.alpha = 1;
    self.selectedIndex = self.defaultIndex;
    NSMutableArray *itemsArr = [NSMutableArray array];
    for (TTTabbarItemButtonConfig *config in self.configArr) {
        [itemsArr addObject:[[TTTabbarItemButton alloc] initWithItemConfig:config]];
    }
    self.TT_tabBar.tabBarItems = itemsArr;
    self.TT_tabBar.selectedIndex = self.selectedIndex;
}

- (void)addController:(UIViewController *)controller withTabBarConfig:(TTTabbarItemButtonConfig *)config
{
    [self.controllerArr addObject:controller];
    [self.configArr addObject:config];
}

- (void)removeController:(UIViewController *)controller
{
    if([self.controllerArr containsObject:controller]){
        NSUInteger index = [self.controllerArr indexOfObject:controller];
        [self.controllerArr removeObjectAtIndex:index];
        [self.configArr removeObjectAtIndex:index];
    }
}

#pragma mark - private


#pragma mark - delegate
- (void)tabbar:(TTTabbar *)tabbar didLongClickAtIndex:(NSInteger)index
{
    self.selectedIndex = index;
}

- (void)tabBar:(TTTabbar *)tabBar didSelectItem:(TTTabbarItemButton *)item atIndex:(NSUInteger)index
{
    self.selectedIndex = index;
}

#pragma mark - getter & setter
// super
- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    if(selectedIndex >= self.viewControllers.count){
        return;
    }
    
    self.TT_tabBar.selectedIndex = selectedIndex;
    UIViewController *controller = [self.viewControllers objectAtIndex:selectedIndex];
    [self setSelectedViewController:controller];
    [super setSelectedIndex:selectedIndex];
    
}

- (void)setSelectedViewController:(__kindof UIViewController *)selectedViewController
{
    if(![self.viewControllers containsObject:selectedViewController]){
        return;
    }
    if(self.selectedViewController != selectedViewController){
        NSUInteger index = [self.viewControllers indexOfObject:selectedViewController];
        self.TT_tabBar.selectedIndex = index;
        [super setSelectedViewController:selectedViewController];
    }
}

// self
- (TTTabbar *)TT_tabBar
{
    if(!_TT_tabBar){
        _TT_tabBar = [[TTTabbar alloc] init];
        _TT_tabBar.showTopLine = YES;
        [self.tabBar addSubview:_TT_tabBar];
        _TT_tabBar.frame = self.tabBar.bounds;
        _TT_tabBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin |UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _TT_tabBar.tabBarDelegate = self;
    }
    return _TT_tabBar;
}

- (void)setTT_tabBar:(TTTabbar *)TT_tabBar
{
    if(_TT_tabBar != TT_tabBar){
        _TT_tabBar = TT_tabBar;
    }
}

- (NSMutableArray *)configArr
{
    if(!_configArr){
        _configArr = @[].mutableCopy;
    }
    return _configArr;
}

- (NSMutableArray *)controllerArr
{
    if(!_controllerArr){
        _controllerArr = @[].mutableCopy;
    }
    return _controllerArr;
}

@end
