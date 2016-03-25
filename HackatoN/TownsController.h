//
//  ViewController.h
//  HackatoN
//
//  Created by Artem Belkov on 25/03/16.
//  Copyright © 2016 Artem Belkov. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CoreDataTableViewController.h"

@interface TownsController : UIViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (weak, nonatomic) IBOutlet UITableView *testTableView;

@end

