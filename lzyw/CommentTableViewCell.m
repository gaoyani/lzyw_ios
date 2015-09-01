//
//  CommentTableViewCell.m
//  lzyw
//
//  Created by 高亚妮 on 15/7/2.
//  Copyright (c) 2015年 huiwei. All rights reserved.
//

#import "CommentTableViewCell.h"
#import "Constants.h"

@implementation CommentTableViewCell

- (void)awakeFromNib {
    [self.ratingDisplay setImagesDeselected:@"store_rating_off.png" partlySelected:@"store_rating_on.png" fullSelected:@"store_rating_on.png" andDelegate:nil];
    
    [self.ratingSet setImagesDeselected:@"store_rating_off.png" partlySelected:@"store_rating_on.png" fullSelected:@"store_rating_on.png" andDelegate:self];
    
    self.commentInput.layer.borderColor = [[UIColor colorWithRed:215.0 / 255.0 green:215.0 / 255.0 blue:215.0 / 255.0 alpha:1] CGColor];
    self.commentInput.layer.borderWidth = 0.6f;
    self.commentInput.layer.cornerRadius = 4.0f;
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(submitResult:)
     name:@"submitResult"
     object:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//实现代理方法
-(void)ratingChanged:(float)newRating {
//    [self.ratingSet displayRating:newRating];
    self.starSet.text = [NSString stringWithFormat:@"(%.1f星)",newRating];
}

-(void)setContent:(CommentInfo*)info {
    commentInfo = info;
    
    self.storeName.text = commentInfo.name;
    self.info.text = commentInfo.info;
    
    if (commentInfo.isComment) {
        self.ratingDisplay.hidden = NO;
        self.starDisplay.hidden = NO;
        [self.ratingDisplay displayRating:commentInfo.stars];
        [self.ratingDisplay setEditable:false];
        self.starDisplay.text = [NSString stringWithFormat:@"(%.1f星)",commentInfo.stars];
        [self.comment setTitle:@"已评价" forState:UIControlStateNormal];
        [self.comment setBackgroundImage:[UIImage imageNamed:@"reservation_invalid"] forState:UIControlStateNormal];
        [self.comment setBackgroundImage:[UIImage imageNamed:@"reservation_invalid"] forState:UIControlStateHighlighted];
        [self.comment setEnabled:NO];
        self.commentView.hidden = YES;
    } else {
        self.ratingDisplay.hidden = YES;
        self.starDisplay.hidden = YES;
        [self.comment setBackgroundImage:[[UIImage imageNamed:@"button_orange_up"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)] forState:UIControlStateNormal];
        [self.comment setBackgroundImage:[[UIImage imageNamed:@"button_orange_down"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)] forState:UIControlStateHighlighted];
        [self.comment setEnabled:YES];
        if (commentInfo.isStartComment) {
            [self.ratingSet displayRating:3.0];
            [self.comment setTitle:@"提交" forState:UIControlStateNormal];
            self.commentInput.text = @"";
            self.commentView.hidden = NO;
        } else {
            [self.comment setTitle:@"评价" forState:UIControlStateNormal];
            self.commentView.hidden = YES;
        }
    }
}

- (IBAction)commentClick:(id)sender {
    if (!commentInfo.isComment) {
        if (commentInfo.isStartComment) {
            commentInfo.stars = self.ratingSet.rating;
            commentInfo.comment = self.commentInput.text;
            [commentInfo submit:CommentTargetOrder];
        } else {
            commentInfo.isStartComment = YES;
            [self.listViewController.tableView reloadData];
        }
    }
}

-(void)submitResult:(NSNotification*)notification {
    NSMutableDictionary* resultDic = (NSMutableDictionary*)notification.userInfo;
    NSString* orderID = [resultDic objectForKey:@"order_id"];
    if ([orderID isEqualToString:commentInfo.orderID]) {
        BOOL isSucceed = [[resultDic objectForKey:succeed] boolValue];
        if (isSucceed) {
            commentInfo.isComment = YES;
            [self.listViewController.tableView reloadData];
        } else {
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"" message:[resultDic objectForKey:errorMessage] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
    }
}



@end
