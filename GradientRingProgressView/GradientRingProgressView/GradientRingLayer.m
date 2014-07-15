//
//  GradientRingLayer.m
//  GradientRingProgressView
//
//  Created by Robert Pankrath on 15.07.14.
//  Copyright (c) 2014 Robert Pankrath. All rights reserved.
//

#import "GradientRingLayer.h"

@implementation GradientRingLayer{
    int _numSegments;
    CGFloat _circleRadius;
    CGFloat _circleWidth;
    
    CAShapeLayer *_maskLayer;
    
    CGFloat _angleStep;
    CGFloat _startAngle;
}

+(id)layer{
    GradientRingLayer *layer = [[GradientRingLayer alloc] init];
    layer.startColor = [UIColor redColor];
    layer.endColor = [UIColor blueColor];
    return layer;
}

-(void)setCircleData:(NSDictionary*)data{
    _numSegments = [data[@"numberOfSegments"] intValue];
    _circleRadius = [data[@"circleRadius"] doubleValue];
    _circleWidth = [data[@"circleWidth"] doubleValue];
    
    [self createMask];
    [self setNeedsDisplay];
}

- (void)createMask{
    _maskLayer = [CAShapeLayer layer];
    _maskLayer.frame = self.bounds;
    
    _angleStep = 2*M_PI/(_numSegments+1);
    _startAngle = _angleStep/2 + M_PI_2;
    CGFloat endAngle = _startAngle+_numSegments*_angleStep;
    
    _maskLayer.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds)) radius:_circleRadius startAngle:_startAngle endAngle:endAngle clockwise:YES].CGPath;
    _maskLayer.fillColor = [UIColor clearColor].CGColor;
    _maskLayer.strokeColor = [UIColor redColor].CGColor;
    _maskLayer.lineWidth = 2*_circleWidth;
    
    self.mask = _maskLayer;
}

- (void)setProgress:(CGFloat)progress{
    _progress = MAX(0, MIN(1, progress));
    _maskLayer.strokeEnd = _progress;
}

-(void)drawInContext:(CGContextRef)ctx{
    UIGraphicsPushContext(ctx);
    CGContextSetAllowsAntialiasing(ctx, NO);
    
    CGPoint centerPoint = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    
    //convert colors to hsv
    CGFloat startHue,startSat,startBrightness,startAlpha;
    CGFloat endHue,endSat,endBrightness,endAlpha;
    [_startColor getHue:&startHue saturation:&startSat brightness:&startBrightness alpha:&startAlpha];
    [_endColor getHue:&endHue saturation:&endSat brightness:&endBrightness alpha:&endAlpha];
    if(endHue<startHue){
        endHue+=1;
    }
    
    //draw the segments
    UIColor *fromColor = self.startColor;
    for(int i=0;i<_numSegments;i++){
        CGFloat hue = startHue+((endHue-startHue)*(i+1))/_numSegments;
        if(hue>1){
            hue-=1;
        }
        CGFloat brightness = startBrightness+((endBrightness-startBrightness)*i)/(_numSegments);
        UIColor *toColor = [UIColor colorWithHue:hue saturation:startSat+((endSat-startSat)*(i+1))/_numSegments brightness:brightness alpha:startAlpha+((endAlpha-startAlpha)*(i+1))/_numSegments];
        
        [self drawSegmentAtCenter:centerPoint from:_startAngle to:_startAngle+_angleStep radius:_circleRadius width:_circleWidth startColor:fromColor endColor:toColor];
        
        _startAngle+=_angleStep;
        fromColor = toColor;
    }
    
    //clear the inside
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeClear);
    UIBezierPath* innerPath = [UIBezierPath bezierPathWithArcCenter:centerPoint radius:_circleRadius-_circleWidth startAngle:0 endAngle:2*M_PI clockwise:YES];
    [innerPath fill];
}

- (void)drawSegmentAtCenter:(CGPoint)center from:(CGFloat)startAngle to:(CGFloat)endAngle radius:(CGFloat)radius width:(CGFloat)width startColor:(UIColor *)startColor endColor:(UIColor*)endColor{
    
    CGContextSaveGState(UIGraphicsGetCurrentContext());
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:center];
    [path addArcWithCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    [path addClip];
    
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0, 1.0 };
    NSArray *colors = @[(__bridge id) startColor.CGColor, (__bridge id) endColor.CGColor];
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
    
    CGPoint startPoint = CGPointMake(center.x-sinf(startAngle-M_PI_2)*radius, center.y+cosf(startAngle-M_PI_2)*radius);
    CGPoint endPoint = CGPointMake(center.x-sinf(endAngle-M_PI_2)*radius, center.y+cosf(endAngle-M_PI_2)*radius);
    CGContextDrawLinearGradient(UIGraphicsGetCurrentContext(), gradient, startPoint, endPoint, kCGGradientDrawsAfterEndLocation|kCGGradientDrawsBeforeStartLocation);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
    
    CGContextRestoreGState(UIGraphicsGetCurrentContext());
}

@end
