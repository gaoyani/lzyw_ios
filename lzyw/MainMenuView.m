//
//  MainMenuView.m
//  lzyw
//
//  Created by 高亚妮 on 15/8/13.
//  Copyright (c) 2015年 huiwei. All rights reserved.
//

#import "MainMenuView.h"
#import "SettingViewController.h"
#import "AboutViewController.h"

@implementation MainMenuInfo

@end

@implementation MainMenuView

-(void)awakeFromNib {
    [super awakeFromNib];
    
    [self initMenuArray];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    //ios8 解决分割线没有左对齐问题
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)initMenuArray {
    menuArray = [NSMutableArray array];
    
    MainMenuInfo* menuMain = [[MainMenuInfo alloc] init];
    menuMain.image = [UIImage imageNamed:@"menu_store"];
    menuMain.title = @"首页";
    [menuArray addObject:menuMain];
    
    MainMenuInfo* menuMember = [[MainMenuInfo alloc] init];
    menuMember.image = [UIImage imageNamed:@"menu_member"];
    menuMember.title = @"乐会员";
    [menuArray addObject:menuMember];
    
    MainMenuInfo* menuSearch = [[MainMenuInfo alloc] init];
    menuSearch.image = [UIImage imageNamed:@"menu_search"];
    menuSearch.title = @"乐搜索";
    [menuArray addObject:menuSearch];
    
    MainMenuInfo* menuShare = [[MainMenuInfo alloc] init];
    menuShare.image = [UIImage imageNamed:@"menu_share"];
    menuShare.title = @"乐分享";
    [menuArray addObject:menuShare];
    
    MainMenuInfo* menuSetting = [[MainMenuInfo alloc] init];
    menuSetting.image = [UIImage imageNamed:@"menu_setting"];
    menuSetting.title = @"设置";
    [menuArray addObject:menuSetting];
    
    MainMenuInfo* menuAbout = [[MainMenuInfo alloc] init];
    menuAbout.image = [UIImage imageNamed:@"menu_about"];
    menuAbout.title = @"关于";
    [menuArray addObject:menuAbout];
}

-(void)viewShow {
    CGRect rc = [UIScreen mainScreen].bounds;
    self.hidden = NO;
    self.transform = CGAffineTransformMakeTranslation(rc.size.width, 0);
    [UIView animateWithDuration:0.2 animations:^{
        self.transform = CGAffineTransformIdentity;
    }];
}

-(void)viewDisappear {
    CGRect rc = [UIScreen mainScreen].bounds;
    [UIView animateWithDuration:0.2 animations:^{
        self.transform = CGAffineTransformMakeTranslation(rc.size.width, 0);
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

+(MainMenuView *)initView
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"MainMenuView" owner:nil options:nil];
    return [nibView objectAtIndex:0];
}

#pragma mark -tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return menuArray.count;
}

//- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return CELL_HEIGHT;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *reuseIdetify = @"TableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdetify];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdetify];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.showsReorderControl = YES;
    }
    
    //ios8 解决分割线没有左对齐问题
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }

    
    MainMenuInfo* info = [menuArray objectAtIndex:indexPath.row];
    cell.imageView.image = info.image;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.text = info.title;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case MenuMainPage:
            [self.viewController.tabBarController setSelectedIndex:0];
            break;
            
        case MenuSearch:
            [self.viewController.tabBarController setSelectedIndex:1];
            break;
            
        case MenuShare:
            [self.viewController.tabBarController setSelectedIndex:2];
            break;
            
        case MenuMember:
            [self.viewController.tabBarController setSelectedIndex:3];
            break;
            
        case MenuSetting: {
            SettingViewController* viewController = [[SettingViewController alloc] initWithNibName:@"SettingViewController" bundle:nil];
            [self.viewController.navigationController pushViewController:viewController animated:YES];
        }
            break;
            
        case MenuAbout:{
            AboutViewController* viewController = [[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:nil];
            [self.viewController.navigationController pushViewController:viewController animated:YES];

        }
            break;
            
        default:
            break;
    }
   
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO]; 
    [self viewDisappear];
}


@end
