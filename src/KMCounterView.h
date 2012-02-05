//
//  KMDisclosueButtonView.h
//  Elements
//
//  Created by Kim Hunter on 4/02/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum KMGlossTypeEnum {
    KMGlossTypeNone = 0,
    KMGlossTypeConcave,
    KMGlossTypeConvex
} KMGlossType;


@interface KMCounterView : UIView
@property (nonatomic, retain) NSString *text;
@property (nonatomic, retain) UIColor *innerColor;
@property (nonatomic, retain) UIColor *outerColor;
@property (nonatomic, assign) KMGlossType glossType;

@property (readonly) UIImage *image;
+ (UIImage *)imageWithSize:(CGSize)size;
// if you don't want this adjusted for the screen then set change the frame in the block
+ (UIImage *)imageWithSize:(CGSize)size andBlock:(void (^)(KMCounterView *btnView))settingBlock;

@end
