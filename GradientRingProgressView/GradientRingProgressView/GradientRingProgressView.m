//
//  GradientRingProgressView.m
//  GradientRingProgressView
//
//  Created by Robert Pankrath on 15.07.14.
//  Copyright (c) 2014 Robert Pankrath. All rights reserved.
//

#import "GradientRingProgressView.h"
#import "GradientRingOutlineLayer.h"
#import "GradientRingLayer.h"
@implementation GradientRingProgressView{
    GradientRingLayer *_gradientLayer;
    GradientRingOutlineLayer *_outlineLayer;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        _gradientLayer = [GradientRingLayer layer];
        _gradientLayer.contentsScale = [UIScreen mainScreen].scale;
        [self.layer addSublayer:_gradientLayer];
        
        _outlineLayer = [GradientRingOutlineLayer layer];
        _outlineLayer.contentsScale = [UIScreen mainScreen].scale;
        [self.layer addSublayer:_outlineLayer];
        
        self.progress = 1;
    }
    return self;
}

- (void)setProgress:(CGFloat)progress{
    _progress = MAX(0, MIN(1, progress));
    _gradientLayer.progress = progress;
}

- (void)layoutSubviews{
    int numSegments = 7;
    CGFloat circleRadius = MIN(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))/2-1;
    CGFloat circleWidth = circleRadius/5;
    
    NSDictionary *circleData = @{
                                 @"numberOfSegments":@(numSegments),
                                 @"circleRadius":@(circleRadius),
                                 @"circleWidth":@(circleWidth)
                                 };
    
    _gradientLayer.frame = self.bounds;
    [_gradientLayer setCircleData:circleData];
    
    _outlineLayer.frame = self.bounds;
    [_outlineLayer setCircleData:circleData];
}

@end
