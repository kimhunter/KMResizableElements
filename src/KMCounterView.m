//
//  KMDisclosueButtonView.m
//  Elements
//
//  Created by Kim Hunter on 4/02/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import "KMCounterView.h"

@implementation KMCounterView
@synthesize text = _text;

- (void)setText:(NSString *)text
{
    if (text != _text && ![text isEqualToString:_text])
    {
        [_text release];
        _text = [text retain];
        [self setNeedsDisplay];
    }
}

- (NSString *)text
{
    return [[_text retain] autorelease];
}

- (void)dealloc
{
    [_text release];
    [super dealloc];
}

#define COLOR_CoolBlue [UIColor colorWithRed:COLOR2PERC(35.f) green:COLOR2PERC(110.0f) blue:COLOR2PERC(216.f) alpha:1.0]
#define COLOR2PERC(c) ((CGFloat)((c)/255))

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect r = self.bounds;
    CGFloat insetPercentage = 0.1f;
    CGRect mainRect = CGRectIntegral(CGRectInset(r, r.size.width*insetPercentage, r.size.height*insetPercentage));
    mainRect.origin.y /= 2;  // shift up so shadow isn't cut at bottom
    [[UIColor whiteColor] setStroke];
    [[UIColor redColor] setFill];
    CGContextSetLineWidth(context, mainRect.size.width * insetPercentage * 0.8);

    CGContextSaveGState(context);
    CGContextSetShadow(context, CGSizeMake(0.0, 6.0), 10.0);
    CGContextAddEllipseInRect(context, mainRect);
    CGContextDrawPath(context, kCGPathFillStroke);
    CGContextRestoreGState(context);
    
    if ([_text length] != 0)
    {
        CGContextSaveGState(context);
        [[UIColor whiteColor] setFill];
        CGContextSetShadow(context, CGSizeMake(0.0, -1.0), 0.0);
        
        CGFloat fontSize = floorf(mainRect.size.height * 0.76);
        UIFont *font = [UIFont boldSystemFontOfSize: fontSize];
        CGRect textRect;
        UILineBreakMode breakMode = UILineBreakModeTailTruncation;
        CGSize textSize = [_text sizeWithFont:font 
                                  minFontSize:2.0 
                               actualFontSize:&fontSize
                                     forWidth:fontSize 
                                lineBreakMode:UILineBreakModeTailTruncation];
        font = [UIFont boldSystemFontOfSize: fontSize];
        textSize = [_text sizeWithFont:font forWidth:textSize.width lineBreakMode:breakMode];
        textRect.size = textSize;
        textRect.origin = CGPointMake(CGRectGetMidX(mainRect)-(textSize.width/2), CGRectGetMidY(mainRect)-(font.lineHeight/2));
        textRect = CGRectIntegral(textRect);
        [_text drawInRect:textRect withFont:font lineBreakMode:breakMode];
        CGContextRestoreGState(context);
    }
    
    // ===== Apply Gloss =====
    CGContextSaveGState(context);
    CGContextBeginPath(context); 
    CGRect glossRect = CGRectOffset(rect, 0.0f, -110.0);
    glossRect = CGRectInset(glossRect, glossRect.size.width * -0.3, glossRect.size.height * -0.3);
    
    // build intersection of both circles as the clip mask
    CGContextAddEllipseInRect(context, glossRect);
    CGContextClip(context);
    // this rect is on the outsid of the border circle
    CGContextAddEllipseInRect(context, CGRectInset(mainRect, mainRect.size.width * insetPercentage * -0.8/2, mainRect.size.width * insetPercentage * -0.8/2));
    CGContextClip(context);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locs[] = {0.0f, 1.0f};
    CGColorRef colorRefs[] = {  [[UIColor colorWithWhite:1.0 alpha:0.8] CGColor],
                                [[UIColor colorWithWhite:1.0 alpha:0.2] CGColor]};
    CFArrayRef colors = CFArrayCreate(NULL, (const void**)colorRefs, sizeof(colorRefs) / sizeof(CGColorRef), &kCFTypeArrayCallBacks);
    CGGradientRef glossGradient = CGGradientCreateWithColors(colorSpace, colors, locs);
    CGColorSpaceRelease(colorSpace);
    CFRelease(colors);

    // draw gradient
    CGContextDrawLinearGradient(context, glossGradient, r.origin, CGPointMake(0.0, CGRectGetMaxY(glossRect)+2), kCGGradientDrawsBeforeStartLocation);
    CGGradientRelease(glossGradient);
    CGContextRestoreGState(context);

    
    
}


@end
