//
//  NBLScrollTabView.m
//  NBLScrollTabDemo
//
//  Created by Neebel on 10/13/17.
//  Copyright © 2017 Neebel. All rights reserved.
//

#import "NBLScrollTabView.h"
#import "NBLScrollTabItemView.h"

@interface NBLScrollTabView()

@property (nonatomic, strong) UIView   *innerView;
@property (nonatomic, copy)   NSArray  *tabItemViews;
@property (nonatomic, assign) CGFloat  totalTabsWidth;
@property (nonatomic, assign) UIEdgeInsets  scrollEdge;
@property (nonatomic, strong) NBLScrollTabTheme *theme;

@end

@implementation NBLScrollTabView

- (instancetype)initWithFrame:(CGRect)frame theme:(NBLScrollTabTheme *)theme
{
    self = [super initWithFrame:frame];
    if (self) {
        _theme = theme;
        _minSpacing = 20;
        _maxSpacing = 40;
        _selectedIndex = NSUIntegerMax;
        
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.alwaysBounceVertical = NO;
        _scrollView.backgroundColor = _theme.titleViewBGColor;

        _indicatorView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height - 2, 2, 2)];
        _innerView.autoresizingMask = (UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin);
        _indicatorView.hidden = YES;
        _indicatorView.backgroundColor = _theme.indicatorViewColor;
        [_scrollView addSubview:_indicatorView];

        [self addSubview:_scrollView];
    }
    return self;
}



#pragma mark - Getter & Setter

- (void)setTabItems:(NSArray<NBLScrollTabItem *> *)tabItems
{
    if ([_tabItems isEqualToArray:tabItems]) {
        return;
    }
    _tabItems = [tabItems copy];

    [self reloadTabItems:tabItems];
}


- (void)setSelectedIndex:(NSUInteger)index
{
    [self setSelectedIndex:index animated:NO];

}

#pragma mark - Public

- (void)setSelectedIndex:(NSUInteger)index animated:(BOOL)animated
{
    if (_selectedIndex == index || index >= self.tabItemViews.count) {
        return;
    }
    _selectedIndex = index;

    [self shiftIndicatorToIndex:index animated:YES];
    if ([self.delegate respondsToSelector:@selector(tabView:didSelectIndex:)]) {
        [self.delegate tabView:self didSelectIndex:index];
    }
}


- (void)updateWithTabPageOffset:(CGFloat)offset
{
    if (self.tabItemViews.count == 0) {
        return;
    }

    NSInteger pageIndex = floor(offset);
    CGRect startItemFrame = CGRectZero;
    CGRect nextItemFrame = CGRectZero;

    if (pageIndex < 0) {
        nextItemFrame = [[self.tabItemViews firstObject] frame];
        startItemFrame = CGRectMake(-nextItemFrame.size.width, 0,
                                   nextItemFrame.size.width, nextItemFrame.size.height);
    } else if (pageIndex >= self.tabItemViews.count - 1) {
        startItemFrame = [[self.tabItemViews lastObject] frame];
        nextItemFrame = CGRectMake(startItemFrame.origin.x + startItemFrame.size.width + self.minSpacing,
                                   0, startItemFrame.size.width, startItemFrame.size.height);

    } else {
        startItemFrame = [self.tabItemViews[pageIndex] frame];
        nextItemFrame = [self.tabItemViews[pageIndex + 1] frame];
    }

    CGFloat paddingOffset = offset - pageIndex;
    CGFloat xOffset = startItemFrame.origin.x + (nextItemFrame.origin.x - startItemFrame.origin.x) * paddingOffset;
    CGFloat paddingWidth = (nextItemFrame.size.width - startItemFrame.size.width) * paddingOffset;
    CGRect indicatorFrame = CGRectMake(xOffset, self.scrollView.frame.size.height - 2, startItemFrame.size.width + paddingWidth, 2);
    self.indicatorView.frame = indicatorFrame;
}


- (void)updateTabItems:(NSArray<NBLScrollTabItem *> *)tabItems
{
    [self loadTabItems:tabItems];
    [self adjustIndicatorView:self.selectedIndex];
    [self shiftIndicatorToIndex:self.selectedIndex animated:YES];
}

#pragma mark Private

- (void)adjustIndicatorView:(NSInteger)index
{
    CGRect selItemFrame = [self.tabItemViews[index] frame];
    CGRect indicatorFrame = CGRectMake(selItemFrame.origin.x, self.scrollView.frame.size.height - 2, selItemFrame.size.width, 2);
    self.indicatorView.frame = indicatorFrame;
}


- (void)loadTabItems:(NSArray<NBLScrollTabItem *> *)tabItems
{
    [self clearTabItems];
    
    if (tabItems.count == 0) {
        return;
    }
    
    self.indicatorView.hidden = NO;
    CGFloat totalWidth = 0;
    NSMutableArray *tabViews = [NSMutableArray array];
    
    for (NSInteger i = 0; i < tabItems.count; i++) {
        NBLScrollTabItem *tabItem = tabItems[i];
        NBLScrollTabItemView *tabItemView = [self buildTabItemView:tabItem];
        
        [tabViews addObject:tabItemView];
        totalWidth += tabItemView.fitWidth;
    }
    
    self.tabItemViews = [tabViews copy];
    self.totalTabsWidth = totalWidth;
    [self layoutTabItemViews];
    [self.scrollView bringSubviewToFront:self.indicatorView];
}

