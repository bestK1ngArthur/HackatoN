//
//  User.m
//  CoreData.HW
//
//  Created by Artem Belkov on 19/08/15.
//  Copyright © 2015 Artem Belkov. All rights reserved.
//

#import "Town.h"
#import "DataManager.h"

#import "AFNetworking.h"

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
    town.type = [NSNumber numberWithInt:(arc4random() % 6)];
    
    town.townID = townID;
    town.countryID = countryID;
    
    town.latitude = latitude;
    town.longitude = longitude;
        
    return town;
}

+ (NSString *)stringFromType:(TownType)type {
    
    if (type == TownTypeTravel) {
        
        return @"travel";
        
    } else if (type == TownTypeStill) {
        
        return @"still";
        
    } else if (type == TownTypeActive) {
        
        return @"active";
        
    } else if (type == TownTypeExtreme) {
        
        return @"extreme";
        
    } else if (type == TownTypeEducation) {
        
        return @"education";
        
    } else if (type == TownTypeHealing) {
        
        return @"healing";
    }
    
    return @"";
}

@end
