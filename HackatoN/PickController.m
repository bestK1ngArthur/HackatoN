//
//  PickController.m
//  HackatoN
//
//  Created by Artem Belkov on 26/03/16.
//  Copyright © 2016 Artem Belkov. All rights reserved.
//

#import "PickController.h"

#import <CoreMotion/CoreMotion.h>

#import "DataManager.h"

#import "Town.h"
#import "Country.h"

#define kUpdateInterval (1.0f / 60.0f)

@interface PickController () <MKMapViewDelegate>

@property (assign, nonatomic) CGFloat angle;
@property (assign, nonatomic) CMAcceleration acceleration;
@property (strong, nonatomic) CMMotionManager  *motionManager;
@property (strong, nonatomic) NSOperationQueue *queue;
@property (strong, nonatomic) NSDate *lastUpdateTime;

@property (strong, nonatomic) NSArray *countries;
@property (strong, nonatomic) NSNumber *currentCountryID;
@property (strong, nonatomic) NSArray *towns;

@end

@implementation PickController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.lastUpdateTime = [[NSDate alloc] init];
    
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
    
    [self.townButton addTarget:self action:@selector(townButtonBeginTouchRecord:) forControlEvents:UIControlEventTouchDown];
    [self.townButton addTarget:self action:@selector(townButtonEndTouch:) forControlEvents:UIControlEventTouchUpInside];
    [self.townButton addTarget:self action:@selector(townButtonEndTouch:) forControlEvents:UIControlEventTouchCancel];
    
    [self loadCountries];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - CoreData

- (BOOL)loadCountries {
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Country" inManagedObjectContext:[DataManager sharedManager].managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchBatchSize:1];
    NSError *error;
    NSMutableArray *mutableFetchResults = [[[DataManager sharedManager].managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
    
    if (mutableFetchResults == nil) {
        
        return NO;
        
    } else {
        
        [self setCountries:mutableFetchResults];
        
        return YES;
    }
    
}

- (BOOL)loadTowns {
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Town" inManagedObjectContext:[DataManager sharedManager].managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate  = [NSPredicate predicateWithFormat:@"countryID == %@", self.currentCountryID];
    [fetchRequest setPredicate:predicate];
    
    NSError *error;
    NSMutableArray *mutableFetchResults = [[[DataManager sharedManager].managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
    
    if (mutableFetchResults == nil) {
        
        return NO;
        
    } else {
        
        [self setTowns:mutableFetchResults];
        
        return YES;
    }
    
}

#pragma mark - Motion

- (void)update {
    
    double shift = self.acceleration.x*self.acceleration.x + self.acceleration.y*self.acceleration.y + self.acceleration.z*self.acceleration.z;
    
    if ((arc4random() % (int)(shift)) > (arc4random() % (int)(shift/2))) {
        
        if ((self.countryButton.highlighted == YES) && (shift > 2)) {
            
            int index = arc4random() % [self.countries count];
            Country *country = [self.countries objectAtIndex:index];
            self.currentCountryID = country.countryID;
            
            self.countryLabel.text = country.name;
            self.costLabel.text = [NSString stringWithFormat:@"%@₽", [country.cost stringValue]];
            self.countryImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.gif", [country.countryID stringValue]]];
            
            if ([country.temperature doubleValue]) {
                self.temperatureLabel.text = [NSString stringWithFormat:@"%.1f°C", [country.temperature doubleValue]];
            }
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self loadTowns];
                
                if (self.towns) {
                    
                    int index = arc4random() % [self.towns count];
                    Town *town = [self.towns objectAtIndex:index];
                    
                    self.townLabel.text = town.name;
                    self.typeLabel.text = [Town stringFromType:(TownType)[town.type integerValue]];
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        
                        [self zoomTownToLocation:town];
                        
                    });
                }
                
            });
            
            
        } else if ((self.townButton.highlighted == YES) && (shift > 2)) {
            
            if (self.towns) {
                
                int index = arc4random() % [self.towns count];
                Town *town = [self.towns objectAtIndex:index];
                
                self.townLabel.text = town.name;
                self.typeLabel.text = [Town stringFromType:(TownType)[town.type integerValue]];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [self zoomTownToLocation:town];
                    
                });
            }
            
        }
        
    }
    
}

#pragma mark - Map

- (void)zoomTownToLocation:(Town *)town {
    
    float spanX = 0.18725;
    float spanY = 0.18725;
    MKCoordinateRegion region;
    region.center.latitude = [town.latitude doubleValue];
    region.center.longitude = [town.longitude doubleValue];
    region.span.latitudeDelta = spanX;
    region.span.longitudeDelta = spanY;
    
    [self.townMapView setRegion:region animated:YES];
}

#pragma mark - Touches

- (void)countryButtonBeginTouchRecord:(id)sender {
    
    self.countryButton.highlighted = YES;
    self.countryLabel.textColor = [UIColor lightTextColor];
    
}

- (void)countryButtonEndTouch:(id)sender {
    
    self.countryButton.highlighted = NO;
    self.countryLabel.textColor = [UIColor whiteColor];
    
}

- (void)townButtonBeginTouchRecord:(id)sender {
    
    self.townButton.highlighted = YES;
    self.townLabel.textColor = [UIColor colorWithRed: 197 /255.f
                                               green: 229 /255.f
                                                blue: 252 /255.f
                                               alpha: 1.f];

    
}

- (void)townButtonEndTouch:(id)sender {
    
    self.townButton.highlighted = NO;
    self.townLabel.textColor = [UIColor colorWithRed: 122 /255.f
                                               green: 170 /255.f
                                                blue: 225 /255.f
                                               alpha: 1.f];
    
}

@end
