//
//  PickController.m
//  HackatoN
//
//  Created by Artem Belkov on 26/03/16.
//  Copyright © 2016 Artem Belkov. All rights reserved.
//

#import "PickController.h"
#import <CoreMotion/CoreMotion.h>

#define kUpdateInterval (1.0f / 60.0f)

@interface PickController ()

@property (assign, nonatomic) CGPoint currentPoint;
@property (assign, nonatomic) CGPoint previousPoint;
@property (assign, nonatomic) CGFloat pacmanXVelocity;
@property (assign, nonatomic) CGFloat pacmanYVelocity;
@property (assign, nonatomic) CGFloat angle;
@property (assign, nonatomic) CMAcceleration acceleration;
@property (strong, nonatomic) CMMotionManager  *motionManager;
@property (strong, nonatomic) NSOperationQueue *queue;
@property (strong, nonatomic) NSDate *lastUpdateTime;

@end

@implementation PickController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.lastUpdateTime = [[NSDate alloc] init];
    
    self.currentPoint  = CGPointMake(0, 144);
    self.motionManager = [[CMMotionManager alloc]  init];
    self.queue         = [[NSOperationQueue alloc] init];
    
    self.motionManager.accelerometerUpdateInterval = kUpdateInterval;
    
    [self.motionManager startAccelerometerUpdatesToQueue:self.queue withHandler:
     ^(CMAccelerometerData *accelerometerData, NSError *error) {
         [(id) self setAcceleration:accelerometerData.acceleration];
         [self performSelectorOnMainThread:@selector(update) withObject:nil waitUntilDone:NO];
     }];
    
    [self.countryButton addTarget:self action:@selector(countryButtonBeginTouchRecord:) forControlEvents:UIControlEventTouchDown];
    [self.countryButton addTarget:self action:@selector(countryButtonEndTouch:) forControlEvents:UIControlEventTouchUpInside];
    [self.countryButton addTarget:self action:@selector(countryButtonEndTouch:) forControlEvents:UIControlEventTouchCancel];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Motion

- (void)update {
    
}


#pragma mark - Touches

- (void)countryButtonBeginTouchRecord:(id)sender {
    
    self.countryButton.titleLabel.text = @"Pressed";
    
}

- (void)countryButtonEndTouch:(id)sender {
    
    self.countryButton.titleLabel.text = @"No";
    
}

@end
