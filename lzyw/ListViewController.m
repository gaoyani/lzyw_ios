//
//  ListViewController.m
//  lzyw
//
//  Created by 高亚妮 on 15/6/30.
//  Copyright (c) 2015年 huiwei. All rights reserved.
//

#import "ListViewController.h"
#import "Constants.h"
#import "OrderTableViewCell.h"
#import "PointTableViewCell.h"
#import "CommentTableViewCell.h"
#import "Utils.h"
#import "OrderDetailViewController.h"

@interface ListViewController ()

@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    if(IOS7) {
//        self.edgesForExtendedLayout = UIRectEdgeNone;
//        self.automaticallyAdjustsScrollViewInsets = NO;
////        self.modalPresentationCapturesStatusBarAppearance = NO;
//    }
    
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    if (self.listViewType == ListViewOrder) {
        [self.tableView registerNib:[UINib nibWithNibName:@"OrderCell" bundle:nil] forCellReuseIdentifier:@"OrderCell"];
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        orderList = [NSMutableArray array];
    } else if (self.listViewType == ListViewComment) {
        [self.tableView registerNib:[UINib nibWithNibName:@"CommentCell" bundle:nil] forCellReuseIdentifier:@"CommentCell"];
        commentList = [NSMutableArray array];
    } else {
        [self.tableView registerNib:[UINib nibWithNibName:@"PointCell" bundle:nil] forCellReuseIdentifier:@"PointCell"];
        [self.tableView setSeparatorColor:[UIColor orangeColor]];
        pointList = [NSMutableArray array];
    }
    
    //ios8 解决分割线没有左对齐问题
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    task = [[OrderListTask alloc] init];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(updateTableView:)
     name:@"updateTableView"//表示消息名称，发送跟接收双方都要一致
     object:nil];
}

-(void)viewWillAppear:(BOOL)animated {
    if (self.listViewType == ListViewOrder) {
        [orderList removeAllObjects];
    } else if (self.listViewType == ListViewComment) {
        [commentList removeAllObjects];
    } else {
        [pointList removeAllObjects];
    }
    [self loadData];
}

-(void)loadData {
    [self.loadingView showView];
    if (self.listViewType == ListViewOrder) {
        [task getOrderList:orderList];
    } else if (self.listViewType == ListViewComment) {
        [task getCommentList:commentList];
    } else {
        [task getPointList:pointList];
    }
}

-(void)updateTableView:(NSNotification *)notification {
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
    if (self.listViewType == ListViewOrder) {
        return orderList.count;
    } else if (self.listViewType == ListViewComment) {
        return commentList.count;
    } else {
        return pointList.count;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.listViewType == ListViewOrder) {
        return 125;
    } else if (self.listViewType == ListViewComment) {
//        CommentTableViewCell *cell = (CommentTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
//        int height = cell.frame.size.height;
//        return cell.frame.size.height;
        CommentInfo *info = [commentList objectAtIndex:indexPath.row];
        if (!info.isComment && info.isStartComment) {
            return 150;
        } else {
            return 60;
        }
    } else {
        return 60;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.listViewType == ListViewOrder) {
        OrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderCell" forIndexPath:indexPath];
        [cell setContent:[orderList objectAtIndex:indexPath.row]];
        cell.listViewController = self;
        //ios8 解决分割线没有左对齐问题
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        [cell layoutIfNeeded];
        return cell;
    } else if (self.listViewType == ListViewComment) {
        CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell" forIndexPath:indexPath];
        if (cell == nil) {
            cell = ( CommentTableViewCell *)[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CommentCell"];
        }
        [cell setContent:[commentList objectAtIndex:indexPath.row]];
        cell.listViewController = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //ios8 解决分割线没有左对齐问题
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        [cell layoutIfNeeded];
        return cell;
    } else {
        PointTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PointCell" forIndexPath:indexPath];
        [cell setContent:[pointList objectAtIndex:indexPath.row]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //ios8 解决分割线没有左对齐问题
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        [cell layoutIfNeeded];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderDetailViewController* viewController = [[OrderDetailViewController alloc] initWithNibName:@"OrderDetailViewController" bundle:nil];
    viewController.orderDetailInfo = [[OrderDetailInfo alloc] init];
    [viewController.orderDetailInfo copy:[orderList objectAtIndex:indexPath.row]];
    viewController.hidesBottomBarWhenPushed = YES;
    [self.parentNavigationController pushViewController:viewController animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
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
