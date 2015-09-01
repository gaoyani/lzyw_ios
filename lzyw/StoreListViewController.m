//
//  StoreListViewController.m
//  lzyw
//
//  Created by 高亚妮 on 15/3/27.
//  Copyright (c) 2015年 gaoyani. All rights reserved.
//

#import "StoreListViewController.h"

@interface StoreListViewController () {
    StoreTableViewController* recommendViewController;
    StoreTableViewController* aroundViewController;
    StoreTableViewController* collectViewController;
}

@end

@implementation StoreListViewController

- (void)viewDidLoad {
    storeListInfo = [[StoreListInfo alloc] init];
    searchInfo = [[SearchInfo alloc] init];
    searchInfo.classifyID = self.categoryID;
    
    self.dataSource = self;
    self.delegate = self;
    
    self.navigationItem.rightBarButtonItem = [self customRightButton];
    
    CGRect rx = [UIScreen mainScreen].bounds;
    
    self.searchView = [SearchFactorView initView];
    [self.view addSubview:self.searchView];
    self.searchView.frame = CGRectMake(rx.size.width, 0, rx.size.width, rx.size.height);
    self.searchView.searchInfo = searchInfo;

    self.rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    self.rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:self.rightSwipeGestureRecognizer];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(startSearch)
     name:@"startSearch"//表示消息名称，发送跟接收双方都要一致
     object:nil];
    
    [super viewDidLoad];
}

-(void)startSearch {
    [self searchViewDisappear];
    [recommendViewController loadData];
    [aroundViewController loadData];
    [collectViewController loadData];
}

- (void)handleSwipes:(UISwipeGestureRecognizer *)sender{
    if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
        [self searchViewDisappear];
    }
}

-(void)searchViewDisappear {
    CGRect rx = [UIScreen mainScreen].bounds;
    CGRect frame = self.searchView.frame;
    frame.origin.x = 0;
    self.searchView.frame = frame;
    
    [UIView beginAnimations:@"animation" context:NULL];
    [UIView setAnimationDuration:0.5f];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationRepeatAutoreverses:NO];
    [UIView setAnimationRepeatCount:1];
    
    frame = self.searchView.frame;
    frame.origin.x = rx.size.width;
    self.searchView.frame = frame;
    [UIView commitAnimations];
}


-(UIBarButtonItem*)customRightButton{
    UIImage *btnUP=[UIImage imageNamed:@"button_filter_up.png"];
    UIImage *btnDown=[UIImage imageNamed:@"button_filter_down.png"];
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    
    int width = btnUP.size.width*self.navigationController.navigationBar.frame.size.height/btnUP.size.height;
    btn.frame=CGRectMake(0, 0, width, self.navigationController.navigationBar.frame.size.height);
    [btn setBackgroundImage:btnUP forState:UIControlStateNormal];
    [btn setBackgroundImage:btnDown forState:UIControlStateHighlighted];
    
    [btn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    return backItem;
}

-(void)rightBtnClick{
    
    CGRect rx = [UIScreen mainScreen].bounds;
    CGRect frame = self.searchView.frame;
    frame.origin.x = rx.size.width;
    self.searchView.frame = frame;
    
    [UIView beginAnimations:@"animation" context:NULL];
    [UIView setAnimationDuration:0.5f];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationRepeatAutoreverses:NO];
    [UIView setAnimationRepeatCount:1];
    
    frame = self.searchView.frame;
    frame.origin.x = 0;
    self.searchView.frame = frame;
    [UIView commitAnimations];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ViewPagerDataSource
- (NSUInteger)numberOfTabsForViewPager:(ViewPagerController *)viewPager {
    return 3;
}
- (UIView *)viewPager:(ViewPagerController *)viewPager viewForTabAtIndex:(NSUInteger)index {
    
    UILabel *label = [UILabel new];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:13.0];
    switch (index) {
        case 0:
            label.text = @"推荐";
            break;
            
        case 1:
            label.text = @"周边";
            break;
            
        case 2:
            label.text = @"收藏";
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
        recommendViewController = [[StoreTableViewController alloc] initWithNibName:@"StoreTableViewController" bundle:nil];
        recommendViewController.parentNavigationController = self.navigationController;
        recommendViewController.searchInfo = searchInfo;
        recommendViewController.storeListInfo = storeListInfo;
        recommendViewController.storeListType = StoreListTypeRecommend;
        return recommendViewController;
    } else if (index == 1) {
        aroundViewController = [[StoreTableViewController alloc] initWithNibName:@"StoreTableViewController" bundle:nil];
        aroundViewController.parentNavigationController = self.navigationController;
        aroundViewController.searchInfo = searchInfo;
        aroundViewController.storeListInfo = storeListInfo;
        aroundViewController.storeListType = StoreListTypeAround;
        return aroundViewController;
    } else {
        collectViewController = [[StoreTableViewController alloc] initWithNibName:@"StoreTableViewController" bundle:nil];
        collectViewController.parentNavigationController = self.navigationController;
        collectViewController.searchInfo = searchInfo;
        collectViewController.storeListInfo = storeListInfo;
        collectViewController.storeListType = StoreListTypeFavorite;
        return collectViewController;
    }
}

#pragma mark - ViewPagerDelegate
- (CGFloat)viewPager:(ViewPagerController *)viewPager valueForOption:(ViewPagerOption)option withDefault:(CGFloat)value {
    
    switch (option) {
        case ViewPagerOptionTabWidth: {
            CGRect rx = [UIScreen mainScreen].bounds;
            return rx.size.width/3;
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
