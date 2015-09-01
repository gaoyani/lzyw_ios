//
//  CommentTableViewCell.h
//  lzyw
//
//  Created by 高亚妮 on 15/7/2.
//  Copyright (c) 2015年 huiwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZYRatingView.h"
#import "CommentInfo.h"
#import "ListViewController.h"

@interface CommentTableViewCell : UITableViewCell<RatingViewDelegate> {
    CommentInfo* commentInfo;
}

@property (weak, nonatomic) IBOutlet UILabel *storeName;
@property (weak, nonatomic) IBOutlet UILabel *info;
@property (weak, nonatomic) IBOutlet UILabel *starDisplay;
@property (weak, nonatomic) IBOutlet UILabel *starSet;
@property (retain, nonatomic) IBOutlet ZYRatingView *ratingDisplay;
@property (retain, nonatomic) IBOutlet ZYRatingView *ratingSet;

@property (strong, nonatomic) IBOutlet UITextView *commentInput;
@property (weak, nonatomic) IBOutlet UIButton *comment;
@property (weak, nonatomic) IBOutlet UIView *commentView;

@property ListViewController* listViewController;

-(void)setContent:(CommentInfo*)commentInfo;

@end
