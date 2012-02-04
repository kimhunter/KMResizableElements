//
//  KMDisclosueButtonView.h
//  Elements
//
//  Created by Kim Hunter on 4/02/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KMDisclosueButtonView : UIView

@property (nonatomic, retain) NSTimer *timer;
@property (nonatomic, assign) NSInteger number;
- (void)updateNumber;

@end
