//
//  RoomDetialViewController.m
//  lzyw
//
//  Created by 高亚妮 on 15/3/31.
//  Copyright (c) 2015年 gaoyani. All rights reserved.
//

#import "RoomDetialViewController.h"
#import "PublicInfo.h"
#import "AppDelegate.h"
#import "RoomReservationViewController.h"
#import "PayPasswordView.h"
#import "Constants.h"

@interface RoomDetialViewController ()

@end

@implementation RoomDetialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect rx = [UIScreen mainScreen].bounds;
    self.loadingView = [LoadingView initView];
    [self.loadingView setFrame:CGRectMake(0, 0, rx.size.width, rx.size.height)];
    [self.loadingView showView];
    [self.view addSubview:self.loadingView];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(updateInfo:)
     name:@"updateInfo"//表示消息名称，发送跟接收双方都要一致
     object:nil];
    self.roomInfo = ((AppDelegate*)[UIApplication sharedApplication].delegate).roomInfo;
    [self.roomInfo getNetData:self.roomID];
    
    [self.picturesView initView];
    
//    [self.progressHot setProgressImage:[UIImage imageNamed:@"room_hot_frout"]];
//    [self.progressHot setTrackImage:[UIImage imageNamed:@"room_hot_bg"]];
    
    self.timeSlotView.delegate = self;
    self.timeSlotView.dataSource = self;
    [self.timeSlotView registerNib:[UINib nibWithNibName:@"TimeSlotCell" bundle:nil] forCellWithReuseIdentifier:@"TimeSlotCell"];
    
    [self.reservationBtn setBackgroundImage:[[UIImage imageNamed:@"button_orange_up"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)] forState:UIControlStateNormal];
    [self.reservationBtn setBackgroundImage:[[UIImage imageNamed:@"button_orange_down"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)] forState:UIControlStateHighlighted];
}

-(void)updateInfo:(NSNotification *)notification {
    NSDictionary* result = notification.userInfo;
    if ([[result objectForKey:succeed] boolValue]) {
        //    self.roomInfo.feature = @"asdfkjljklasjdlfjkalsjdlkjalksdlkfjalsjdlfjal飞机开始建立地方开始就看看管理局卡桑德拉疯狂感觉";
        //    self.roomInfo.recommend = @"asdfkjljklasjdlfjkalsjdlkjalksdlkfjalsjdlfjal飞机开始建立地方开始就看看管理局卡桑德拉疯狂感觉";
        //    self.roomInfo.privilegeTitle = @"asdfkjljklasjdlfjkalsjdlkjalksdlkfjalsjdlfjal飞机开始建立地方开始就看看管理局卡桑德拉疯狂感觉";
        
        [self.picturesView setPictures:self.roomInfo.picture360Url picUrlArray:self.roomInfo.picUrlArray];
        self.nameTitle.text = [self.roomInfo.nameTitle stringByAppendingString:@"："];
        self.name.text = self.roomInfo.name;
        self.feature.text = self.roomInfo.feature;
        self.recommend.text = self.roomInfo.recommend;
        
        //    float hot = (float)self.roomInfo.hot/100;
        //    [self.progressHot setProgress:hot];
        
        if (![self.roomInfo.privilegeID isEqualToString:@"0"]) {
            NSMutableAttributedString* privilege = [[NSMutableAttributedString alloc] initWithString:self.roomInfo.privilegeTitle];
            NSRange range = {0, [privilege length]};
            [privilege addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:range];
            self.privilege.attributedText = privilege;
            self.privilege.userInteractionEnabled = YES;
            self.privilege.textColor = [UIColor blueColor];
            
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickPrivilege)];
            [self.privilege addGestureRecognizer:tapGesture];
        } else {
            self.privilege.text = self.roomInfo.privilegeTitle;
        }
        
        [self.timeSlotView reloadData];
    } else {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"" message:[result objectForKey:errorMessage] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }

    self.loadingView.hidden = YES;
}

-(void)onClickPrivilege {
    NSLog(@"onClickPrivilege");
}

#pragma mark -CollectionView datasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.roomInfo.todayTimeArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //重用cell
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TimeSlotCell" forIndexPath:indexPath];
    //赋值
    UILabel *label = (UILabel *)[cell viewWithTag:1];
    UIImageView* imageBG = (UIImageView*)[cell viewWithTag:2];
    
    TimeSlotInfo* timeInfo = [self.roomInfo.todayTimeArray objectAtIndex:(int)indexPath.row];
    label.text = timeInfo.time;
    if (!timeInfo.isBookable) {
        [imageBG setImage:[[UIImage imageNamed:@"reservation_invalid"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)]];
    } else {
        [imageBG setImage:[[UIImage imageNamed:@"type_unselected"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)]];
    }
    
    [cell layoutIfNeeded];
    
    return cell;
}

//定义每个UICollectionViewCell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(60, 20);
}

//每个item之间的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 2;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 2;
}


- (IBAction)reservationClick:(id)sender {
    RoomReservationViewController* viewController = [[RoomReservationViewController alloc] initWithNibName:@"RoomReservationViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
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
