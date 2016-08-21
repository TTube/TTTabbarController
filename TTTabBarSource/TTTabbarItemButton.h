//
//  TTTabbarItemButton.h
//  TTUIBaseFrame
//
//  Created by Galvin on 16/2/29.
//  Copyright © 2016年 Galvin. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 TTTabbarItemButtonConfig 用于TTTabbarItemButton的展示
 两种展示形式：图片+title & 纯图片
 如果展示方式为纯图片，则不需要传入title相关的属性
 否则需要set所有的属性
 */

extern const CGFloat kTabbarTitleDefaultHeight;
extern const CGFloat kTabbarIconDefaultHeight;

@interface TTTabbarItemButtonConfig : NSObject
@property (nonatomic, assign) CGFloat specialHeight;        //针对一些特别的按钮 如闲鱼、ins的 中间"+"按钮，需要更高的高度,默认为0,即不个性化
@property (nonatomic, assign) BOOL highLightedWhenTouch;
//icon
@property (nonatomic, strong) UIImage *normalImage;
@property (nonatomic, strong) UIImage *selectedImage;
//title
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) CGFloat fontSize;
@property (nonatomic, strong) UIColor *defaultColor;
@property (nonatomic, strong) UIColor *selectColor;
@property (nonatomic, strong) UIColor *badegColor;
@end


@interface TTTabbarItemButton : UIControl
@property (nonatomic, strong) TTTabbarItemButtonConfig  *currentConfig;

- (instancetype)initWithItemConfig:(TTTabbarItemButtonConfig *)config;
- (void)refreshViewWIthConfig:(TTTabbarItemButtonConfig *)config;
@end
