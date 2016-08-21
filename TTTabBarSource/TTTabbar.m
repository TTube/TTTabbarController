//
//  TTTabbar.m
//  TTUIBaseFrame
//
//  Created by Galvin on 16/2/29.
//  Copyright © 2016年 Galvin. All rights reserved.
//

#import "TTTabbar.h"
#import "TTTabbarItemButton.h"
#import <objc/runtime.h>

@interface UITabBar (TTAddition)

@end

@implementation UITabBar (TTAddition)
+ (void)load {
    Method original = class_getInstanceMethod(self, @selector(hitTest:withEvent:));
    Method swizzle = class_getInstanceMethod(self, @selector(tt_hitTest:withEvent:));
    method_exchangeImplementations(original, swizzle);
}

- (UIView *)tt_hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *hitview = [self tt_hitTest:point withEvent:event];
    if (!hitview){
        for (UIView *subView in self.subviews) {
            UIView *subHitView = [subView hitTest:point withEvent:event];
            if (subHitView){
                return subHitView;
            }
        }
    }
    return hitview;
}

@end

@interface TTTabbar ()
@property (nonatomic, strong) UIImageView *topLineView;
@property (nonatomic, assign) BOOL needFadeWhenMoveToWindow;
@end

@implementation TTTabbar
- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]){
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder]){
        [self commonInit];
    }
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    if(!self.topLineView){
        for (UIView *view in self.subviews) {
            if([view isKindOfClass:NSClassFromString(@"UIImageView")]){
                NSLog(@"%@",view);
                if(view.frame.origin.y < 0){
                    self.topLineView = (UIImageView *)view;
                    self.topLineView.hidden = !self.showTopLine;
                }
            }
        }
    }

    if(CGSizeEqualToSize(CGSizeZero, self.frame.size)){
        //no need
        return;
    }
    if(self.needFadeWhenMoveToWindow){
        [UIView animateWithDuration:0.3 animations:^{
            for (TTTabbarItemButton *item in self.tabBarItems) {
                item.alpha = 1;
            }
        }];
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *hitTest = [super hitTest:point withEvent:event];
    if (!hitTest){
        for (UIView *subView in self.subviews) {
            CGPoint hitPoint = [self convertPoint:point toView:subView];
            if ([subView pointInside:hitPoint withEvent:event]){
                return subView;
            }
        }
    }
    return hitTest;
}

#pragma mark - public
- (void)setTabBarItems:(NSArray<TTTabbarItemButton *> *)items animated:(BOOL)animated
{
    self.tabBarItems = items;
    if(animated){
        for (TTTabbarItemButton *item in items) {
            item.alpha = 0;
        }
        if(!self.window){
            self.needFadeWhenMoveToWindow = YES;
        }else{
            [UIView animateWithDuration:0.3 animations:^{
                for (TTTabbarItemButton *item in items) {
                    item.alpha = 1;
                }
            }];
        }
    }
}

#pragma mark - private
- (void)commonInit
{
    _selectedIndex = -1;
    self.translucent = YES;
    self.barStyle = UIBarStyleDefault;
    _showTopLine = YES;
}

