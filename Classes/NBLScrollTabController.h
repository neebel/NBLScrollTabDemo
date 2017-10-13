//
//  NBLScrollTabController.h
//  NBLScrollTabDemo
//
//  Created by Neebel on 10/13/17.
//  Copyright © 2017 Neebel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NBLScrollTabView.h"

@protocol NBLScrollTabControllerDelegate;
@protocol NBLScrollTabSubController;

@interface NBLScrollTabController: UIViewController

@property (nonnull, nonatomic, strong) NBLScrollTabView                    *tabView;
@property (nonnull, nonatomic, strong) UIScrollView                         *scrollView;
@property (nullable, nonatomic, copy) NSArray<__kindof UIViewController<NBLScrollTabSubController> *>  *viewControllers;
@property (nullable, nonatomic, assign) __kindof UIViewController           *selectedViewController;
@property (nonatomic, assign) NSUInteger                                    selectedIndex;


@property (nullable, nonatomic, weak) id<NBLScrollTabControllerDelegate>   delegate;

- (void)updateTabTitle:(nonnull NSString *)title atIndex:(NSInteger)index;

@end





@protocol NBLScrollTabControllerDelegate <NSObject>

/**
 *  获取目前选中的viewController
 *
 */
- (void)tabController:(NBLScrollTabController * __nonnull)tabController
didSelectViewController:( UIViewController * __nonnull)viewController;



@end



@protocol NBLScrollTabSubController <NSObject>


@property(null_resettable, nonatomic, strong) NBLScrollTabItem *tabItem;


@end

@interface UIViewController (NBLScrollTabController) <NBLScrollTabSubController>

@property(null_resettable, nonatomic, strong) NBLScrollTabItem *tabItem; // Automatically created lazily with the view controller's title if it's not set explicitly.

@property(nullable, nonatomic, readonly, strong) NBLScrollTabController *tabController; // If the view controller has a tab controller as its ancestor, return it. Returns nil otherwise.

@end
