//
//  CustomProgressView.m
//  lzyw
//
//  Created by 高亚妮 on 15/4/3.
//  Copyright (c) 2015年 gaoyani. All rights reserved.
//

#import "CustomProgressView.h"
#import "Utils.h"

@implementation CustomProgressView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        self.progressTintColor = nil;
        self.trackTintColor = nil;
        _progress = 0.0f;
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    CGFloat radius = height / 2.0f;
    
    CGFloat fillPercent = _progress < 0.0 || _progress > 1.0 ? 0.0 : _progress;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    CGMutablePathRef tarckPathRef = CGPathCreateMutable();
    CGPathAddArc(tarckPathRef, nil, radius, radius, radius, -M_PI_2, -(M_PI_2-M_PI), 1);
    CGPathAddLineToPoint(tarckPathRef, nil, width, height);
    CGPathAddArc(tarckPathRef, nil, width-radius, radius, radius, M_PI_2, -M_PI_2, 1);
    CGPathAddLineToPoint(tarckPathRef, nil, radius, 0);
    CGPathCloseSubpath(tarckPathRef);
    
    CGMutablePathRef progressPathRef = NULL;
    CGFloat fillWidth = width * fillPercent;
    if (fillWidth > 0.0f) {
        progressPathRef = CGPathCreateMutable();
        CGPathAddArc(progressPathRef, nil, radius, radius, radius, -M_PI_2, -(M_PI_2-M_PI), 1);
        CGPathAddLineToPoint(progressPathRef, nil, fillWidth, height);
        CGPathAddArc(progressPathRef, nil, fillWidth-radius, radius, radius, M_PI_2, -M_PI_2, 1);
        CGPathAddLineToPoint(progressPathRef, nil, radius, 0);
        CGPathCloseSubpath(progressPathRef);
    }
    
    CGContextAddPath(context, tarckPathRef);
    [self.trackTintColor setFill];
    CGContextDrawPath(context, kCGPathFill);
    CGPathRelease(tarckPathRef);
    
    if (progressPathRef) {
        CGContextAddPath(context, progressPathRef);
        [self.progressTintColor setFill];
        CGContextDrawPath(context, kCGPathFill);
        CGPathRelease(progressPathRef);
    }
    
    CGContextRestoreGState(context);
}


- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    [self setNeedsDisplay];
}


- (void)setTrackImage:(UIImage *)trackImage {
    if(_trackImage != trackImage) {
        if(_trackImage) {
            _trackImage = nil;
        }
        
        CGFloat leftRightCaps = 3.0;
        UIEdgeInsets capInsets = UIEdgeInsetsMake(0, leftRightCaps, 0, leftRightCaps);
        UIImage *nmImage = trackImage;
//        if (SYSTEM_VERSION >= 6) {
//            UIImageResizingMode resizingMode = UIImageResizingModeStretch;
//            nmImage = [_trackImage resizableImageWithCapInsets:capInsets
//                                                  resizingMode:resizingMode];
//            
//        } else if (SYSTEM_VERSION >= 5) {
//            CGFloat topBottom = 2;
//            capInsets.top = topBottom;
//            capInsets.bottom = topBottom;
//            nmImage = [_trackImage resizableImageWithCapInsets:capInsets];
//        }
//        nmImage = [Utils scaleToSize:nmImage size:CGSizeMake(1024.0, self.frame.size.height)];
        self.trackTintColor = [UIColor colorWithPatternImage:nmImage];
        [self setNeedsDisplay];
    }
}


- (void)setProgressImage:(UIImage *)progressImage {
    if(_progressImage != progressImage) {
        if(_progressImage) {
            _progressImage = nil;
        }
        
        CGFloat leftRightCaps = 6.0;
        UIEdgeInsets capInsets = UIEdgeInsetsMake(0, leftRightCaps, 0, leftRightCaps);
        UIImage *onImage = progressImage;
//        if (SYSTEM_VERSION >= 6) {
//            UIImageResizingMode resizingMode = UIImageResizingModeStretch;
//            onImage = [_progressImage resizableImageWithCapInsets:capInsets
//                                                     resizingMode:resizingMode];
//            
//        } else if (SYSTEM_VERSION >= 5) {
//            CGFloat topBottom = 2;
//            capInsets.top = topBottom;
//            capInsets.bottom = topBottom;
//            onImage = [_progressImage resizableImageWithCapInsets:capInsets];
//        }
//        onImage = [Utils scaleToSize:onImage size:CGSizeMake(1024.0, self.frame.size.height)];
        self.progressTintColor = [UIColor colorWithPatternImage:onImage];
        [self setNeedsDisplay];
    }
}


- (void)setTrackTintColor:(UIColor *)trackTintColor {
    if(_trackTintColor != trackTintColor) {
        if(_trackTintColor) {
            _trackTintColor = nil;
        }
        
        [self setNeedsDisplay];
    }
}


- (void)setProgressTintColor:(UIColor *)progressTintColor {
    if(_progressTintColor != progressTintColor) {
        if(_progressTintColor) {
            _progressTintColor = nil;
        }
        
//        if (!_progressTintColor) {
//            _progressTintColor = [UIColor colorWithHex:0x2e8ae6];
//        }
        [self setNeedsDisplay];
    }
}

@end
