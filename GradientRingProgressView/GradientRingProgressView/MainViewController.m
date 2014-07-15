//
//  MainViewController.m
//  GradientRingProgressView
//
//  Created by Robert Pankrath on 15.07.14.
//  Copyright (c) 2014 Robert Pankrath. All rights reserved.
//

#import "MainViewController.h"
#import "GradientRingProgressView.h"
@interface MainViewController ()

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    GradientRingProgressView *circleView = [[GradientRingProgressView alloc] initWithFrame:CGRectInset(self.view.bounds, 15, 15)];
    [self.view addSubview:circleView];
    [circleView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(circleViewTapped:)]];
}

- (void)circleViewTapped:(UIGestureRecognizer*)rec{
    GradientRingProgressView *v = (GradientRingProgressView*)rec.view;
    v.progress = (arc4random()%100)/100.;
}


@end
