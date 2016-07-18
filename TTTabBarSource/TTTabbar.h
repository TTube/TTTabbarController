//
//  TTTabbar.h
//  TTUIBaseFrame
//
//  Created by Galvin on 16/2/29.
//  Copyright © 2016年 Galvin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TTTabbarItemButton,TTTabbar;

@protocol TTTabbarDelegate <NSObject>
@optional
- (void)tabbar:(nullable TTTabbar *)tabbar didLongClickAtIndex:(NSInteger)index;
- (void)tabBar:(nullable TTTabbar *)tabBar didSelectItem:(nonnull TTTabbarItemButton *)item atIndex:(NSUInteger)index;
@end

@interface TTTabbar : UIToolbar
@property (nullable, nonatomic, strong) NSArray <TTTabbarItemButton *> *tabBarItems;
@property (nullable, nonatomic, weak) id<TTTabbarDelegate> tabBarDelegate;     // weak reference. default is nil
@property (nonatomic, assign) NSUInteger selectedIndex; //cuurent selected Index default is 0
@property (nullable, nonatomic, weak, readonly) TTTabbarItemButton *selectedItem; // will show feedback based on mode. default is nil
@property (nonatomic, assign) BOOL showTopLine;


- (void)setTabBarItems:(nullable NSArray<TTTabbarItemButton *> *)items animated:(BOOL)animated;   // will fade in or out or reorder and adjust spacing
@end
