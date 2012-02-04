//
//  KMDisclosueButtonView.m
//  Elements
//
//  Created by Kim Hunter on 4/02/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import "KMDisclosueButtonView.h"

@implementation KMDisclosueButtonView
@synthesize number;
@synthesize timer;

- (void)updateNumber
{
    self.number = number + 1;
    if (number == 14)
    {
        number = 97;
    }
    [self setNeedsDisplay];
}

- (void)dealloc
{
    [self.timer invalidate];
    self.timer = nil;
    [super dealloc];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        number = 0;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.7 target:self selector:@selector(updateNumber) userInfo:nil repeats:YES];
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self)
    {
        number = 7;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateNumber) userInfo:nil repeats:YES];
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
    CGColorRef colorRefs[] = { [[UIColor colorWithWhite:1.0 alpha:0.8] CGColor],
                               [[UIColor colorWithWhite:1.0 alpha:0.0] CGColor]};
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
    mainRect.origin.y /= 2;  // shift up so shadow isn't cut at bottom
    [[UIColor whiteColor] setStroke];
    [COLOR_CoolBlue setFill];
    CGContextSetLineWidth(context, mainRect.size.width * insetPercentage * 0.8);

    CGContextSaveGState(context);
    CGContextSetShadow(context, CGSizeMake(0.0, 6.0), 10.0);
    CGContextAddEllipseInRect(context, mainRect);
    CGContextDrawPath(context, kCGPathFillStroke);
    CGContextRestoreGState(context);
    
    CGContextSaveGState(context);
    [[UIColor whiteColor] setFill];
    CGContextSetShadow(context, CGSizeMake(-1.0, -1.0), 0.0);
    NSString *text = [NSString stringWithFormat:@"%d", number];
    CGFloat fontSize = floorf(mainRect.size.height * 0.76);
    CGFloat originalSize = fontSize;
    UIFont *font = [UIFont boldSystemFontOfSize: fontSize];
    CGRect textRect;
    UILineBreakMode breakMode = breakMode;
    CGSize textSize = [text sizeWithFont:font 
                             minFontSize:2.0 
                          actualFontSize:&fontSize
                                forWidth:mainRect.size.width * 0.8 
                           lineBreakMode:UILineBreakModeTailTruncation];
    font = [UIFont boldSystemFontOfSize: fontSize];
    textSize = [text sizeWithFont:font forWidth:textSize.width lineBreakMode:breakMode];
    textRect.size = textSize;
    textRect.origin = CGPointMake(CGRectGetMidX(mainRect)-(textSize.width/2), CGRectGetMidY(mainRect)-(font.lineHeight/2));
    textRect = CGRectIntegral(textRect);
    [text drawInRect:textRect withFont:font lineBreakMode:breakMode];
    CGContextRestoreGState(context);
    
    
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
    
    // draw gradient
    CGContextDrawLinearGradient(context, [self glossGradient], r.origin, 
                                                               CGPointMake(0.0, CGRectGetMaxY(glossRect)+2), 
                                                               kCGGradientDrawsBeforeStartLocation);
    CGContextRestoreGState(context);

    
    
}


@end
