//
//  AppDelegate.m
//  HackatoN
//
//  Created by Artem Belkov on 25/03/16.
//  Copyright © 2016 Artem Belkov. All rights reserved.
//

#import "AppDelegate.h"

#import "Country.h"
#import "Town.h"

#import "DataManager.h"

@interface AppDelegate ()


@end

@implementation AppDelegate

+ (NSMutableDictionary *)sharedTemperatures {
    
    static NSMutableDictionary *temperatures = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        temperatures = [[NSMutableDictionary alloc] init];
        
    });
    
    return temperatures;
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    // Setting status bar
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    // Deleting all instances of entity
    /*
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Country"];
    NSBatchDeleteRequest *delete = [[NSBatchDeleteRequest alloc] initWithFetchRequest:request];
    
    NSError *deleteError = nil;
    [[DataManager sharedManager].persistentStoreCoordinator executeRequest:delete
                                                               withContext:[DataManager sharedManager].managedObjectContext
                                                                     error:&deleteError];
    
    request = [[NSFetchRequest alloc] initWithEntityName:@"Town"];
    delete = [[NSBatchDeleteRequest alloc] initWithFetchRequest:request];
    
    deleteError = nil;
    [[DataManager sharedManager].persistentStoreCoordinator executeRequest:delete
                                                               withContext:[DataManager sharedManager].managedObjectContext
                                                                     error:&deleteError];
     
    // Finding json file
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"TakeMeToTrip" ofType:@"json"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
        
        NSLog(@"Find json file");
        
        NSData *returnedData = [NSData dataWithContentsOfFile:filePath];
        NSDictionary *dictionary = [self parseJsonFromData:returnedData];
        
        // Parsing countries
        
        NSArray *countries = [dictionary objectForKey:@"countries"];
        NSArray *towns = [dictionary objectForKey:@"cities"];

        for (NSDictionary *townDict in towns) {
            
            NSNumber *townCountryID = [townDict objectForKey:@"countryId"];
            NSString *name = [townDict objectForKey:@"name"];
            
            NSLog(@"Parsing Town: %@", townCountryID);
            
            if (![name isEqualToString:@"0"]) {
                
                [Town addTownWithName:name
                               townID:[townDict objectForKey:@"id"]
                            countryID:townCountryID
                             latitude:[townDict objectForKey:@"latitude"]
                            longitude:[townDict objectForKey:@"longitude"]];
                
            }
            
        }
        
        for (NSDictionary *countryDict in countries) {
            
            NSNumber *countryID = [countryDict objectForKey:@"id"];
            
            NSLog(@"Parsing Country: %@", countryID);
            
            Country *country = [Country addCountryWithName:[countryDict objectForKey:@"name"]
                                                 countryID:countryID
                                               temperature:[countryDict objectForKey:@"temperature"]];
            
            NSArray * towns = [country findTownsByID];
            [country addTowns:[NSSet setWithArray:towns]];
        
        }
        
        NSError *error = nil;
        
        NSManagedObjectContext *managedObjectContext = [[DataManager sharedManager] managedObjectContext];
        
        if (![managedObjectContext save:&error]) {
            NSLog(@"%@", [error localizedDescription]);
        }
    
    } else {
        
        NSLog(@"Json file not found");
    
    }

    */
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
}

#pragma mark - Parsing

- (NSDictionary *)parseJsonFromData:(NSData *)data {
    
    if(NSClassFromString(@"NSJSONSerialization")) {
        
        NSError *error = nil;
        id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        if (error) { /* JSON was malformed, act appropriately here */ }
        
        // the originating poster wants to deal with dictionaries;
        // assuming you do too then something like this is the first
        // validation step:
        if ([object isKindOfClass:[NSDictionary class]]) {
            
            NSDictionary *results = object;
            /* proceed with results as you like; the assignment to
             an explicit NSDictionary * is artificial step to get
             compile-time checking from here on down (and better autocompletion
             when editing). You could have just made object an NSDictionary *
             in the first place but stylistically you might prefer to keep
             the question of type open until it's confirmed */
            
            return results;
            
        } else {
            
            /* there's no guarantee that the outermost object in a JSON
             packet will be a dictionary; if we get here then it wasn't,
             so 'object' shouldn't be treated as an NSDictionary; probably
             you need to report a suitable error condition */
            
            return nil;
        }
        
    } else {
        
        // the user is using iOS 4; we'll need to use a third-party solution.
        // If you don't intend to support iOS 4 then get rid of this entire
        // conditional and just jump straight to
        // NSError *error = nil;
        // [NSJSONSerialization JSONObjectWithData:...
        
        return nil;
    }
    
}

#pragma mark - Trash

- (NSArray *)townsForCountryID:(NSNumber *)countryID {
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Town"
                                              inManagedObjectContext:[DataManager sharedManager].managedObjectContext];
    [request setEntity:entity];
    // retrive the objects with a given value for a certain property
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"countryID == %@", countryID];
    [request setPredicate:predicate];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:[DataManager sharedManager].managedObjectContext sectionNameKeyPath:nil cacheName:@"Root"];
    aFetchedResultsController.delegate = self;
    
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
