//
//  NBLScrollTabItemView.h
//  NBLScrollTabDemo
//
//  Created by Neebel on 10/13/17.
//  Copyright © 2017 Neebel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NBLScrollTabItem.h"
#import "NBLScrollTabTheme.h"

@interface NBLScrollTabItemView : UIControl

@property (nonatomic, readonly) NBLScrollTabItem *tabItem;
@property (nonatomic, readonly) CGFloat          fitWidth;

- (instancetype)initWithTabItem:(NBLScrollTabItem *)tabItem theme:(NBLScrollTabTheme *)theme;

- (void)setSelected:(BOOL)selected animated:(BOOL)animated;

- (void)adjustBadgeView;

@end
