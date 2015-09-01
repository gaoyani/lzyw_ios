//
//  StoreTableViewController.m
//  lzyw
//
//  Created by 高亚妮 on 15/3/30.
//  Copyright (c) 2015年 gaoyani. All rights reserved.
//

#import "StoreTableViewController.h"
#import "StoreTableViewCell.h"
#import "StoreDetailViewController.h"
#import "Constants.h"
#import "AppDelegate.h"

@interface StoreTableViewController ()

@end

@implementation StoreTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect rx = [UIScreen mainScreen].bounds;
    self.loadingView = [LoadingView initView];
    [self.loadingView setFrame:CGRectMake(0, 0, rx.size.width, rx.size.height)];
    [self.loadingView showView];
    [self.view addSubview:self.loadingView];
   
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(updateStoreList:)
     name:@"updateStoreList"//表示消息名称，发送跟接收双方都要一致
     object:nil];
    [self loadData];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"StoreCell" bundle:nil] forCellReuseIdentifier:@"storeCell"];
    //ios8 解决分割线没有左对齐问题
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)viewWillAppear:(BOOL)animated {
    StoreDetailInfo* storeInfo = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).storeDetailInfo;
    [self resetCollect:storeInfo];
}

-(void)resetCollect:(StoreDetailInfo*)storeInfo {
    [self.storeListInfo resetCollect:storeInfo];
    [self.tableView reloadData];
}

-(void)loadData {
    self.loadingView.hidden = NO;
    [self.storeListInfo getNetData:self.storeListType startIndex:0 searchInfo:self.searchInfo];
}

-(void)updateStoreList:(NSNotification *)notification {
    NSDictionary* result = notification.userInfo;
    if ([[result objectForKey:succeed] boolValue]) {
        if ([[result objectForKey:loadComplate] boolValue]) {
            
        }
        
        [self.tableView reloadData];
    } else {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"" message:[result objectForKey:errorMessage] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
    
    self.loadingView.hidden = YES;
}

#pragma mark -tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.storeListType == StoreListTypeAround) {
        return self.storeListInfo.aroundStoreArray.count;
    } else if (self.storeListType == StoreListTypeFavorite) {
        return self.storeListInfo.favoriteStoreArray.count;
    }
    return self.storeListInfo.recommendStoreArray.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    StoreTableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:@"storeCell" forIndexPath:indexPath];
    cell.viewController = self;
    //ios8 解决分割线没有左对齐问题
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }

    if (self.storeListType == StoreListTypeAround) {
        [cell setContent:[self.storeListInfo.aroundStoreArray objectAtIndex:indexPath.row]];
    } else if (self.storeListType == StoreListTypeFavorite) {
        [cell setContent:[self.storeListInfo.favoriteStoreArray objectAtIndex:indexPath.row]];
    } else {
        [cell setContent:[self.storeListInfo.recommendStoreArray objectAtIndex:indexPath.row]];
    }

    
    [cell layoutIfNeeded];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    StoreDetailViewController* viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"StoreDetailViewController"];
    NSInteger selectedIndex = indexPath.row;
    StoreInfo* storeInfo = (StoreInfo*)[self.storeListInfo.recommendStoreArray objectAtIndex:selectedIndex];
    if (self.storeListType == StoreListTypeAround) {
        storeInfo = (StoreInfo*)[self.storeListInfo.aroundStoreArray objectAtIndex:selectedIndex];
    } else if (self.storeListType == StoreListTypeFavorite) {
        storeInfo = (StoreInfo*)[self.storeListInfo.favoriteStoreArray objectAtIndex:selectedIndex];
    }

    viewController.storeID = storeInfo.storeID;
    viewController.title = storeInfo.name;
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO]; 
    [self.parentNavigationController pushViewController:viewController animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
