//
//  SLAppDelegate.m
//  ShoppingList
//
//  Created by pedro on 1/14/13.
//  Copyright (c) 2013 jpsilva's company. All rights reserved.
//

#import "SLAppDelegate.h"
#import "SLMasterViewController.h"
#import "Items.h"
#import "Units.h"
#import "Categories.h"

@implementation SLAppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    //[self deleteAllObjects:@"Categories"];
    //[self populateDatabase];
    
    
    //FETCH AND PRINT
    /*NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Categories" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    for (Categories *category in fetchedObjects) {
        NSLog(@"Category Name: %@ \n", category.name);
        
        NSArray *categoryItems = [category valueForKey:@"items"];
        for(Items *item in categoryItems){
            NSLog(@"Item Name: %@\n", item.name);
        }
    }*/
    
    
    // Override point for customization after application launch.
    UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
    SLMasterViewController *controller = (SLMasterViewController *)navigationController.topViewController;
    controller.managedObjectContext = self.managedObjectContext;
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"ShoppingList" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"ShoppingList.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

//MY METHODS


- (void) populateDatabase
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSError *error;
    
    //UNITS
    Units *unitKg = [NSEntityDescription insertNewObjectForEntityForName:@"Units" inManagedObjectContext:context];
    Units *unitg = [NSEntityDescription insertNewObjectForEntityForName:@"Units" inManagedObjectContext:context];
    Units *unitUnits = [NSEntityDescription insertNewObjectForEntityForName:@"Units" inManagedObjectContext:context];
    Units *unitL = [NSEntityDescription insertNewObjectForEntityForName:@"Units" inManagedObjectContext:context];
    Units *unitml = [NSEntityDescription insertNewObjectForEntityForName:@"Units" inManagedObjectContext:context];
    
    unitKg.name = @"Kg";
    unitg.name = @"g";
    unitUnits.name = @"units";
    unitL.name = @"L";
    unitml.name = @"ml";  
    
    //VEGETAIS
    Categories *category = [NSEntityDescription
                            insertNewObjectForEntityForName:@"Categories"
                            inManagedObjectContext:context];
    category.name = @"Vegetables";
    
    Items *item = [NSEntityDescription insertNewObjectForEntityForName:@"Items" inManagedObjectContext:context];
    Items *item1 = [NSEntityDescription insertNewObjectForEntityForName:@"Items" inManagedObjectContext:context];
    Items *item2 = [NSEntityDescription insertNewObjectForEntityForName:@"Items" inManagedObjectContext:context];

    item.name = @"Carrot";
    [unitKg addItemsObject:item];
    [category addItemsObject:item];
    item1.name = @"Onion";
    [unitKg addItemsObject:item1];
    [category addItemsObject:item1];
    item2.name = @"Cabbage";
    [unitKg addItemsObject:item2];
    [category addItemsObject:item2];

    //FRUITS
    Categories *category2 = [NSEntityDescription
                            insertNewObjectForEntityForName:@"Categories"
                            inManagedObjectContext:context];
    category2.name = @"Fruits";
    Items *item3 = [NSEntityDescription insertNewObjectForEntityForName:@"Items"
                                                inManagedObjectContext:context];
    Items *item4 = [NSEntityDescription insertNewObjectForEntityForName:@"Items"
                                                 inManagedObjectContext:context];
    Items *item5 = [NSEntityDescription insertNewObjectForEntityForName:@"Items"
                                                 inManagedObjectContext:context];
    item3.name = @"Peach";
    [unitKg addItemsObject:item3];
    [category2 addItemsObject:item3];
    item4.name = @"Apple";
    [unitKg addItemsObject:item4];
    [category2 addItemsObject:item4];
    item5.name = @"Banana";
    [unitKg addItemsObject:item5];
    [category2 addItemsObject:item5];   
    
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
}

- (void) deleteAllObjects: (NSString *) entityDescription  {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityDescription inManagedObjectContext:[self managedObjectContext]];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *items = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    for (NSManagedObject *managedObject in items) {
    	[_managedObjectContext deleteObject:managedObject];
    	NSLog(@"%@ object deleted",entityDescription);
    }
    if (![_managedObjectContext save:&error]) {
    	NSLog(@"Error deleting %@ - error:%@",entityDescription,error);
    }
    
}


#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}





@end
