//
//  PickController.h
//  HackatoN
//
//  Created by Artem Belkov on 26/03/16.
//  Copyright © 2016 Artem Belkov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface PickController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *countryImageView;
@property (weak, nonatomic) IBOutlet MKMapView *townMapView;

@end
