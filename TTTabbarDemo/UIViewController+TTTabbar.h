//
//  UIViewController+TTTabbar.h
//  TTTabbarDemo
//
//  Created by Galvin on 16/8/21.
//  Copyright © 2016年 TTube. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTabbar.h"
@interface UIViewController (TTTabbar)
@property (nonatomic, weak, readonly) TTTabbar *tt_tabbar;
@end
