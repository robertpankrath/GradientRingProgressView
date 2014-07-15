//
//  GradientRingOutlineLayer.m
//  GradientRingProgressView
//
//  Created by Robert Pankrath on 15.07.14.
//  Copyright (c) 2014 Robert Pankrath. All rights reserved.
//

#import "GradientRingOutlineLayer.h"

@implementation GradientRingOutlineLayer{
    int _numSegments;
    CGFloat _circleradius;
    CGFloat _circlewidth;
}

+(id)layer{
    GradientRingOutlineLayer *layer = [[GradientRingOutlineLayer alloc] init];
    layer.outlineColor = [UIColor colorWithWhite:130/255. alpha:1];
    return layer;
}

-(void)setCircleData:(NSDictionary*)data{
    _numSegments = [data[@"numberOfSegments"] intValue];
    _circleradius = [data[@"circleRadius"] doubleValue];
    _circlewidth = [data[@"circleWidth"] doubleValue];
    
    [self setNeedsDisplay];
}

-(void)drawInContext:(CGContextRef)ctx{
    UIGraphicsPushContext(ctx);
    
    CGPoint centerPoint = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    CGFloat angleStep = 2*M_PI/(_numSegments+1);
    CGFloat startAngle = angleStep/2 + M_PI_2;
    
    [self.outlineColor setStroke];
    
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:centerPoint radius:_circleradius startAngle:startAngle endAngle:-angleStep/2 + M_PI_2 clockwise:YES];
    [circlePath stroke];
    
    circlePath = [UIBezierPath bezierPathWithArcCenter:centerPoint radius:_circleradius-_circlewidth startAngle:startAngle endAngle:-angleStep/2 + M_PI_2 clockwise:YES];
    [circlePath stroke];
    
    for (int i=0; i<_numSegments+1; i++) {
        CGPoint startPoint = CGPointMake(centerPoint.x+_circleradius*sinf(startAngle), centerPoint.y+_circleradius*cosf(startAngle));
        CGPoint endPoint = CGPointMake(centerPoint.x+(_circleradius-_circlewidth)*sinf(startAngle), centerPoint.y+(_circleradius-_circlewidth)*cosf(startAngle));
        CGContextMoveToPoint(ctx, startPoint.x, startPoint.y);
        CGContextAddLineToPoint(ctx, endPoint.x, endPoint.y);
        CGContextStrokePath(ctx);
        startAngle+=angleStep;
    }
    
}

@end
