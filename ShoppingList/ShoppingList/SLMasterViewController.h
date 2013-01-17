//
//  SLMasterViewController.h
//  ShoppingList
//
//  Created by pedro on 1/14/13.
//  Copyright (c) 2013 jpsilva's company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLMasterViewController : UITableViewController

@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property NSIndexPath *currentIndexPath;

@end
