//
//  StoreDetialViewController.m
//  lzyw
//
//  Created by 高亚妮 on 15/3/23.
//  Copyright (c) 2015年 gaoyani. All rights reserved.
//

#import "StoreDetailViewController.h"
#import "RoomTableViewCell.h"
#import "RoomDetialViewController.h"
#import "AppDelegate.h"
#import "Constants.h"

@interface StoreDetailViewController ()



@end

@implementation StoreDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    cellHeight = 60;
    CGRect rx = [UIScreen mainScreen].bounds;
    
    self.storeInfo = ((AppDelegate*)[UIApplication sharedApplication].delegate).storeDetailInfo;
    
    serviceType = ServiceTypeRoom;
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(updateInfo:)
     name:@"updateInfo"//表示消息名称，发送跟接收双方都要一致
     object:nil];
    [self.storeInfo getNetData:self.storeID startIndex:0 serviceType:ServiceTypeRoom];
    
//    self.navigationItem.leftBarButtonItem =[self customLeftBackButton];
    
    self.loadingView = [LoadingView initView];
    [self.loadingView setFrame:CGRectMake(0, 0, rx.size.width, rx.size.height)];
    [self.loadingView showView];
    [self.view addSubview:self.loadingView];
    
    [self.pictureView initView];
    [self.pictureView setFrame:CGRectMake(0, 0, rx.size.width, rx.size.width*2/3)];
    
    [self.infoViewContainer setFrame:CGRectMake(0, self.pictureView.frame.size.height, rx.size.width, 100)];
    self.infoView = [StoreDetailInfoView initView];
    [self.infoView setFrame:CGRectMake(0, 0, rx.size.width, self.infoViewContainer.frame.size.height)];
    [self.infoViewContainer addSubview:self.infoView];
    
    [self.collectContainer setFrame:CGRectMake(rx.size.width-80, self.pictureView.frame.size.height-15, 80, 30)];
    [self.collectNum setFrame:CGRectMake(15, 8, 65, 14)];
    [self.collectBtn setFrame:CGRectMake(0, 0, 40, 40)];
    
    [self.serviceTypeContainer setFrame:CGRectMake(0, self.pictureView.frame.size.height+self.infoViewContainer.frame.size.height, rx.size.width, 30)];
    [self.roomBtn setFrame:CGRectMake(0, 0, rx.size.width/3, 35)];
    [self.serviceBtn setFrame:CGRectMake(rx.size.width/3, 0, rx.size.width/3, 35)];
    [self.artificerBtn setFrame:CGRectMake(rx.size.width/3*2, 0, rx.size.width/3, 35)];
    
    //config the load more view
    if (self.loadMoreTableFooterView == nil) {
        
        self.loadMoreTableFooterView = [[LoadMoreTableFooterView alloc] init];
        self.loadMoreTableFooterView.delegate = self;
    }
    self.tableView.tableFooterView = self.loadMoreTableFooterView;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"RoomCell" bundle:nil] forCellReuseIdentifier:@"roomCell"];
    [self.tableView setFrame:CGRectMake(-8, self.pictureView.frame.size.height+self.infoViewContainer.frame.size.height+self.serviceTypeContainer.frame.size.height, rx.size.width, 0)];
    
    //ios8 解决分割线没有左对齐问题
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    CGRect rectNav = self.navigationController.navigationBar.frame;
    self.scrollView.frame = CGRectMake(0, 0, rx.size.width, rx.size.height-rectStatus.size.height-rectNav.size.height);
}

-(UIBarButtonItem*)customLeftBackButton{
    
    UIImage *backUP=[UIImage imageNamed:@"button_back_up"];
    UIImage *backDown=[UIImage imageNamed:@"button_back_down"];
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    
//    
//    int width = backUP.size.width*self.navigationController.navigationBar.frame.size.height/backUP.size.height;
    btn.frame=CGRectMake(0, 0, backUP.size.width, backUP.size.height);
    [btn setBackgroundImage:backUP forState:UIControlStateNormal];
    [btn setBackgroundImage:backDown forState:UIControlStateHighlighted];
    
    [btn addTarget:self action:@selector(popself) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    return backItem;
}

-(void)popself{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)updateInfo:(NSNotification *)notification {
    BOOL isSuccess = [[[notification userInfo] valueForKey:succeed] boolValue];
    if (isSuccess == YES) {
        self.title = self.storeInfo.name;
        [self.pictureView setPictures:self.storeInfo.picture360Url picUrlArray:self.storeInfo.picUrlArray];
        [self.infoView setInfo:self.storeInfo];
        self.collectNum.text = [NSString stringWithFormat:@"%d",self.storeInfo.favoriteNum];
        [self.collectBtn setBackgroundImage:[UIImage imageNamed:(self.storeInfo.favorite ? @"heart_act" : @"heart")] forState:UIControlStateNormal];
        CGRect rx = [UIScreen mainScreen].bounds;
        [self.tableView setFrame:CGRectMake(-8, self.pictureView.frame.size.height+self.infoViewContainer.frame.size.height+self.serviceTypeContainer.frame.size.height, rx.size.width, cellHeight*self.storeInfo.roomArray.count+self.loadMoreTableFooterView.frame.size.height)];
        self.scrollView.contentSize = CGSizeMake(rx.size.width, self.pictureView.frame.size.height+self.infoViewContainer.frame.size.height+self.serviceTypeContainer.frame.size.height+self.tableView.frame.size.height);
        [self.tableView reloadData];
        
    } else {
        NSString* errorMsg = [[notification userInfo] valueForKey:errorMessage];
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"" message:errorMsg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alter show];
    }
    
    self.loadingView.hidden = YES;
}

