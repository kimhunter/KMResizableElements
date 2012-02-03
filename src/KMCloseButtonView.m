//
//  KMCloseButtonView.m
//  KMResizableElements
//
//  Created by Kim Hunter on 2/02/12.
//  Copyright (c) 2012 Kim Hunter. All rights reserved.
// 

#import "KMCloseButtonView.h"


@interface KMCloseButtonView ()
- (void)defaultInitialisation;
@end



@implementation KMCloseButtonView

@synthesize outerCircleColor;
@synthesize innerCircleColor;
@synthesize crossColor;
@synthesize drawShadow;

- (void)dealloc
{
    self.outerCircleColor = nil;
    self.innerCircleColor = nil;
    self.crossColor = nil;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self defaultInitialisation];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self)
    {
        [self defaultInitialisation];
    }
    return self;
}

- (void)defaultInitialisation
{
    self.outerCircleColor = [UIColor whiteColor];
    self.innerCircleColor = [UIColor blackColor];
    self.crossColor = outerCircleColor;
    drawShadow = YES;
}

- (UIImage *)image
{
    UIGraphicsBeginImageContext(self.bounds.size);
    [self drawRect:self.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)drawRect:(CGRect)rect
{
    UIBezierPath *outer, *inner;
    CGRect r = self.bounds;
    CGFloat offset = 0.87f;
    CGRect innerRect;
    
    if (drawShadow)
    {
        //tweak rect r to allow room for shadow
        r = CGRectApplyAffineTransform(r, CGAffineTransformMakeScale(offset, offset));
        r = CGRectIntegral(r);
    }
    

    innerRect = CGRectApplyAffineTransform(r, CGAffineTransformMakeScale(offset, offset));
    innerRect = CGRectIntegral(CGRectOffset(innerRect, (r.size.width-innerRect.size.width)/2, (r.size.height-innerRect.size.height)/2));
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetShouldAntialias(context, YES);
    
    // Draw outline circle
    CGContextSaveGState(context);
    if (drawShadow)
    {
        //use the space between rect r and the bounds for offset and blur
        CGContextSetShadow(context, CGSizeMake((self.bounds.size.width - r.size.width)/2, (self.bounds.size.height - r.size.height)/2), (self.bounds.size.width - r.size.width)/2);
    }
    [outerCircleColor setFill];
    CGContextFillEllipseInRect(context, r);
    CGContextRestoreGState(context);
    
    
    [innerCircleColor setFill];
    CGContextFillEllipseInRect(context, innerRect);
    
    // save state to clip the lines
    CGContextSaveGState(context);
    // now draw the cross
    [crossColor setStroke];
    CGFloat lineWidth = roundf((r.size.width-innerRect.size.width)/2 * 1.3);
    CGContextSetLineWidth(context, lineWidth);
    
    CGRect clipBounds = CGRectInset(innerRect, innerRect.size.width * 0.2, innerRect.size.width * 0.2);
    CGRectOffset(rect, (r.size.width - innerRect.size.width)/2, (r.size.height - innerRect.size.height)/2);
    CGContextClipToRect(context, clipBounds);
    CGContextBeginPath(context);
    // draw backslash line 
    CGContextMoveToPoint(context, innerRect.origin.x, innerRect.origin.y);
    CGContextAddLineToPoint(context, CGRectGetMaxX(innerRect), CGRectGetMaxY(innerRect));
    // draw fwd slash line /
    CGContextMoveToPoint(context, innerRect.origin.y, CGRectGetMaxY(innerRect));
    CGContextAddLineToPoint(context, CGRectGetMaxX(innerRect), innerRect.origin.y);
    CGContextDrawPath(context, kCGPathStroke);
    
    CGContextRestoreGState(context);
}


// Generate an image from this view
+ (UIImage *)imageWithSize:(CGSize)size
{
    UIImage *image = nil;
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);    
    KMCloseButtonView *v = [[KMCloseButtonView alloc] initWithFrame:rect];
    image = v.image;
    [v release];
    
    return image;
}

+ (UIImage *)imageWithSize:(CGSize)size andBlock:(void (^)(KMCloseButtonView *btnView))settingBlock
{
    UIImage *image = nil;
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    KMCloseButtonView *v = [[KMCloseButtonView alloc] initWithFrame:rect];
    settingBlock(v);
    
    image = [v image];
    
    [v release];
    return image;

}

@end
