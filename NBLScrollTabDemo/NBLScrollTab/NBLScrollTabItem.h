//
//  NBLScrollTabItem.h
//  NBLScrollTabDemo
//
//  Created by Neebel on 10/13/17.
//  Copyright © 2017 Neebel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NBLScrollTabItem : NSObject

@property (nonatomic, strong) NSString          *title;    //支持个性化配置
@property (nonatomic, strong) UIFont            *font;     //支持个性化配置
@property (nonatomic, strong) UIColor           *textColor;//支持个性化配置
@property (nonatomic, strong) UIColor           *highlightColor;//支持个性化配置
@property (nonatomic, assign) BOOL              isSelected;//暂时不支持个性化配置
@property (nonatomic, assign) BOOL              hideBadge; //支持个性化配置

@end





