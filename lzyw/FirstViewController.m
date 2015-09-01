//
//  FirstViewController.m
//  lzyw
//
//  Created by 高亚妮 on 15/3/12.
//  Copyright (c) 2015年 gaoyani. All rights reserved.
//

#import "FirstViewController.h"
#import "StoreTableViewCell.h"
#import "RecommendView.h"
#import "NewsInfo.h"
#import "StoreDetailViewController.h"
#import "StoreListViewController.h"
#import "AppDelegate.h"
#import "PayPasswordView.h"
#import "SetPayPasswordViewController.h"
#import "Constants.h"
#import "Utils.h"

static int CELL_HEIGHT = 80;


@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    self.navigationItem.title = NSLocalizedStringFromTable(@"main_title", @"lzyw", nil);
    
//    UIBarButtonItem *customLeftBarButtonItem = [[UIBarButtonItem alloc] init];
//    customLeftBarButtonItem.title = @"返回";
//    self.navigationItem.backBarButtonItem = customLeftBarButtonItem;
    self.navigationItem.rightBarButtonItem = [self mainMenuButton];
    
    self.commonData = [[CommonData alloc] initData];
    self.recommendInfo = [[RecommendInfo alloc] init];
    
    //设置定位精确度，默认：kCLLocationAccuracyBest
    [BMKLocationService setLocationDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    //指定最小距离更新(米)，默认：kCLDistanceFilterNone
    [BMKLocationService setLocationDistanceFilter:100.f];
    //初始化BMKLocationService
    self.locService = [[BMKLocationService alloc]init];
    self.locService.delegate = self;
    //启动LocationService
    [self.locService startUserLocationService];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(updateView:)
     name:@"updateView"
     object:nil];
    [self.recommendInfo getData];
    
    CGRect rx = [UIScreen mainScreen].bounds;
    
    self.loadingView = [LoadingView initView];
    [self.loadingView setFrame:CGRectMake(0, 0, rx.size.width, rx.size.height)];
    [self.loadingView showView];
    [self.view addSubview:self.loadingView];
    
    self.categoriesView.delegate = self;
    self.categoriesView.dataSource = self;
    [self.categoriesView registerNib:[UINib nibWithNibName:@"CategoryCell" bundle:nil] forCellWithReuseIdentifier:@"CategoryCell"];
    int cellWidth = (rx.size.width-70)/4;
    int cellHeight = cellWidth*4/3;
    [self.categoriesView setFrame:CGRectMake(0.0, 0.0, rx.size.width, cellHeight*2+30)];
    
    [self.recommendMsgContainer setFrame:CGRectMake(0.0, self.categoriesView.frame.size.height, rx.size.width, 30)];
    [self.recommendMsg setFrame:CGRectMake(70, 0.0, rx.size.width, 30)];
    [self marqueeMsg];
    UITapGestureRecognizer *msgClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(newsMsgClick)];
    [self.recommendMsgContainer addGestureRecognizer:msgClick];
    
    [self.recommendContainer setFrame:CGRectMake(0.0, self.categoriesView.frame.size.height+self.recommendMsgContainer.frame.size.height, rx.size.width, rx.size.width*2/3)];
    [self addRecommendView];
    
    [self.featuredHeadContainer setFrame:CGRectMake(0.0, self.categoriesView.frame.size.height+self.recommendMsgContainer.frame.size.height+self.recommendContainer.frame.size.height, rx.size.width, 30)];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"StoreCell" bundle:nil] forCellReuseIdentifier:@"storeCell"];
    [self.tableView setFrame:CGRectMake(-8, self.categoriesView.frame.size.height+self.recommendMsgContainer.frame.size.height+self.recommendContainer.frame.size.height+self.featuredHeadContainer.frame.size.height, rx.size.width, CELL_HEIGHT*10)];

    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    CGRect rectNav = self.navigationController.navigationBar.frame;
    CGRect rectTabBar = self.tabBarController.tabBar.frame;
    int scrollViewHeight = rx.size.height-rectStatus.size.height-rectNav.size.height;
    if ([Utils getDeviceVersion] < 7.0) {
        scrollViewHeight = scrollViewHeight - rectTabBar.size.height;
    }
    [self.contentScrollView setFrame:CGRectMake(0.0, 0.0, rx.size.width, scrollViewHeight)];
    [self.contentScrollView setContentSize:CGSizeMake(rx.size.width, self.categoriesView.frame.size.height+self.recommendMsgContainer.frame.size.height+self.recommendContainer.frame.size.height+self.featuredHeadContainer.frame.size.height+self.tableView.frame.size.height)];
    
    self.newsListView = [ItemListView initView];
    [self.newsListView setFrame:CGRectMake(0.0, 0.0, rx.size.width, rx.size.height)];
    self.newsListView.parentViewController = self;
    self.newsListView.hidden = YES;
    [self.view addSubview:self.newsListView];
    
    //add main menu view
    self.mainMenuView = [MainMenuView initView];
    self.mainMenuView.viewController = self;
    self.mainMenuView.hidden = YES;
    [self.mainMenuView setFrame:CGRectMake(0.0, 0.0, rx.size.width, rx.size.height)];
    [self.view addSubview:self.mainMenuView];
    
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

