//
//  ZYRatingView.m
//  RatingViewDemo
//
//  Created by zhangyuc on 13-5-22.
//  Copyright (c) 2013年 zhangyuc. All rights reserved.
//

#import "ZYRatingView.h"

@implementation ZYRatingView

//设置getter方法
@synthesize s1, s2, s3, s4, s5;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setImagesDeselected:(NSString *)deselectedImage
			partlySelected:(NSString *)halfSelectedImage
			  fullSelected:(NSString *)fullSelectedImage
			   andDelegate:(id<RatingViewDelegate>)d {
    //实例化未选中图片对象
    unselectedImage = [UIImage imageNamed:deselectedImage];
    //判断如果没有部分选中的图片，则使用未选中的图片
    partlySelectedImage = halfSelectedImage == nil?unselectedImage:[UIImage imageNamed:halfSelectedImage];
    fullySelectedImage = [UIImage imageNamed:fullSelectedImage];
    //设置代理
    viewDelegate = d;
    
    editable = true;
    height=self.frame.size.height; width=height;
    
//    //判断如果height的高度小于图片的高度，则赋值给最高图片的高度，width同理
//    height=0.0; width=0.0;
//	if (height < [fullySelectedImage size].height) {
//		height = [fullySelectedImage size].height;
//	}
//	if (height < [partlySelectedImage size].height) {
//		height = [partlySelectedImage size].height;
//	}
//	if (height < [unselectedImage size].height) {
//		height = [unselectedImage size].height;
//	}
//	if (width < [fullySelectedImage size].width) {
//		width = [fullySelectedImage size].width;
//	}
//	if (width < [partlySelectedImage size].width) {
//		width = [partlySelectedImage size].width;
//	}
//	if (width < [unselectedImage size].width) {
//		width = [unselectedImage size].width;
//	}
    
    
    starRating = 0;
	lastRating = 0;
    //初始化将五个ImageView都设置为未选中状态
	s1 = [[UIImageView alloc] initWithImage:unselectedImage];
	s2 = [[UIImageView alloc] initWithImage:unselectedImage];
	s3 = [[UIImageView alloc] initWithImage:unselectedImage];
	s4 = [[UIImageView alloc] initWithImage:unselectedImage];
	s5 = [[UIImageView alloc] initWithImage:unselectedImage];
    //设置5个ImageView的Frame
    [s1 setFrame:CGRectMake(0, 0, width, height)];
    [s2 setFrame:CGRectMake(width,     0, width, height)];
	[s3 setFrame:CGRectMake(2 * width, 0, width, height)];
	[s4 setFrame:CGRectMake(3 * width, 0, width, height)];
	[s5 setFrame:CGRectMake(4 * width, 0, width, height)];
    //一个布尔值,确定用户事件被忽略和从事件队列中删除。
	[s1 setUserInteractionEnabled:NO];
	[s2 setUserInteractionEnabled:NO];
	[s3 setUserInteractionEnabled:NO];
	[s4 setUserInteractionEnabled:NO];
	[s5 setUserInteractionEnabled:NO];
    //向本视图中添加s1
    [self addSubview:s1];
    [self addSubview:s2];
	[self addSubview:s3];
	[self addSubview:s4];
	[self addSubview:s5];
    
    //设置本视图的Frame
    CGRect frame = [self frame];
	frame.size.width = width * 5;
	frame.size.height = height;
	[self setFrame:frame];
}

-(void)setEditable:(bool)isEditable {
    editable = isEditable;
}

-(void)displayRating:(float)rating {
    if (editable == false)
        return;
    
    //初始化评级星图都为未选中状态
    [s1 setImage:unselectedImage];
	[s2 setImage:unselectedImage];
	[s3 setImage:unselectedImage];
	[s4 setImage:unselectedImage];
	[s5 setImage:unselectedImage];
    //如果分数大于等于0.5分第一个星图显示为部分选中状态
    if (rating >= 0.5) {
		[s1 setImage:partlySelectedImage];
	}
    //如果分数大于等于1分第一个星图显示为全部选中状态
    if (rating >= 1) {
		[s1 setImage:fullySelectedImage];
	}
    if (rating >= 1.5) {
		[s2 setImage:partlySelectedImage];
	}
	if (rating >= 2) {
		[s2 setImage:fullySelectedImage];
	}
	if (rating >= 2.5) {
		[s3 setImage:partlySelectedImage];
	}
	if (rating >= 3) {
		[s3 setImage:fullySelectedImage];
	}
	if (rating >= 3.5) {
		[s4 setImage:partlySelectedImage];
	}
	if (rating >= 4) {
		[s4 setImage:fullySelectedImage];
	}
	if (rating >= 4.5) {
		[s5 setImage:partlySelectedImage];
	}
	if (rating >= 5) {
		[s5 setImage:fullySelectedImage];
	}
    
    //分数赋值
    starRating = rating;
    lastRating = rating;
    //改变评分
    [viewDelegate ratingChanged:rating];
}
//告诉接收器当一个或多个手指碰下来在一个视图或者窗口开始时候调用。
-(void) touchesBegan: (NSSet *)touches withEvent: (UIEvent *)event
{
    //调用移动时候的方法
	[self touchesMoved:touches withEvent:event];
}
//告诉接收器当一个或多个手指碰下来在一个视图或者窗口移动的时候调用。
/*
 *touches:一组UITouch实例代表了当事件正在响应的时候的手指触动。
 *event:一个代表事件的触动属于对象。
 */
-(void) touchesMoved: (NSSet *)touches withEvent: (UIEvent *)event
{
    //定位手指的位置
	CGPoint pt = [[touches anyObject] locationInView:self];
    //新的评分等于  手指位置/总的宽度 所得的值 加上1
	int newRating = (int) (pt.x / width) + 1;
    //判断如果超出范围则结束
	if (newRating < 1 || newRating > 5)
		return;
	//如果新的评分不等于上一次的评分，则重新评分
	if (newRating != lastRating)
		[self displayRating:newRating];
}

//告诉接收器当一个或多个手指碰下来在一个视图或者窗口结束时候调用。
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	[self touchesMoved:touches withEvent:event];
}
//设置开始评分
-(float)rating {
	return starRating;
}


@end
