//
//  Object.h
//  CoreData.HW
//
//  Created by Artem Belkov on 19/08/15.
//  Copyright © 2015 Artem Belkov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface Country : NSManagedObject

+ (Country *)addCountryWithName:(NSString *)name
                      countryID:(NSNumber *)countryID
                    temperature:(NSNumber *)temperature;

- (NSArray *)findTownsByID;

@end

NS_ASSUME_NONNULL_END

#import "Country+CoreDataProperties.h"
