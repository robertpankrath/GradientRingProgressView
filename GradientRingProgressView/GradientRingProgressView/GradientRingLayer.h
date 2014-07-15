//
//  GradientRingLayer.h
//  GradientRingProgressView
//
//  Created by Robert Pankrath on 15.07.14.
//  Copyright (c) 2014 Robert Pankrath. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface GradientRingLayer : CALayer

@property (nonatomic) CGFloat progress;
@property (nonatomic) UIColor *startColor;
@property (nonatomic) UIColor *endColor;
-(void)setCircleData:(NSDictionary*)data;
@end
