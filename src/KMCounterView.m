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
@synthesize innerColor = _innerColor;
@synthesize outerColor = _outerColor;
@synthesize convexShadow;

- (void)defaultSettings
{
    [self setClearsContextBeforeDrawing:YES];
    self.backgroundColor = [UIColor clearColor];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self defaultSettings];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self)
    {
        [self defaultSettings];
    }
    return self;
}

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
    [_innerColor release];
    [_outerColor release];
    [super dealloc];
}

- (void)drawTextCenteredInRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    [(_outerColor ?: [UIColor whiteColor]) setFill];
    CGContextSetShadow(context, CGSizeMake(0.0, -1.0), 0.0);
    
    CGFloat fontSize = floorf(rect.size.height * 0.76);
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
    textRect.origin = CGPointMake(CGRectGetMidX(rect)-(textSize.width/2), CGRectGetMidY(rect)-(font.lineHeight/2));
    textRect = CGRectIntegral(textRect);
    [_text drawInRect:textRect withFont:font lineBreakMode:breakMode];
    CGContextRestoreGState(context);
}
#define insetPercentage 0.1f
#define COLOR2PERC(c) ((CGFloat)((c)/255))
#define D2R(D)  ((D)*(M_PI/180))
#define  OPPOSITE_SIDE_SIZE(Hyp, Ang) (sinf(Ang) * (Hyp))
#define  ADJCENT_SIDE_SIZE(Hyp, Ang) (cosf(Ang) * (Hyp))

- (void)drawGlossInRect:(CGRect)mainRect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(context);
    CGContextBeginPath(context); 
    CGRect glossRect = self.bounds;
    CGRect outerClipRect = CGRectInset(mainRect, mainRect.size.width * insetPercentage * -0.8/2, mainRect.size.width * insetPercentage * -0.8/2);

    
    // Setup Gradient
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locs[] = {0.0f, 1.0f};
    CGColorRef colorRefs[] = {  [[UIColor colorWithWhite:1.0 alpha:0.8] CGColor],
        [[UIColor colorWithWhite:1.0 alpha:0.2] CGColor]};
    CFArrayRef colors = CFArrayCreate(NULL, (const void**)colorRefs, sizeof(colorRefs) / sizeof(CGColorRef), &kCFTypeArrayCallBacks);
    CGGradientRef glossGradient = CGGradientCreateWithColors(colorSpace, colors, locs);
    CGColorSpaceRelease(colorSpace);
    CFRelease(colors);

    if (convexShadow)
    {
        glossRect = CGRectIntegral(CGRectInset(glossRect, glossRect.size.width * -0.3, glossRect.size.height * -0.3));
        glossRect.origin.y = roundf((CGRectGetMidY(mainRect) * 1.3) - glossRect.size.height);
        
        // build intersection of both circles as the clip mask
        CGContextAddEllipseInRect(context, glossRect);
        CGContextClip(context);
        // this rect is on the outsid of the border circle
        CGContextAddEllipseInRect(context, outerClipRect);
        CGContextClip(context);
        
        
        // draw gradient
        CGContextDrawLinearGradient(context, glossGradient, CGPointZero, CGPointMake(0.0, CGRectGetMaxY(glossRect)+2), kCGGradientDrawsBeforeStartLocation);    
    }
    else
    {
        CGPoint a, b;
        CGFloat startPointIntAngle = 10.0;
        CGFloat oppositeSideLen = OPPOSITE_SIDE_SIZE(mainRect.size.width/2, D2R(startPointIntAngle));
        CGFloat adjcentLen = ADJCENT_SIDE_SIZE(mainRect.size.width/2, D2R(startPointIntAngle));
        a.y = b.y = CGRectGetMidY(mainRect) + oppositeSideLen;
        a.x = CGRectGetMidX(mainRect) - adjcentLen;
        b.x = CGRectGetMidX(mainRect) + adjcentLen;    
        [[UIColor grayColor] setStroke];
        CGContextAddArc(context, CGRectGetMidX(mainRect), CGRectGetMidY(mainRect), mainRect.size.width/2, D2R(startPointIntAngle), D2R(180-startPointIntAngle), YES);
        CGContextAddCurveToPoint(context, a.x, a.y, CGRectGetMidX(mainRect), CGRectGetMidY(mainRect) * 0.5, b.x, b.y);
        CGContextClosePath(context);
        CGContextClip(context);
        
        CGContextDrawLinearGradient(context, glossGradient, CGPointMake(0.0, 0.0), CGPointMake(0.0, CGRectGetMaxY(mainRect)-(mainRect.size.height*0.2)), kCGGradientDrawsBeforeStartLocation);

    }
    
    CGGradientRelease(glossGradient);
    CGContextRestoreGState(context);

    
    
}
#define COLOR_CoolBlue [UIColor colorWithRed:COLOR2PERC(35.f) green:COLOR2PERC(110.0f) blue:COLOR2PERC(216.f) alpha:1.0]
#define COLOR2PERC(c) ((CGFloat)((c)/255))

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetAllowsAntialiasing(context, YES);
    
    CGRect r = self.bounds;
    CGRect mainRect = CGRectIntegral(CGRectInset(r, r.size.width*insetPercentage, r.size.height*insetPercentage));
    mainRect.origin.y /= 2;  // shift up so shadow isn't cut at bottom
    
    [(_outerColor ?: [UIColor whiteColor]) setStroke];
    [(_innerColor ?: [UIColor redColor]) setFill];
    CGContextSetLineWidth(context, mainRect.size.width * insetPercentage * 0.8);

    CGContextSaveGState(context);
    CGContextSetShadow(context, CGSizeMake(0.0, (r.size.width-mainRect.size.width)/5), (r.size.width-mainRect.size.width)/3);
    CGContextAddEllipseInRect(context, mainRect);
    CGContextDrawPath(context, kCGPathFillStroke);
    CGContextRestoreGState(context);
    
    if ([_text length] != 0)
    {
        [self drawTextCenteredInRect:mainRect];
    }
    
    // ===== Apply Gloss =====
    [self drawGlossInRect:mainRect];
}



@end
