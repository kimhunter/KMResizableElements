//
//  KMCloseButtonView.h
//  KMResizableElements
//
//  Created by Kim Hunter on 2/02/12.
//  Copyright (c) 2012 Kim Hunter. All rights reserved.
// 

#import <UIKit/UIKit.h>

@interface KMCloseButtonView : UIView

@property (nonatomic, retain) UIColor *outerCircleColor;
@property (nonatomic, retain) UIColor *innerCircleColor;
@property (nonatomic, retain) UIColor *crossColor;
@property (nonatomic, assign) BOOL drawShadow;

@property (readonly) UIImage *image;

+ (UIImage *)imageWithSize:(CGSize)size;
//pass a block in to setup the colors/shadow blah
+ (UIImage *)imageWithSize:(CGSize)size andBlock:(void (^)(KMCloseButtonView *btnView))settingBlock;
@end