#pragma mark - TabItems

- (void)reloadTabItems:(NSArray<NBLScrollTabItem *> *)tabItems
{
    [self loadTabItems:tabItems];
    self.selectedIndex = 0;
    [self adjustIndicatorView:self.selectedIndex];
}


- (void)layoutTabItemViews
{
    if (self.tabItemViews.count == 0) {
        return;
    }

    CGFloat averageSpacing = floor((self.frame.size.width - self.totalTabsWidth)/(self.tabItemViews.count + 1));
    CGFloat spacing = MIN(MAX(averageSpacing, self.minSpacing), self.maxSpacing);
    CGFloat contentWidth = self.totalTabsWidth + ((self.tabItemViews.count + 1) * spacing);

    CGFloat originX = spacing;
    if (contentWidth < self.frame.size.width) {
        originX = (self.frame.size.width - contentWidth) / 2 + spacing;
    } else if (contentWidth < self.frame.size.width + spacing) {
        spacing = averageSpacing;
        originX = spacing;
        contentWidth = self.frame.size.width;
    }

    self.scrollEdge = UIEdgeInsetsMake(0, originX, 0, originX);
    self.scrollView.contentSize = CGSizeMake(contentWidth, 0);

    for (NSInteger i = 0; i < self.tabItemViews.count; i++) {
        NBLScrollTabItemView *tabItemView = self.tabItemViews[i];
        tabItemView.frame = CGRectMake(originX, 0, tabItemView.fitWidth, self.scrollView.frame.size.height);
        [tabItemView adjustBadgeView];
        [self.scrollView addSubview:tabItemView];

        originX += tabItemView.frame.size.width + spacing;
    }
}



- (void)clearTabItems
{
    for (UIView *itemView in self.tabItemViews) {
        [itemView removeFromSuperview];
    }

    self.tabItemViews = nil;
    self.indicatorView.hidden = YES;
}


- (NBLScrollTabItemView *)buildTabItemView:(NBLScrollTabItem *)tabItem
{
    NBLScrollTabItemView *itemView = [[NBLScrollTabItemView alloc] initWithTabItem:tabItem theme:self.theme];
    itemView.frame = CGRectMake(0, 0, 80, self.frame.size.height);
    itemView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [itemView addTarget:self action:@selector(itemSelAction:) forControlEvents:UIControlEventTouchUpInside];
    return itemView;
}

#pragma mark - Action

- (void)itemSelAction:(NBLScrollTabItemView *)sender
{
    NSInteger index = [self.tabItemViews indexOfObject:sender];
    [self setSelectedIndex:index animated:YES];
}

#pragma mark - Indicator
//移动indicatorview到某一页
- (void)shiftIndicatorToIndex:(NSUInteger)index animated:(BOOL)animated
{
    if (index >= self.tabItemViews.count) {
        return;
    }

    for (NSInteger i = 0; i < self.tabItemViews.count; i++) {
        NBLScrollTabItemView *tabItemView = self.tabItemViews[i];
        if (index == i) {
            [tabItemView setSelected:YES animated:animated];
        } else {
            [tabItemView setSelected:NO animated:animated];
        }
    }
    
    [self adjustScrollToCenterIndex:index animated:animated];

}

//调整ScrollView位置
- (void)adjustScrollToCenterIndex:(NSInteger)index animated:(BOOL)animted
{
    CGRect selItemFrame = [self.tabItemViews[index] frame];
    CGFloat selItemLeft = selItemFrame.origin.x - self.scrollView.contentOffset.x;
    CGFloat selItemRight = selItemLeft + selItemFrame.size.width;
    CGFloat selItemCenter = selItemLeft + selItemFrame.size.width/2;

    CGFloat scrollLeft = self.scrollView.contentOffset.x;
    CGFloat scollRight = scrollLeft + self.scrollView.frame.size.width;

    CGFloat maxLeft = self.scrollView.contentSize.width - self.frame.size.width;
    CGFloat centerSelItemOffsetX = (selItemFrame.origin.x + selItemFrame.size.width/2) - self.frame.size.width/2;

    //右边
    if ((selItemCenter > self.frame.size.width/2 || selItemRight > self.frame.size.width)
        && scollRight < self.scrollView.contentSize.width) {

        CGFloat left = MIN(centerSelItemOffsetX, maxLeft);
        [self.scrollView setContentOffset:CGPointMake(left, 0) animated:animted];

    } else if ((selItemLeft < 0 || selItemCenter < self.frame.size.width/2) && scrollLeft > 0) {
        CGFloat left = MAX(centerSelItemOffsetX, 0);
        [self.scrollView setContentOffset:CGPointMake(left, 0) animated:animted];
    }
}

@end
