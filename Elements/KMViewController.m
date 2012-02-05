//
//  KMViewController.m
//  Elements
//
//  Created by Kim Hunter on 2/02/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import "KMViewController.h"
#import "KMCloseButtonView.h"
#import "KMCounterView.h"
#import <QuartzCore/QuartzCore.h>

@implementation KMViewController
{
    KMCounterView *counterView;
}
@synthesize imageView;
@synthesize numberButton;
@synthesize bigImageView;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGFloat lenWid = 600;
    counterView = [[KMCounterView alloc] initWithFrame:CGRectMake(80, 90, lenWid, lenWid)];
    [counterView setText:@"2"];
    [[self view] addSubview:counterView];
    bigImageView.image = [KMCounterView imageWithSize:bigImageView.bounds.size andBlock:^(KMCounterView *btnView) {
        btnView.glossType = KMGlossTypeConcave;
        btnView.text = @"M";
        btnView.innerColor = [UIColor colorWithRed:35.f/255.0 green:110.0f/255.0 blue:(CGFloat)216.f/255 alpha:1.0];
    }];

	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [self setImageView:nil];
    [self setNumberButton:nil];
    [self setBigImageView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    // Use defaults like this 
    //imageView.image = [KMCloseButtonView imageWithSize:imageView.frame.size];
    
    // or pass a bock in to setup the view
    imageView.image = [KMCloseButtonView imageWithSize:imageView.frame.size andBlock:^(KMCloseButtonView *btnView) {
        btnView.innerCircleColor = [UIColor redColor];
    }];
    numberButton.text = @"A";
    numberButton.glossType = KMGlossTypeConcave;
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [UIView animateWithDuration:1.0 animations:^{
        counterView.frame = CGRectApplyAffineTransform(CGRectApplyAffineTransform(counterView.frame, CGAffineTransformMakeTranslation(200, 20.0)), CGAffineTransformMakeScale(0.5, 0.5));
        counterView.alpha = 0.0;
    } completion:^(BOOL finished) {
        counterView.text = @"C";
        [UIView animateWithDuration:1.0 animations:^{
            counterView.alpha = 1.0;
        }];
    }];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)dealloc {
    [imageView release];
    [numberButton release];
    [bigImageView release];
    [super dealloc];
}
@end
