//
//  KMDisclosueButtonView.m
//  Elements
//
//  Created by Kim Hunter on 4/02/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import "KMDisclosueButtonView.h"

@implementation KMDisclosueButtonView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
#define COLOR_CoolBlue [UIColor colorWithRed:COLOR2PERC(35.f) green:COLOR2PERC(110.0f) blue:COLOR2PERC(216.f) alpha:1.0]
#define COLOR2PERC(c) ((CGFloat)((c)/255))



- (CGGradientRef)glossGradient
{
    CGGradientRef glossGradient;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locs[] = {0.0f, 1.0f};
    CGColorRef colorRefs[] = { [[UIColor colorWithWhite:1.0 alpha:0.6] CGColor],
                               [[UIColor colorWithWhite:1.0 alpha:0.3] CGColor]};
    CFArrayRef colors = CFArrayCreate(NULL, (const void**)colorRefs, sizeof(colorRefs) / sizeof(CGColorRef), &kCFTypeArrayCallBacks);
    glossGradient = CGGradientCreateWithColors(colorSpace, colors, locs);    
    return glossGradient;
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect r = self.bounds;
    CGFloat insetPercentage = 0.1f;
    CGRect mainRect = CGRectIntegral(CGRectInset(r, r.size.width*insetPercentage, r.size.height*insetPercentage));

    [[UIColor whiteColor] setStroke];
    [COLOR_CoolBlue setFill];
    CGContextSetLineWidth(context, mainRect.size.width * insetPercentage * 0.8);
    CGContextAddEllipseInRect(context, mainRect);
    CGContextDrawPath(context, kCGPathFillStroke);

    CGContextSaveGState(context);

    CGContextBeginPath(context); 
    CGRect glossRect = CGRectOffset(rect, 0.0f, -60.0);
    
    CGContextAddEllipseInRect(context, glossRect);
    CGContextClip(context);
    CGContextAddEllipseInRect(context, CGRectInset(mainRect, mainRect.size.width * insetPercentage * -0.8/2, mainRect.size.width * insetPercentage * -0.8/2));
    CGContextClip(context);
    CGContextDrawLinearGradient(context, [self glossGradient], glossRect.origin, CGPointMake(glossRect.origin.x, CGRectGetMaxY(glossRect)), kCGGradientDrawsBeforeStartLocation);

    

    CGContextClosePath(context);
    CGContextRestoreGState(context);

    
    
}


@end
