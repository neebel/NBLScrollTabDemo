//
//  NBLScrollTabView.h
//  NBLScrollTabDemo
//
//  Created by Neebel on 10/13/17.
//  Copyright © 2017 Neebel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NBLScrollTabItemView.h"
#import "NBLScrollTabTheme.h"

@class NBLScrollTabView;

@protocol NBLScrollTabViewDelegate <NSObject>

- (void)tabView:(NBLScrollTabView *)tabView didSelectIndex:(NSUInteger)index;

@end

@interface NBLScrollTabView : UIView

@property (nonatomic, strong) UIScrollView      *scrollView;
@property (nonatomic, strong) UIView            *indicatorView;
@property (nonatomic, assign) CGFloat           maxSpacing;     //default = 40;
@property (nonatomic, assign) CGFloat           minSpacing;     //default = 20;

@property (nonatomic, copy)   NSArray<NBLScrollTabItem *>   *tabItems;
@property (nonatomic, assign) NSUInteger                    selectedIndex;

@property (nonatomic, weak)   id<NBLScrollTabViewDelegate>  delegate;

- (instancetype)initWithFrame:(CGRect)frame theme:(NBLScrollTabTheme *)theme;

//设置选中某页
- (void)setSelectedIndex:(NSUInteger)index animated:(BOOL)animated;

//更新indicatorView位置
- (void)updateWithTabPageOffset:(CGFloat)offset;

- (void)updateTabItems:(NSArray<NBLScrollTabItem *> *)tabItems;

@end
