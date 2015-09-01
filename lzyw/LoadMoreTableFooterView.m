//
//  PWLoadMoreTableFooter.m
//  PWLoadMoreTableFooter
//
//  Created by Puttin Wong on 3/31/13.
//  Copyright (c) 2013 Puttin Wong. All rights reserved.
//

#import "LoadMoreTableFooterView.h"

@interface LoadMoreTableFooterView (Private)
- (void)setState:(LoadMoreState)aState;
@end

@implementation LoadMoreTableFooterView

@synthesize delegate=_delegate;

- (id)init {
    if (self = [super initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 44)]) {
		
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
		UILabel *label = nil;
		
		label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 10, self.frame.size.width, 20.0f)];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [UIFont boldSystemFontOfSize:15.0f];
		label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		label.shadowOffset = CGSizeMake(0.0f, 1.0f);
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = NSTextAlignmentCenter;
		[self addSubview:label];
		_statusLabel=label;
		
		UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		view.frame = CGRectMake(12, 12, 20.0f, 20.0f);
		[self addSubview:view];
		_activityView = view;
		
		[self setState:LoadMoreNormal];      //wait for the data source to tell me he has loaded all data
    }
	
    return self;
	
}

- (void)setState:(LoadMoreState)aState{
	
	switch (aState) {
		case LoadMoreNormal:
            [self addTarget:self action:@selector(callDelegateToLoadMore) forControlEvents:UIControlEventTouchUpInside];
			_statusLabel.text = NSLocalizedString(@"加载更多", @"Load More items");
			[_activityView stopAnimating];
			
			break;
		case LoadMoreLoading:
            [self removeTarget:self action:@selector(callDelegateToLoadMore) forControlEvents:UIControlEventTouchUpInside];
			_statusLabel.text = NSLocalizedString(@"加载中...", @"Loading items");
			[_activityView startAnimating];
			
			break;
		case LoadMoreDone:
            [self removeTarget:self action:@selector(callDelegateToLoadMore) forControlEvents:UIControlEventTouchUpInside];
			_statusLabel.text = NSLocalizedString(@"", @"There is no more item");
			[_activityView stopAnimating];
			
			break;
		default:
			break;
	}
	
	_state = aState;
}

- (void)loadMoreTableDataSourceDidFinishedLoading {
    if ([self delegateIsAllLoaded]) {
        [self noMore];
    } else {
        [self canLoadMore];
    }
}

- (BOOL)delegateIsAllLoaded {
    BOOL _allLoaded = NO;
    if ([_delegate respondsToSelector:@selector(loadMoreTableDataSourceAllLoaded)]) {
        _allLoaded = [_delegate loadMoreTableDataSourceAllLoaded];
    }
    return _allLoaded;
}

- (void)resetLoadMore {
    if ([self delegateIsAllLoaded]) {
        [self noMore];
    } else
        [self canLoadMore];
}

- (void)canLoadMore {
    [self setState:LoadMoreNormal];
}

- (void)noMore {
    [self setState:LoadMoreDone];
}

- (void)realCallDelegateToLoadMore { //temporary
    if ([_delegate respondsToSelector:@selector(loadMore)]) {
        [_delegate loadMore];
        [self setState:LoadMoreLoading];
    }
}

-(void) updateStatus:(NSTimer *)timer{
    if ([_delegate respondsToSelector:@selector(loadMoreTableDataSourceIsLoading)]) {
        if ([_delegate loadMoreTableDataSourceIsLoading]) {
            //Do nothing
        } else {
            [timer invalidate];
            [self loadMoreTableDataSourceDidFinishedLoading];
        }
    } else {
        //Do nothing
    }
}

- (void)callDelegateToLoadMore {
    if (_state == LoadMoreNormal) {
        if ([_delegate respondsToSelector:@selector(loadMoreTableDataSourceIsLoading)]) {
            if ([_delegate loadMoreTableDataSourceIsLoading]) {
                [self removeTarget:self action:@selector(callDelegateToLoadMore) forControlEvents:UIControlEventTouchUpInside];
                _statusLabel.text = NSLocalizedString(@"Not available now...", @"Wait until it's safe to load more");
                [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(updateStatus:) userInfo:nil repeats:YES];
            } else {
                [self realCallDelegateToLoadMore];
            }
        } else
            [self realCallDelegateToLoadMore];//temporary
    } else {
        //Do nothing
    }
}
#pragma mark -
#pragma mark Dealloc
- (void)dealloc {
	
	_delegate=nil;
}
@end
