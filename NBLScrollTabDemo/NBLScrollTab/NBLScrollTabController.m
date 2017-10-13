//
//  NBLScrollTabController.m
//  NBLScrollTabDemo
//
//  Created by Neebel on 10/13/17.
//  Copyright © 2017 Neebel. All rights reserved.
//

#import "NBLScrollTabController.h"
#import <objc/runtime.h>

@interface NBLScrollTabController () <UIScrollViewDelegate, NBLScrollTabViewDelegate>

@end

@implementation NBLScrollTabController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self buildTabView];

    CGFloat tabHeight = 40;
    CGRect scrollFrame = CGRectMake(0, tabHeight, self.view.frame.size.width, self.view.frame.size.height - tabHeight);
    self.scrollView = [[UIScrollView alloc] initWithFrame:scrollFrame];
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.alwaysBounceVertical = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];

    [self addAllViewControllers];
    [self loadScrollContentAtIndex:0];

}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.scrollView.scrollEnabled = NO;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.scrollView.scrollEnabled = YES;
}


#pragma mark - Setter
- (void)setViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers
{
    if ([_viewControllers isEqualToArray:viewControllers]) {
        return;
    }

    _viewControllers = [viewControllers copy];
    [self addAllViewControllers];
    [self loadScrollContentAtIndex:0];//初始化时只加载第一页

}




#pragma mark - Private

- (void)buildTabView
{
    CGRect tabFrame = CGRectMake(0, 0, self.view.frame.size.width, 40.0);
    self.tabView = [[NBLScrollTabView alloc] initWithFrame:tabFrame];
    self.tabView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    [self.view addSubview:self.tabView];
    self.tabView.delegate = self;
}


//添加所有子viewcontrollers
- (void)addAllViewControllers
{
    if (!self.isViewLoaded || self.viewControllers.count == 0) {
        return;
    }
    
    
    NSInteger left = MAX(self.selectedIndex, 0);
    NSInteger count = self.viewControllers.count;
    NSInteger right = count - 1;//MIN(self.selectedIndex + 1, self.viewControllers.count - 1);
    
    NSMutableArray *tabItemList = [NSMutableArray array];
    for (NSInteger i = left; i <= right; i++) {
        UIViewController *subVC = self.viewControllers[i];
        
        [tabItemList addObject:subVC.tabItem];
        
        if (self != subVC.parentViewController) {
            [self addChildViewController:subVC];
        }
    }
    
    self.scrollView.contentSize = CGSizeMake(count * self.scrollView.frame.size.width, 1);
    self.tabView.tabItems = tabItemList;

}

//加载某个位置的controller的视图
- (void)loadScrollContentAtIndex:(NSInteger)index
{
    if (index < 0 || index >= self.viewControllers.count) {
        return;
    }
    
    UIViewController *last = self.viewControllers[self.selectedIndex];
    last.tabItem.isSelected = NO;
    UIViewController *subVC = self.viewControllers[index];
    subVC.tabItem.isSelected = YES;
    
    if (nil != subVC && self.scrollView != subVC.view.superview) {
        subVC.view.frame = CGRectMake(index * self.scrollView.frame.size.width, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
        subVC.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.scrollView addSubview:subVC.view];
    }
}


#pragma mark - Public
- (void)updateTabTitle:(nonnull NSString *)title atIndex:(NSInteger)index
{
    if (index < 0 || index >= self.tabView.tabItems.count) {
        NSAssert(NO, @"下标越界");
    }
    
    NBLScrollTabItem *item = self.tabView.tabItems[index];
    item.title = title;
    [self.tabView updateTabItems:self.tabView.tabItems];
}

#pragma mark - UIScrollDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{

    NSInteger page = floor((scrollView.contentOffset.x + scrollView.frame.size.width / 2) / scrollView.frame.size.width);

    if (page != self.selectedIndex) {
        NSInteger currentIndex = floor(scrollView.contentOffset.x / scrollView.frame.size.width);
        
        [self loadScrollContentAtIndex:currentIndex];
        self.selectedIndex = currentIndex;
    }

    CGFloat pageOffset = scrollView.contentOffset.x/scrollView.frame.size.width;
    [self.tabView updateWithTabPageOffset:pageOffset];
}



- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger page = floor((scrollView.contentOffset.x - scrollView.frame.size.width / 2) / scrollView.frame.size.width) + 1;
    [self.tabView setSelectedIndex:page animated:NO];
}



#pragma mark - NBLScrollTabViewDelegate

- (void)tabView:(NBLScrollTabView *)tabView didSelectIndex:(NSUInteger)index
{
    CGFloat pageOffset = index * self.scrollView.frame.size.width;
    [self.scrollView setContentOffset:CGPointMake(pageOffset, 0) animated:YES];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(tabController:didSelectViewController:)]) {
        [self.delegate tabController:self didSelectViewController:self.viewControllers[index]];
    }
}


@end



static char kNBLScrollTabItemKey;

@implementation UIViewController (NBLScrollTabController)


- (NBLScrollTabItem *)tabItem
{
    NBLScrollTabItem * item = objc_getAssociatedObject(self, &kNBLScrollTabItemKey);
    if (nil == item) {
        item = [[NBLScrollTabItem alloc] init];
        item.title = self.title;
    }

    return item;
}


- (void)setTabItem:(NBLScrollTabItem *)tabItem
{
    if (nil == tabItem) {
        objc_removeAssociatedObjects(tabItem);
    }
    objc_setAssociatedObject(self, &kNBLScrollTabItemKey, tabItem, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}



- (NBLScrollTabController *)tabController
{
    if ([self.parentViewController isKindOfClass:[NBLScrollTabController class]]) {
        return (NBLScrollTabController *)(self.parentViewController);
    }

    return nil;
}


@end



