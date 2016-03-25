//
//  Object+CoreDataProperties.h
//  CoreData.HW
//
//  Created by Artem Belkov on 19/08/15.
//  Copyright © 2015 Artem Belkov. All rights reserved.
//
//  Delete this file and regenerate it using "Create NSManagedObject Subclass…"
//  to keep your implementation up to date with your model.
//

#import "Country.h"

NS_ASSUME_NONNULL_BEGIN

@interface Country (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSNumber *countryID;

@property (nullable, nonatomic, retain) NSSet<NSManagedObject *> *towns;

@end

@interface Country (CoreDataGeneratedAccessors)

- (void)addTownsObject:(NSManagedObject *)value;
- (void)removeTownsObject:(NSManagedObject *)value;
- (void)addTowns:(NSSet<NSManagedObject *> *)values;
- (void)removeTowns:(NSSet<NSManagedObject *> *)values;

@end

NS_ASSUME_NONNULL_END
