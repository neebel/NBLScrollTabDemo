//
//  NBLScrollTabItem.m
//  NBLScrollTabDemo
//
//  Created by Neebel on 10/13/17.
//  Copyright © 2017 Neebel. All rights reserved.
//

#import "NBLScrollTabItem.h"

@implementation NBLScrollTabItem


- (instancetype)init
{
    self = [super init];
    if (self) {
        _textColor = [UIColor blueColor];
        _highlightColor = [UIColor redColor];
    }
    return self;
}

@end
