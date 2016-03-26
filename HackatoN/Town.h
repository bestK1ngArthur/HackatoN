//
//  User.h
//  CoreData.HW
//
//  Created by Artem Belkov on 19/08/15.
//  Copyright © 2015 Artem Belkov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum {

    TownTypeTravel    = 0,
    TownTypeStill     = 1,
    TownTypeActive    = 2,
    TownTypeExtreme   = 3,
    TownTypeEducation = 4,
    TownTypeHealing   = 5
    
} TownType;

@interface Town : NSManagedObject

+ (Town *)addTownWithName:(NSString *)name
                   townID:(NSNumber *)townID
                countryID:(NSNumber *)countryID
                 latitude:(NSNumber *)latitude
                longitude:(NSNumber *)longitude;

+ (NSString *)stringFromType:(TownType)type;

@end

NS_ASSUME_NONNULL_END

#import "Town+CoreDataProperties.h"
