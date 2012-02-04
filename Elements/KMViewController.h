//
//  KMViewController.h
//  Elements
//
//  Created by Kim Hunter on 2/02/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KMCounterView.h"

@interface KMViewController : UIViewController
@property (retain, nonatomic) IBOutlet UIImageView *imageView;
@property (retain, nonatomic) IBOutlet KMCounterView *numberButton;

@end
