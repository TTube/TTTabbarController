//
//  TTTabbarItemButton.m
//  TTUIBaseFrame
//
//  Created by Galvin on 16/2/29.
//  Copyright © 2016年 Galvin. All rights reserved.
//

#import "TTTabbarItemButton.h"

const CGFloat kTabbarTitleDefaultHeight = 20.0;
const CGFloat kTabbarIconDefaultHeight = 29.0;

#define SCREEN_SCALE  [UIScreen mainScreen].scale

typedef NS_ENUM(NSInteger, TTTabbarItemButtonDisplayType) {
    TTTabbarItemButtonDisplayTypeDefault = 1,
    TTTabbarItemButtonDisplayTypeOnlyImage,
};

@implementation TTTabbarItemButtonConfig

@end


@interface TTTabbarItemButton ()
@property (nonatomic, assign) TTTabbarItemButtonDisplayType currentDisplayType;
//view
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@end


@implementation TTTabbarItemButton
- (instancetype)initWithItemConfig:(TTTabbarItemButtonConfig *)config
{
    if(self = [super init]){
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.currentConfig = config;
        [self refreshView];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if([keyPath isEqualToString:@"selectedImage"] || [keyPath isEqualToString:@"normalImage"]){
        self.iconImageView.image = self.selected ? self.currentConfig.selectedImage : self.currentConfig.normalImage;
    }
}

#pragma mark - private
- (void)refreshView
{
    //根据config初始化
    if(self.currentConfig.title.length > 0 && self.currentConfig.title){
        self.currentDisplayType = TTTabbarItemButtonDisplayTypeDefault;
    }else{
        self.currentDisplayType = TTTabbarItemButtonDisplayTypeOnlyImage;
    }
    [self removeAllConstraint];
    if(self.currentDisplayType == TTTabbarItemButtonDisplayTypeDefault){
        self.titleLabel.text = self.currentConfig.title;
        self.titleLabel.textColor = self.selected ? self.currentConfig.selectColor : self.currentConfig.defaultColor;
    }else{
        if(_titleLabel){
            [_titleLabel removeFromSuperview];
            _titleLabel = nil;
        }
    }
    self.iconImageView.image = self.selected ? self.currentConfig.selectedImage : self.currentConfig.normalImage;
    //设置约束
    [self setupConstraint];
}

- (void)setupConstraint
{
    if(self.currentDisplayType == TTTabbarItemButtonDisplayTypeDefault){
        NSDictionary *constraintDic = @{
                                        @"title":self.titleLabel,
                                        @"icon":self.iconImageView
                                        };
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[title]-0-|" options:0 metrics:nil views:constraintDic]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[icon]-0-|" options:0 metrics:nil views:constraintDic]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-0-[icon]-0-[title(%f)]-0-|",kTabbarTitleDefaultHeight] options:0 metrics:nil views:constraintDic]];
    }else{
        NSDictionary *constraintDic = @{
                                        @"icon":self.iconImageView
                                        };
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[icon]-0-|" options:0 metrics:nil views:constraintDic]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[icon]-0-|" options:0 metrics:nil views:constraintDic]];
    }
}

- (void)removeAllConstraint
{
    for (NSLayoutConstraint *constaint in self.constraints) {
        [self removeConstraint:constaint];
    }
}


- (void)refreshIconAndLabel
{
    if(_iconImageView){
        _iconImageView.image = self.selected ? self.currentConfig.selectedImage : self.currentConfig.normalImage;
    }
    if(_titleLabel){
        _titleLabel.textColor = self.selected ? self.currentConfig.selectColor : self.currentConfig.defaultColor;
    }
}

#pragma mark - public
- (void)refreshViewWIthConfig:(TTTabbarItemButtonConfig *)config
{
    self.currentConfig = config;
    [self refreshView];
}



#pragma mark - getter & setter
- (void)setCurrentConfig:(TTTabbarItemButtonConfig *)currentConfig
{
    if(_currentConfig != currentConfig){
        _currentConfig = currentConfig;
        __weak typeof(self) weakSelf = self;
        //设置符合屏幕scale的image
        if(_currentConfig.normalImage.scale != SCREEN_SCALE){
            UIImage *normalImage = _currentConfig.normalImage;
            _currentConfig.normalImage = nil;
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSData *imageData = UIImagePNGRepresentation(normalImage);
                UIImage *newImage = [UIImage imageWithData:imageData scale:SCREEN_SCALE];
                currentConfig.normalImage = newImage;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf refreshIconAndLabel];
                });
            });
        }
        if(_currentConfig.selectedImage.scale != SCREEN_SCALE){
            UIImage *selectedImage = _currentConfig.selectedImage;
            _currentConfig.selectedImage = nil;
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSData *imageData = UIImagePNGRepresentation(selectedImage);
                UIImage *newImage = [UIImage imageWithData:imageData scale:SCREEN_SCALE];
                currentConfig.selectedImage = newImage;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf refreshIconAndLabel];
                });
            });
        }

    }
}

- (UIImageView *)iconImageView
{
    if(!_iconImageView){
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.contentMode = UIViewContentModeBottom;
        _iconImageView.clipsToBounds = NO;
        _iconImageView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_iconImageView];
    }
    return _iconImageView;
}

- (UILabel *)titleLabel
{
    if(!_titleLabel){
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:self.currentConfig.fontSize];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = self.currentConfig.selectColor;
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    [self refreshIconAndLabel];
}

@end
