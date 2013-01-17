//
//  SLMasterViewController.m
//  ShoppingList
//
//  Created by pedro on 1/14/13.
//  Copyright (c) 2013 jpsilva's company. All rights reserved.
//

#import "SLMasterViewController.h"
#import "Categories.h"
#import "Items.h"
#import "Units.h"

@interface SLMasterViewController ()

@end

@implementation SLMasterViewController

@synthesize managedObjectContext;
@synthesize fetchedResultsController = _fetchedResultsController;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
		// Update to handle the error appropriately.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}
    
/*    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Categories" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError *error;
    self.categories = [managedObjectContext executeFetchRequest:fetchRequest error:&error];*/
    self.title = @"Categories";
}

- (void)viewDidUnload {
    self.fetchedResultsController = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Categories" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]
                              initWithKey:@"name" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    [fetchRequest setFetchBatchSize:20];
    
    NSFetchedResultsController *theFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:managedObjectContext sectionNameKeyPath:@"name"
                                                   cacheName:@"Root"];
    self.fetchedResultsController = theFetchedResultsController;
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections
    return [[[self fetchedResultsController] fetchedObjects] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSArray *categories = [[NSArray alloc] initWithArray:self.fetchedResultsController.fetchedObjects];

    NSArray *items = [categories[section] items];
    
    return items.count;
}

/*- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Categories *category = [_fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = category.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@, %@",
                                 category.name, category.name];
}*/


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Set up the cell...
    //[self configureCell:cell atIndexPath:indexPath];
    
    NSArray *categories = [[NSArray alloc] initWithArray:self.fetchedResultsController.fetchedObjects];
    id itemsSet = [categories[indexPath.section] items];
    NSArray *items = [[NSArray alloc] initWithArray:[itemsSet allObjects]  ];
    Items *item = items[indexPath.row];
    
    cell.textLabel.text = item.name;
    
    if([item.quantity floatValue] > 0.0)
        cell.detailTextLabel.text = [NSString stringWithFormat:@"On the list: %@ %@",item.quantity, item.unit.name];
    else
        cell.detailTextLabel.text = @"No order";
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Configure the cell...
    NSArray *categories = [[NSArray alloc] initWithArray:self.fetchedResultsController.fetchedObjects];
    id itemsSet = [categories[indexPath.section] items];
    NSArray *items = [[NSArray alloc] initWithArray:[itemsSet allObjects]  ];
    Items *item = items[indexPath.row];

    cell.textLabel.text = item.name;
    
    if([item.quantity floatValue] > 0.0)
        cell.backgroundColor = [UIColor colorWithRed:135.0/255 green:206.0/255 blue:250.0/255 alpha:1.0];
}

//name the sections
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    Categories *category = [[_fetchedResultsController sections] objectAtIndex:section];
    return category.name;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    
    
    self.currentIndexPath = indexPath;
    
    //lauch alert
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Hello!" message:@"Please enter the desired item's quantity:" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok",nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField * alertTextField = [alert textFieldAtIndex:0];
    alertTextField.keyboardType = UIKeyboardTypeDecimalPad;
    alertTextField.placeholder = @"Item quantity";
    [alert show];
}

/*- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    float quantity = 0;
    if (buttonIndex == 1) {
        //GET QUANTITY FROM ALERT
        quantity = [[[alertView textFieldAtIndex:0] text] floatValue];
    
        //GET SELECTED ITEM
        NSError *error;
        NSManagedObjectContext *context = [self managedObjectContext];
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription
                                       entityForName:@"Categories" inManagedObjectContext:context];
        [fetchRequest setEntity:entity];
        NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
        
        Categories *category = fetchedObjects[self.currentIndexPath.section];
        
        NSArray *items = [NSMutableArray arrayWithArray:[category.items allObjects]];
        Items *currentItem = items[self.currentIndexPath.row];

        //SET QUANTITY VALUE
        if(quantity > 0)
            currentItem.quantity = [NSNumber numberWithFloat:quantity];
        else
            currentItem.quantity = [NSNumber numberWithInt:0];
        
        //RELOAD CELL
        NSArray* indexArray = [NSArray arrayWithObjects:self.currentIndexPath, nil];
        [self.tableView reloadRowsAtIndexPaths:indexArray
                              withRowAnimation:UITableViewRowAnimationFade];
        //SAVE
        if (![context save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
    }
    
}*/

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
    [self.tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.tableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        //case NSFetchedResultsChangeUpdate:
        //   [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
        //    break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray
                                               arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray
                                               arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id )sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller has sent all current change notifications, so tell the table view to process all updates.
    [self.tableView endUpdates];
}

@end
