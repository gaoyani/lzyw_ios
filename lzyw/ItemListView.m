//
//  ItemListView.m
//  lzyw
//
//  Created by 高亚妮 on 15/8/13.
//  Copyright (c) 2015年 huiwei. All rights reserved.
//

#import "ItemListView.h"
#import "NewsInfo.h"
#import "NewsDetailViewController.h"

@implementation ItemListView

-(void)awakeFromNib {
    [super awakeFromNib];
    
    self.dlgView.layer.cornerRadius = 8;
    self.dlgView.layer.masksToBounds = YES;
    self.dlgView.layer.borderWidth = 2;
    self.dlgView.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

-(void)viewShow {
    self.hidden = NO;
    self.dlgView.transform = CGAffineTransformMakeScale(0.97, 0.97);
    [UIView animateWithDuration:0.2 animations:^{
        self.dlgView.transform = CGAffineTransformIdentity;
        self.dlgView.alpha = 1.0f;
    }];
}

- (IBAction)buttonCancelClick:(id)sender {
    [self viewDisappear];
}

-(void)viewDisappear {
    [UIView animateWithDuration:0.2 animations:^{
        self.dlgView.transform = CGAffineTransformMakeScale(0.97, 0.97);
        self.dlgView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

+(ItemListView *)initView
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"ItemListView" owner:nil options:nil];
    return [nibView objectAtIndex:0];
}

-(void)setNewsArray:(NSMutableArray*)array {
    newsArray = array;
    [self.tableView reloadData];
}

#pragma mark -tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return newsArray.count;
}

//- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return CELL_HEIGHT;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseIdetify = @"TableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdetify];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdetify];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.showsReorderControl = YES;
     }
    
    NewsInfo* info = [newsArray objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.text = info.title;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NewsInfo* info = [newsArray objectAtIndex:indexPath.row];
    
    NewsDetailViewController* viewController = [[NewsDetailViewController alloc] initWithNibName:@"NewsDetailViewController" bundle:nil];
    viewController.newsID = info.newsID;
    viewController.hidesBottomBarWhenPushed = YES;
    [self.parentViewController.navigationController pushViewController:viewController animated:YES];
    [self viewDisappear];
}



@end
