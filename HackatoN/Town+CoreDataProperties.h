//
//  User+CoreDataProperties.h
//  CoreData.HW
//
//  Created by Artem Belkov on 19/08/15.
//  Copyright © 2015 Artem Belkov. All rights reserved.
//
//  Delete this file and regenerate it using "Create NSManagedObject Subclass…"
//  to keep your implementation up to date with your model.
//

#import "Town.h"

NS_ASSUME_NONNULL_BEGIN

@interface Town (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;

@property (nullable, nonatomic, retain) NSNumber *countryID;
@property (nullable, nonatomic, retain) NSNumber *townID;

@property (nullable, nonatomic, retain) NSNumber *latitude;
@property (nullable, nonatomic, retain) NSNumber *longitude;

@property (nullable, nonatomic, retain) NSNumber *temperature;
@property (nullable, nonatomic, retain) NSNumber *cost;

@property (nullable, nonatomic, retain) NSNumber *type;

@end

NS_ASSUME_NONNULL_END
