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
@synthesize categories;


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
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Categories" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError *error;
    self.categories = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    self.title = @"Categories";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return self.categories.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSArray *items = [self.categories[section] items];
    
    return items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    Categories *category = [self.categories objectAtIndex:indexPath.section];
    NSArray *items = [NSMutableArray arrayWithArray:[category.items allObjects]];
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
    Categories *category = [self.categories objectAtIndex:indexPath.section];
    NSArray *items = [NSMutableArray arrayWithArray:[category.items allObjects]];
    Items *item = items[indexPath.row];
    cell.textLabel.text = item.name;
    
    if([item.quantity floatValue] > 0.0)
        cell.backgroundColor = [UIColor colorWithRed:135.0/255 green:206.0/255 blue:250.0/255 alpha:1.0];
}

//name the sections
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.categories[section] name];
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
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
        NSLog(@"CATEGORIA:%@",category.name);
        
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
    
}

@end
