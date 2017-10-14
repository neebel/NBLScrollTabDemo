//
//  NBLScrollTabTheme.h
//  NBLScrollTabDemo
//
//  Created by neebel on 2017/10/14.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NBLScrollTabTheme : NSObject

@property (nonatomic, assign) CGFloat titleViewHeight;
@property (nullable, nonatomic, strong) UIFont  *titleFont;//默认字体
@property (nullable, nonatomic, strong) UIColor *titleColor;//默认正常状态颜色
@property (nullable, nonatomic, strong) UIColor *highlightColor;//默认选中状态颜色
@property (nullable, nonatomic, strong) UIColor *badgeViewColor;//红点的颜色
@property (nullable, nonatomic, strong) UIColor *titleViewBGColor;//title背景色
@property (nullable, nonatomic, strong) UIColor *indicatorViewColor;//指示器的颜色

@end
