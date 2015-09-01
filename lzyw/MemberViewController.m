//
//  MemberViewController.m
//  lzyw
//
//  Created by 高亚妮 on 15/4/24.
//  Copyright (c) 2015年 gaoyani. All rights reserved.
//

#import "MemberViewController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"

@interface MemberViewController () {
    BOOL isFromLoginView;
}
@end

@implementation MemberViewController

- (void)viewDidLoad {
    self.dataSource = self;
    self.delegate = self;
    
    self.navigationItem.title = @"乐会员";
    self.navigationItem.rightBarButtonItem = [self mainMenuButton];
    isFromLoginView = NO;
    
    //add main menu view
    CGRect rx = [UIScreen mainScreen].bounds;
    self.mainMenuView = [MainMenuView initView];
    self.mainMenuView.viewController = self;
    self.mainMenuView.hidden = YES;
    [self.mainMenuView setFrame:CGRectMake(0.0, 0.0, rx.size.width, rx.size.height)];
    [self.view addSubview:self.mainMenuView];
    
    [super viewDidLoad];
    UISwipeGestureRecognizer *rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:rightSwipeGestureRecognizer];
}

-(UIBarButtonItem*)mainMenuButton{
    UIImage *btnUP=[UIImage imageNamed:@"button_menu"];
    UIImage *btnDown=[UIImage imageNamed:@"button_menu_down"];
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.frame=CGRectMake(0, 0, 45, 45);
    [btn setBackgroundImage:btnUP forState:UIControlStateNormal];
    [btn setBackgroundImage:btnDown forState:UIControlStateHighlighted];
    
    [btn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    return backItem;
}

-(void)rightBtnClick {
    [self.mainMenuView viewShow];
}

- (void)handleSwipes:(UISwipeGestureRecognizer *)sender{
    if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
        [self.mainMenuView viewDisappear];
    }
}

-(void)toLoginView {
    LoginViewController* viewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
}

-(void)viewWillAppear:(BOOL)animated {
    AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    if (!appDelegate.memberInfo.isLogin) {
        if (isFromLoginView) {
            [self.tabBarController setSelectedIndex:0];
        } else {
            [self toLoginView];
        }
        
        isFromLoginView = !isFromLoginView;
    } else {
//        [[NSNotificationCenter defaultCenter]
//         addObserver:self
//         selector:@selector(updateStoreList)
//         name:@"updateStoreList"//表示消息名称，发送跟接收双方都要一致
//         object:nil];
        [memberInfoViewController setInfo];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ViewPagerDataSource
- (NSUInteger)numberOfTabsForViewPager:(ViewPagerController *)viewPager {
    return 4;
}
- (UIView *)viewPager:(ViewPagerController *)viewPager viewForTabAtIndex:(NSUInteger)index {
    
    UILabel *label = [UILabel new];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:13.0];
    switch (index) {
        case 0:
            label.text = @"会员信息";
            break;
            
        case 1:
            label.text = @"我的订单";
            break;
            
        case 2:
            label.text = @"我的评论";
            break;
            
        case 3:
            label.text = @"积分明细";
            break;
            
        default:
            break;
    }
    
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    [label sizeToFit];
    
    return label;
}

- (UIViewController *)viewPager:(ViewPagerController *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index {
    if (index == 0) {
        memberInfoViewController = [[MemberInfoViewController alloc] initWithNibName:@"MemberInfoViewController" bundle:nil];
        memberInfoViewController.parentNavigationViewController = self.navigationController;
        return memberInfoViewController;
    } else if (index == 1) {
        orderListViewController = [[ListViewController alloc] initWithNibName:@"ListViewController" bundle:nil];
        orderListViewController.listViewType = ListViewOrder;
        orderListViewController.parentNavigationController = self.navigationController;
        return orderListViewController;
    } else if (index == 2) {
        commentListViewController = [[ListViewController alloc] initWithNibName:@"ListViewController" bundle:nil];
        commentListViewController.listViewType = ListViewComment;
        return commentListViewController;
    } else {
        pointListViewController = [[ListViewController alloc] initWithNibName:@"ListViewController" bundle:nil];
        pointListViewController.listViewType = ListViewPoint;
        return pointListViewController;
    }
}

#pragma mark - ViewPagerDelegate
- (CGFloat)viewPager:(ViewPagerController *)viewPager valueForOption:(ViewPagerOption)option withDefault:(CGFloat)value {
    
    switch (option) {
        case ViewPagerOptionTabWidth: {
            CGRect rx = [UIScreen mainScreen].bounds;
            return rx.size.width/4;
        }
            break;
        default:
            break;
    }
    
    return value;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
