//
//  NBLScrollTabItemView.h
//  NBLScrollTabDemo
//
//  Created by Neebel on 10/13/17.
//  Copyright © 2017 Neebel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NBLScrollTabItem.h"


@interface NBLScrollTabItemView : UIControl

@property (nonatomic, readonly) NBLScrollTabItem       *tabItem;

@property (nonatomic, strong) UILabel                   *titleLabel;
@property (nonatomic, strong) UIView                    *badgeView;
@property (nonatomic, assign) CGFloat                   padding;
@property (nonatomic, assign) CGFloat                   badgeWidth;
@property (nonatomic, readonly) CGFloat                 fitWidth;



- (instancetype)initWithTabItem:(NBLScrollTabItem *)tabItem;



- (void)setSelected:(BOOL)selected animated:(BOOL)animated;



- (void)adjustBadgeView;

@end
