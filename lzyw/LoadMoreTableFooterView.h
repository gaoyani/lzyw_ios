//
//  PWLoadMoreTableFooter.h
//  PWLoadMoreTableFooter
//
//  Created by Puttin Wong on 3/31/13.
//  Copyright (c) 2013 Puttin Wong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum{
	LoadMoreNormal = 0,
    LoadMoreLoading,
    LoadMoreDone,
} LoadMoreState;


@protocol LoadMoreTableFooterDelegate;
@interface LoadMoreTableFooterView : UIControl {
    id __unsafe_unretained delegate;
	LoadMoreState _state;
    
	UILabel *_statusLabel;
	UIActivityIndicatorView *_activityView;
    
}
- (void)loadMoreTableDataSourceDidFinishedLoading;
- (void)resetLoadMore;

@property(nonatomic,unsafe_unretained) id <LoadMoreTableFooterDelegate> delegate;
@end

@protocol LoadMoreTableFooterDelegate <NSObject>
@required
- (void)loadMore;
- (BOOL)loadMoreTableDataSourceAllLoaded;
@optional
- (BOOL)loadMoreTableDataSourceIsLoading; //optional temporary
@end