-(void)addRecommendView
{
    CGRect rx = [UIScreen mainScreen].bounds;
    int height = self.recommendContainer.frame.size.height;
    RecommendView* leftView = [RecommendView initRecommendView];
    [leftView setFrame:CGRectMake(2, 2, rx.size.width/2-2, height-2)];
    [leftView setTag:1];
    [self.recommendContainer addSubview:leftView];
    
    RecommendView* rightTView = [RecommendView initRecommendView];
    [rightTView setFrame:CGRectMake(rx.size.width/2+2, 2, rx.size.width/2-2, height/2-2)];
    [rightTView setTag:2];
    [self.recommendContainer addSubview:rightTView];
    
    RecommendView* rightBView = [RecommendView initRecommendView];
    [rightBView setFrame:CGRectMake(rx.size.width/2+2, height/2+2, rx.size.width/2-2, height/2-2)];
    [rightBView setTag:3];
    [self.recommendContainer addSubview:rightBView];
}

-(void)updateView:(NSNotification*)notification {
    NSMutableDictionary* resultDic = (NSMutableDictionary*)notification.userInfo;
    BOOL isSucceed = [[resultDic objectForKey:succeed] boolValue];
    if (isSucceed) {
        [self.tableView reloadData];
        [(RecommendView*)[self.recommendContainer viewWithTag:1] setContent:self.recommendInfo.leftItemInfo];
        [(RecommendView*)[self.recommendContainer viewWithTag:2] setContent:self.recommendInfo.rightTopItemInfo];
        [(RecommendView*)[self.recommendContainer viewWithTag:3] setContent:self.recommendInfo.rightBottomItemInfo];
        NSString* newsTitles = [[NSString alloc] init];
        for (int i=0; i<self.recommendInfo.newsArray.count; i++) {
            NewsInfo* info = [self.recommendInfo.newsArray objectAtIndex:i];
            newsTitles = [newsTitles stringByAppendingString:[NSString stringWithFormat:@"  %d.",i+1]];
            newsTitles = [newsTitles stringByAppendingString:info.title];
        }
        self.recommendMsg.text = newsTitles;
    } else {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"" message:[resultDic objectForKey:errorMessage] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
    
    self.loadingView.hidden = YES;
}

-(void)marqueeMsg {
    CGRect rx = [UIScreen mainScreen].bounds;
    CGRect frame = self.recommendMsg.frame;
    frame.origin.x = rx.size.width;
    self.recommendMsg.frame = frame;
    
    [UIView beginAnimations:@"testAnimation" context:NULL];
    [UIView setAnimationDuration:8.8f];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationRepeatAutoreverses:NO];
    [UIView setAnimationRepeatCount:999999];
    
    frame = self.recommendMsg.frame;
    frame.origin.x = -rx.size.width;
    self.recommendMsg.frame = frame;
    [UIView commitAnimations];
}

-(void)newsMsgClick {
    [self.newsListView viewShow];
    [self.newsListView setNewsArray:self.recommendInfo.newsArray];
}

#pragma mark -location service delegate
//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    NSLog(@"heading is %@",userLocation.heading);
}
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    appDelegate.memberInfo.latitude = userLocation.location.coordinate.latitude;
    appDelegate.memberInfo.longitude = userLocation.location.coordinate.longitude;
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    [self.recommendInfo getData];
    [self.locService stopUserLocationService];
}

- (void)didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"location error");
}

#pragma mark -CollectionView datasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 8;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //重用cell
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CategoryCell" forIndexPath:indexPath];
    //赋值
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:1];
    UILabel *label = (UILabel *)[cell viewWithTag:2];
   
    NSString* imageName = [self.commonData.categoryImgNames objectAtIndex:(int)indexPath.row];
    imageView.image = [UIImage imageNamed:[imageName stringByAppendingString:@"up"]];
    imageView.highlightedImage = [UIImage imageNamed:[imageName stringByAppendingString:@"down"]];
    
    label.text = [self.commonData.categoryTitles objectAtIndex:(int)indexPath.row];
    
    return cell;
}

//定义每个UICollectionViewCell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect rx = [UIScreen mainScreen].bounds;
    int width = (rx.size.width-70)/4;
    
    return CGSizeMake(width, width*4/3);
}

//每个item之间的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}
//选择了某个cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
   [self performSegueWithIdentifier:@"ShowCategoryList" sender:self];
}

#pragma mark -tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.recommendInfo.recommendStoreArray.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CELL_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    StoreTableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:@"storeCell" forIndexPath:indexPath];
    [cell setContent:[self.recommendInfo.recommendStoreArray objectAtIndex:indexPath.row]];
//    [cell layoutIfNeeded];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"ShowSelectedProvince" sender:self];
    [tableView deselectRowAtIndexPath:indexPath animated:NO]; 
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowSelectedProvince"]) {
        StoreDetailViewController* viewController = segue.destinationViewController;
        NSInteger selectedIndex = [[self.tableView indexPathForSelectedRow] row];
        StoreInfo* storeInfo = (StoreInfo*)[self.recommendInfo.recommendStoreArray objectAtIndex:selectedIndex];
        viewController.storeID = storeInfo.storeID;
        viewController.title = storeInfo.name;
    } else if ([segue.identifier isEqualToString:@"ShowCategoryList"]) {
        StoreListViewController* viewController = segue.destinationViewController;
        NSIndexPath *selectedIndexPath = [[self.categoriesView indexPathsForSelectedItems] objectAtIndex:0];
        viewController.categoryID = (int)selectedIndexPath.row;
        viewController.title = [self.commonData.categoryTitles objectAtIndex:selectedIndexPath.row];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [self marqueeMsg];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
