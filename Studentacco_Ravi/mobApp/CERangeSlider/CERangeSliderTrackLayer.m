//
//  CERangeSliderTrackLayer.m
//  CERangeSlider
//
//  Created by Colin Eberhardt on 24/03/2013.
//  Copyright (c) 2013 Colin Eberhardt. All rights reserved.
//

#import "CERangeSliderTrackLayer.h"
#import "CERangeSlider.h"

@implementation CERangeSliderTrackLayer

- (void)drawInContext:(CGContextRef)ctx
{
    // clip
    float cornerRadius = self.bounds.size.height * self.slider.curvatiousness / 2.0;
    UIBezierPath *switchOutline = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                             cornerRadius:cornerRadius];
	CGContextAddPath(ctx, switchOutline.CGPath);
    CGContextClip(ctx);
    
    // fill the track
    CGContextSetFillColorWithColor(ctx, self.slider.trackColour.CGColor);
    CGContextAddPath(ctx, switchOutline.CGPath);
    CGContextFillPath(ctx);
    
    CGContextSetFillColorWithColor(ctx, [UIColor colorWithPatternImage:[UIImage imageNamed:@"filter-slider"]].CGColor);
    CGContextFillPath(ctx);
 
    // shadow
    CGContextSetShadowWithColor(ctx, CGSizeMake(0, 2.0), 3.0, [UIColor redColor].CGColor);
    CGContextAddPath(ctx, switchOutline.CGPath);
    CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);
    CGContextStrokePath(ctx);
 
    // outline
    CGContextAddPath(ctx, switchOutline.CGPath);
    CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);
    CGContextSetLineWidth(ctx, 0.5);
    CGContextStrokePath(ctx);
    
}


@end
