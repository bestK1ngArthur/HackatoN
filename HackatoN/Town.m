//
//  User.m
//  CoreData.HW
//
//  Created by Artem Belkov on 19/08/15.
//  Copyright © 2015 Artem Belkov. All rights reserved.
//

#import "Town.h"
#import "DataManager.h"

@implementation Town

+ (Town *)addTownWithName:(NSString *)name
                   townID:(NSNumber *)townID
                countryID:(NSNumber *)countryID
                 latitude:(NSNumber *)latitude
                longitude:(NSNumber *)longitude {
    
    NSManagedObjectContext *managedObjectContext = [[DataManager sharedManager] managedObjectContext];
    
    Town *town = [NSEntityDescription insertNewObjectForEntityForName:@"Town"
                                                     inManagedObjectContext: managedObjectContext];
    
    town.name = name;
    
    town.townID = townID;
    town.countryID = countryID;
    
    town.latitude = latitude;
    town.longitude = longitude;
    
    return town;
}

- (NSString *)test {
    
   return @"Test";
}

@end