- (void)refreshView
{
    NSUInteger numberOfItems = self.tabBarItems.count;
    //建立约束,只支持平均宽度 非平均的有点反人类不打算支持 : )
    TTTabbarItemButton *lastItem;
    for (UIView *view in self.subviews) {
        if([view isKindOfClass:[TTTabbarItemButton class]]){
            [view removeFromSuperview];
        }
    }
    NSUInteger index = 0;
    for (TTTabbarItemButton *item in self.tabBarItems) {
        //add action
        UILongPressGestureRecognizer *longTapGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(tabBarItemDidLongTap:)];
        longTapGesture.minimumPressDuration = 1.0;
        [item addGestureRecognizer:longTapGesture];
        
//        UITapGestureRecognizer  *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tabBaritemDidDoubleClick:)];
//        doubleTap.numberOfTapsRequired = 2;
//        [item addGestureRecognizer:doubleTap];
        
        [item addTarget:self action:@selector(tabbarItemDidClick:) forControlEvents:UIControlEventTouchUpInside];
        [item addTarget:self action:@selector(tabbarOnTouchDown:) forControlEvents:UIControlEventTouchDown];
        [item addTarget:self action:@selector(tabbarOnTouchUp:) forControlEvents:UIControlEventTouchUpOutside];
        [item addTarget:self action:@selector(tabbarOnTouchUp:) forControlEvents:UIControlEventTouchCancel];

        //add to subview and layout
        [self addSubview:item];
        if(index == self.selectedIndex){
            item.selected = YES;
        }
        index ++;
        [self makeConstraintWithItem:item frontView:lastItem count:numberOfItems];
        lastItem = item;
    }
    [self layoutSubviews];
}

- (void)makeConstraintWithItem:(TTTabbarItemButton *)item frontView:(TTTabbarItemButton *)frontView count:(NSUInteger)count
{
    NSDictionary *viewsDic = frontView ? NSDictionaryOfVariableBindings(item,frontView) : NSDictionaryOfVariableBindings(item);
    //leading constraint
    if(frontView){
        [self addConstraint:[NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:frontView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
    }else{
        [self addConstraint:[NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
    }
    //vertical constraint
    if(item.currentConfig.specialHeight == 0){
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[item]-0-|" options:0 metrics:nil views:viewsDic]];
    }else{
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[item(%f)]-0-|",item.currentConfig.specialHeight] options:0 metrics:nil views:viewsDic]];
    }
    //宽度
    [self addConstraint:[NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0 / (CGFloat)count constant:0]];
}

#pragma mark - action response
- (void)tabBarItemDidLongTap:(UILongPressGestureRecognizer  *)gesture
{
    if([self.tabBarDelegate respondsToSelector:@selector(tabbar:didLongClickAtIndex:)]){
        NSUInteger index = [self.tabBarItems indexOfObject:(TTTabbarItemButton *)gesture.view];
        [self.tabBarDelegate tabbar:self didLongClickAtIndex:index];
    }
}

- (void)tabbarItemDidClick:(TTTabbarItemButton *)item
{
    if([self.tabBarDelegate respondsToSelector:@selector(tabBar:didSelectItem:atIndex:)]){
        NSUInteger index = [self.tabBarItems indexOfObject:item];
        [self.tabBarDelegate tabBar:self didSelectItem:item atIndex:index];
    }
}

- (void)tabbarOnTouchDown:(TTTabbarItemButton *)item {
    if (!item.currentConfig.highLightedWhenTouch){
        return;
    }
    item.selected = YES;
}

- (void)tabbarOnTouchUp:(TTTabbarItemButton *)item {
    if (item.selected || !item.currentConfig.highLightedWhenTouch){
        return;
    }
    item.selected = NO;
}

#pragma mark - getter & setter
- (void)setShowTopLine:(BOOL)showTopLine
{
    if(_showTopLine != showTopLine){
        _showTopLine = showTopLine;
        if (!_showTopLine) {
            self.topLineView.hidden = YES;
        }else{
            self.topLineView.hidden = NO;
        }
    }
}

- (void)setTabBarItems:(NSArray<TTTabbarItemButton *> *)tabBarItems
{
    if(_tabBarItems != tabBarItems){
        _tabBarItems = tabBarItems;
        [self refreshView];
    }
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    if(selectedIndex >= self.tabBarItems.count ){
        _selectedIndex = selectedIndex;
        return;
    }
    if(self.selectedItem){
        self.selectedItem.selected = NO;
    }
    TTTabbarItemButton *newSelectedItem = self.tabBarItems[selectedIndex];
    _selectedItem = newSelectedItem;
    _selectedIndex = selectedIndex;
    self.selectedItem.selected = YES;
}


@end
