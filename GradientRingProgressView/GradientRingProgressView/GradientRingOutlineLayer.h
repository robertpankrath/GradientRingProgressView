//
//  GradientRingOutlineLayer.h
//  GradientRingProgressView
//
//  Created by Robert Pankrath on 15.07.14.
//  Copyright (c) 2014 Robert Pankrath. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface GradientRingOutlineLayer : CALayer

-(void)setCircleData:(NSDictionary*)data;
@property (nonatomic) UIColor *outlineColor;

@end
