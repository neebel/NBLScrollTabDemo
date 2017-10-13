//
//  NBLScrollTabItem.h
//  NBLScrollTabDemo
//
//  Created by Neebel on 10/13/17.
//  Copyright © 2017 Neebel. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NBLScrollTabItem : NSObject

@property (nonatomic, strong) NSString          *title;
@property (nonatomic, strong) UIFont            *font;
@property (nonatomic, strong) UIColor           *textColor;
@property (nonatomic, strong) UIColor           *highlightColor;
@property (nonatomic, assign) BOOL              isSelected;
@property (nonatomic, assign) BOOL              hideBadge;

@end





