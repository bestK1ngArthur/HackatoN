//
//  Object.m
//  CoreData.HW
//
//  Created by Artem Belkov on 19/08/15.
//  Copyright © 2015 Artem Belkov. All rights reserved.
//

#import "Country.h"
#import "DataManager.h"

@implementation Country

+ (Country *)addCountryWithName:(NSString *)name
                      countryID:(NSNumber *)countryID
                    temperature:(NSNumber *)temperature {
    
    NSManagedObjectContext *managedObjectContext = [[DataManager sharedManager] managedObjectContext];
    
    Country *country = [NSEntityDescription insertNewObjectForEntityForName:@"Country"
                                                     inManagedObjectContext: managedObjectContext];
    
    country.name = name;
    country.countryID = countryID;
    
    country.cost = [NSNumber numberWithInteger:(arc4random() % 20000 + 10000)];
    
    if (temperature) {
        country.temperature = temperature;
    }
    
    return country;
}

- (NSArray *)findTownsByID {
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Town"
                                              inManagedObjectContext:[DataManager sharedManager].managedObjectContext];
    [request setEntity:entity];
    // retrive the objects with a given value for a certain property
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"countryID == %@", self.countryID];
    [request setPredicate:predicate];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:[DataManager sharedManager].managedObjectContext sectionNameKeyPath:nil cacheName:@"Root"];
    //aFetchedResultsController.delegate = self;
    
    NSError *error = nil;
    NSArray *result = [[DataManager sharedManager].managedObjectContext executeFetchRequest:request error:&error];
    
    if ((result != nil) && ([result count]) && (error == nil)){
        
        return [NSArray arrayWithArray:result];
        
    }
    else{
        
        /*
         Town *town = (Town *)[NSEntityDescription insertNewObjectForEntityForName:@"Town" inManagedObjectContext:[DataManager sharedManager].managedObjectContext];
         // setup your object attributes, for instance set its name
         town.name = @"name"
         
         // save object
         NSError *error;
         if (![[self managedObjectContext] save:&error]) {
         // Handle error
         NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
         
         }
         
         return object;
         */
        
        return nil;
        
    }
    
}

@end
