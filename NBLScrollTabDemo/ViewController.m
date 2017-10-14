//
//  ViewController.m
//  NBLScrollTabDemo
//
//  Created by neebel on 2017/10/13.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import "ViewController.h"
#import "NBLScrollTabController.h"
#import "DemoViewController0.h"
#import "DemoViewController1.h"
#import "DemoViewController2.h"
#import "DemoViewController3.h"

@interface ViewController ()<NBLScrollTabControllerDelegate>

@property (nonatomic, strong) NBLScrollTabController *scrollTabController;
@property (nonatomic, strong) NSArray *viewControllers;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = @"NBLScrollTabDemo";
    [self.view addSubview:self.scrollTabController.view];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.scrollTabController updateTabTitle:@"test" atIndex:2];//可以动态更新标题
    });
}


- (NBLScrollTabController *)scrollTabController
{
    if (!_scrollTabController) {
//        NBLScrollTabTheme *theme = [[NBLScrollTabTheme alloc] init];
//        theme.titleViewHeight = 80;
//        theme.badgeViewColor = [UIColor greenColor];
//        theme.titleViewBGColor = [UIColor blackColor];
//        theme.indicatorViewColor = [UIColor greenColor];
//        theme.titleFont = [UIFont systemFontOfSize:20];
//        theme.titleColor = [UIColor yellowColor];
//        theme.highlightColor = [UIColor greenColor];
//        _scrollTabController = [[NBLScrollTabController alloc] initWithTabTheme:theme];
        _scrollTabController = [[NBLScrollTabController alloc] init];
        _scrollTabController.view.frame = self.view.bounds;
        _scrollTabController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _scrollTabController.delegate = self;
        _scrollTabController.viewControllers = self.viewControllers;
    }
    
    return _scrollTabController;
}


- (NSArray *)viewControllers
{
    if (!_viewControllers) {
        DemoViewController0 *demo0 = [[DemoViewController0 alloc] init];
        NBLScrollTabItem *demo0Item = [[NBLScrollTabItem alloc] init];
        demo0Item.title = @"新闻";
        demo0Item.hideBadge = NO;//每个title可以做个性化配置
        demo0.tabItem = demo0Item;
        
        DemoViewController1 *demo1 = [[DemoViewController1 alloc] init];
        NBLScrollTabItem *demo1Item = [[NBLScrollTabItem alloc] init];
        demo1Item.title = @"体育";
        demo1Item.hideBadge = YES;
        demo1.tabItem = demo1Item;
        
        DemoViewController2 *demo2 = [[DemoViewController2 alloc] init];
        NBLScrollTabItem *demo2Item = [[NBLScrollTabItem alloc] init];
        demo2Item.title = @"娱乐";
        demo2Item.hideBadge = YES;
        demo2Item.textColor = [UIColor blackColor]; //每个title可以做个性化配置
        demo2Item.highlightColor = [UIColor yellowColor];//每个title可以做个性化配置
        demo2.tabItem = demo2Item;
        
        DemoViewController3 *demo3 = [[DemoViewController3 alloc] init];
        NBLScrollTabItem *demo3Item = [[NBLScrollTabItem alloc] init];
        demo3Item.title = @"八卦";
        demo3Item.hideBadge = YES;
        demo3Item.font = [UIFont systemFontOfSize:10];//每个title可以做个性化配置
        demo3.tabItem = demo3Item;
        
        DemoViewController1 *demo4 = [[DemoViewController1 alloc] init];
        NBLScrollTabItem *demo4Item = [[NBLScrollTabItem alloc] init];
        demo4Item.title = @"测试长度哈哈";
        demo4Item.hideBadge = YES;
        demo4.tabItem = demo4Item;
        
        DemoViewController2 *demo5 = [[DemoViewController2 alloc] init];
        NBLScrollTabItem *demo5Item = [[NBLScrollTabItem alloc] init];
        demo5Item.title = @"测试长度哈哈234fsdf";
        demo5Item.hideBadge = YES;
        demo5.tabItem = demo5Item;
        _viewControllers = @[demo0, demo1, demo2, demo3, demo4, demo5];

    }
    
    return _viewControllers;
}

#pragma mark - NBLScrollTabControllerDelegate

- (void)tabController:(NBLScrollTabController * __nonnull)tabController
didSelectViewController:( UIViewController * __nonnull)viewController
{
    //业务逻辑处理
}

@end
