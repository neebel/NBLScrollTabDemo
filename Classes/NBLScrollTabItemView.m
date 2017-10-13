//
//  NBLScrollTabItemView.m
//  NBLScrollTabDemo
//
//  Created by Neebel on 10/13/17.
//  Copyright © 2017 Neebel. All rights reserved.
//

#import "NBLScrollTabItemView.h"

static NSInteger const kNBLInvalidWidth = -1;
@interface NBLScrollTabItemView()

@property (nonatomic, assign) CGFloat      cachedWidth;

@end



@implementation NBLScrollTabItemView

- (void)dealloc
{
    [_tabItem removeObserver:self forKeyPath:@"hideBadge"];
}

- (instancetype)initWithTabItem:(NBLScrollTabItem *)tabItem
{
    self = [self initWithFrame:CGRectMake(0, 0, 80, 40)];
    if (self) {
        _padding = 0;
        _badgeWidth = 8;
        _cachedWidth = kNBLInvalidWidth;
    
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_padding, 0, self.frame.size.width - 2*_padding, self.frame.size.height)];
        _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = tabItem.font ? : [UIFont systemFontOfSize:15];
        _titleLabel.textColor = tabItem.textColor;
        _titleLabel.highlightedTextColor = tabItem.highlightColor;
        _titleLabel.text = tabItem.title;
        [self addSubview:_titleLabel];

        _badgeView = [[UIView alloc] initWithFrame:CGRectMake(_titleLabel.frame.origin.x + _titleLabel.frame.size.width - _badgeWidth/2 - 2, 10, _badgeWidth, _badgeWidth)];
        _badgeView.backgroundColor = [UIColor colorWithRed:0.9877 green:0.2833 blue:0.0299 alpha:1.0];
        _badgeView.layer.cornerRadius = _badgeWidth/2;
        _badgeView.hidden = tabItem.hideBadge;
        [self addSubview:_badgeView];
        
        _tabItem = tabItem;
        
        [_tabItem addObserver:self
                   forKeyPath:@"hideBadge"
                      options:NSKeyValueObservingOptionNew
                      context:NULL];
    }

    return self;
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if (object == self.tabItem) {
        BOOL isHidden = [change[NSKeyValueChangeNewKey] boolValue];
        if (isHidden != self.badgeView.isHidden) {
            self.badgeView.hidden = isHidden;
        }
    }
}


#pragma mark - Setter

- (void)setSelected:(BOOL)selected
{
    if (selected == super.isSelected) {
        return;
    }

    [super setSelected:selected];
    self.titleLabel.highlighted = selected;
}


- (void)setPadding:(CGFloat)padding
{
    if (_padding == padding) {
        return;
    }

    _padding = padding;
    _titleLabel.frame = CGRectMake(padding, 0, self.frame.size.width - 2*padding, self.frame.size.height);
    self.cachedWidth = kNBLInvalidWidth;
}


- (CGFloat)fitWidth
{
    if (self.cachedWidth == kNBLInvalidWidth) {

        CGSize titleSize = [self.titleLabel textRectForBounds:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 30) limitedToNumberOfLines:1].size;
        self.cachedWidth = floor(titleSize.width + 4 + 2 * self.padding);
    }

    return self.cachedWidth;
}

#pragma mark - Public 

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if (self.isSelected == selected) {
        return;
    }


    if (animated) {
        [UIView animateWithDuration:0.3 animations:^{
            self.selected = selected;
        }];
    } else {
        self.selected = selected;
    }
}


- (void)adjustBadgeView
{
     self.badgeView.frame = CGRectMake(_titleLabel.frame.origin.x + _titleLabel.frame.size.width - _badgeWidth/2 - 2, 10, _badgeWidth, _badgeWidth);
}

@end