- (IBAction)onClickCollectBtn:(id)sender {
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(collectResult:)
     name:@"collectResult"//表示消息名称，发送跟接收双方都要一致
     object:nil];
    
    [self.storeInfo collect:!self.storeInfo.favorite];
}

-(void)collectResult:(NSNotification*)notification {
    NSMutableDictionary* resultDic = (NSMutableDictionary*)notification.userInfo;
    BOOL isSucceed = [[resultDic objectForKey:succeed] boolValue];
    if (isSucceed) {
        self.storeInfo.favorite = !self.storeInfo.favorite;
        [self.collectBtn setBackgroundImage:[UIImage imageNamed:(self.storeInfo.favorite ? @"heart_act" : @"heart")] forState:UIControlStateNormal];
        if (self.storeInfo.favorite) {
            self.storeInfo.favoriteNum++;
        } else {
            self.storeInfo.favoriteNum--;
        }
        self.collectNum.text = [NSString stringWithFormat:@"%d",self.storeInfo.favoriteNum];
    } else {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"" message:[resultDic objectForKey:errorMessage] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"collectResult" object:nil];
}

- (IBAction)onClickRoomBtn:(id)sender {
    serviceType = ServiceTypeRoom;
    [self.roomBtn setBackgroundImage:[UIImage imageNamed:@"top_tab_down"] forState:UIControlStateNormal];
    [self.serviceBtn setBackgroundImage:[UIImage imageNamed:@"top_tab_up"] forState:UIControlStateNormal];
    [self.artificerBtn setBackgroundImage:[UIImage imageNamed:@"top_tab_up"] forState:UIControlStateNormal];
}

- (IBAction)onClickServiceBtn:(id)sender {
    serviceType = ServiceTypeService;
    [self.roomBtn setBackgroundImage:[UIImage imageNamed:@"top_tab_up"] forState:UIControlStateNormal];
    [self.serviceBtn setBackgroundImage:[UIImage imageNamed:@"top_tab_down"] forState:UIControlStateNormal];
    [self.artificerBtn setBackgroundImage:[UIImage imageNamed:@"top_tab_up"] forState:UIControlStateNormal];
}

- (IBAction)onClickArtificerBtn:(id)sender {
    serviceType = ServiceTypeArtificer;
    [self.roomBtn setBackgroundImage:[UIImage imageNamed:@"top_tab_up"] forState:UIControlStateNormal];
    [self.serviceBtn setBackgroundImage:[UIImage imageNamed:@"top_tab_up"] forState:UIControlStateNormal];
    [self.artificerBtn setBackgroundImage:[UIImage imageNamed:@"top_tab_down"] forState:UIControlStateNormal];
}

#pragma mark -tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (serviceType == ServiceTypeRoom) {
        return self.storeInfo.roomArray.count;
    } else if (serviceType == ServiceTypeService) {
//        return self.storeInfo.serviceArray.count;
    }
    
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RoomTableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:@"roomCell" forIndexPath:indexPath];
    cell.parentViewController = self;
    //ios8 解决分割线没有左对齐问题
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }

    if (serviceType == ServiceTypeRoom) {
        [cell setContent:[self.storeInfo.roomArray objectAtIndex:indexPath.row] serviceType:serviceType];
    } else if (serviceType == ServiceTypeService) {
//        [cell setContent:[self.storeInfo.roomArray objectAtIndex:indexPath.row] serviceType:serviceType];
    }
    [cell layoutIfNeeded];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    RoomDetialViewController* viewController = [[RoomDetialViewController alloc] initWithNibName:@"RoomDetialViewController" bundle:nil];
    viewController.roomID = ((RoomInfo*)[self.storeInfo.roomArray objectAtIndex:indexPath.row]).serviceID;
    viewController.title = ((RoomInfo*)[self.storeInfo.roomArray objectAtIndex:indexPath.row]).name;
    [self.navigationController pushViewController:viewController animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO]; 
}

#pragma mark PWLoadMoreTableFooterDelegate Methods

- (void)loadMore {
    isLoading = YES;
    
    [self.storeInfo getNetData:self.storeID startIndex:(int)(self.storeInfo.roomArray.count) serviceType:ServiceTypeRoom];
    
    isLoading = NO;
    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:1.0];
}


- (BOOL)loadMoreTableDataSourceIsLoading {
    return isLoading;
}
- (BOOL)loadMoreTableDataSourceAllLoaded {
    return allLoad;
}

- (void)doneLoadingTableViewData {
    //  model should call this when its done loading
    [self.loadMoreTableFooterView loadMoreTableDataSourceDidFinishedLoading];
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
