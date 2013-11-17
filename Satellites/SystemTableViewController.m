//
//  SystemTableViewController.m
//  Satellites
//
//  Created by Richard Benjamin Heidorn on 5/19/13.
//  Copyright (c) 2013 Richard B Heidorn. All rights reserved.
//

#import "SystemTableViewController.h"
#import "RootViewController.h"
#import "SystemObject.h"
#import "SystemDetailsViewController.h"

@implementation SystemTableViewController

@synthesize systemsArray;

- (void) setConfig
{
    bShowAddButton = false;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    // Set the title.
    self.title = @"Star Systems";
}

// Handle reloading the table data
- (void)viewWillAppear:(BOOL)animated
{
    // Load the systems
    [self loadSystemsToTable];
    
    [super viewWillAppear:animated];
}

// Load systems to view
- (void) loadSystemsToTable
{
    // Prepare the request to get all Systems
    NSFetchRequest      * request = [[NSFetchRequest alloc] init];
    NSEntityDescription * entity = [NSEntityDescription entityForName:@"SystemObject" inManagedObjectContext:managedObjectContext];
    [request setEntity:entity];
    
    // Set the sort
    NSSortDescriptor * alphabeticalSort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:true];
    NSArray * sortDescriptors = [[NSArray alloc] initWithObjects:alphabeticalSort, nil];
    [request setSortDescriptors:sortDescriptors];
    
    // Submit the request
    NSError * error = nil;
    NSMutableArray * mutableFetchResults = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    
    // Handle any errors
    if (mutableFetchResults == nil)
    {
        // Handle the error.
    }
    
    // Load the data to view
    [self setSystemsArray : mutableFetchResults];
}

// Edit Handler for Edit button selection
- (void) editHandler
{
    [self editSystem];
}

// Edit a system
- (void) editSystem
{
    // Go to the edit page
    [self performSegueWithIdentifier: @"EditSelectedSystem" sender: self];
}

// Selecting a row
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Segue to adding a satellite
    if (indexPath.section == 0 && indexPath.row == [systemsArray count])
    {
        [self performSegueWithIdentifier:@"AddSystem" sender:self];
    }
}

#pragma mark - Segue management

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"AddSystem"])
    {
        // Create and configure a new instance of the Event entity.
        SystemObject * system = (SystemObject *)[NSEntityDescription insertNewObjectForEntityForName:@"SystemObject" inManagedObjectContext:managedObjectContext];
        
        // Set default information
        [system setName : @"Untitled System"];
        
        // Save the default information
        NSError *error = nil;
        if (![managedObjectContext save : &error])
        {
            // Handle the error.
        }
        
        // Pass the selected book to the new view controller.
        SystemDetailsViewController * detailViewController = (SystemDetailsViewController *) [segue destinationViewController];
        detailViewController.system = system;
    }
    else if ([[segue identifier] isEqualToString:@"EditSelectedSystem"])
    {
        // Get the selected system
        NSIndexPath  * indexPath = [self.tableView indexPathForSelectedRow];
        SystemObject * selectedSystem = (SystemObject *) [systemsArray objectAtIndex:indexPath.row];
        
        // Pass the selected book to the new view controller.
        SystemDetailsViewController * detailViewController = (SystemDetailsViewController *) [segue destinationViewController];
        detailViewController.system = selectedSystem;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [systemsArray count] + 1; // Num systems + Add New System
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Initialize the cell and info
    UITableViewCell * cell = nil;
    NSString        * cellIdentifier = @"systemCell";
    NSString        * cellDetailText = @"";
    NSString        * cellLabelText  = @"";
    NSInteger         cellStyle      = UITableViewCellStyleSubtitle;
    
    // Last row, add option
    if (indexPath.row == [systemsArray count]) // Add Row
    {
        cellIdentifier = @"addSystemCell";
        cellLabelText  = @"Add New System";
        cellDetailText = @"+";
        cellStyle      = UITableViewCellStyleValue1;
    }
    // Otherwise, this is a system
    else
    {
        // Get the system
        SystemObject * system = (SystemObject *) [systemsArray objectAtIndex: indexPath.row];
        
        // System name
        cellLabelText  = [system name];
        
        // Display the number of stars, planets and moons
        cellDetailText = [[system numStarsAsString] stringByAppendingString:@" - "];
        cellDetailText = [cellDetailText stringByAppendingString:[[system numPlanetsAsString] stringByAppendingString:@" - "]];
        cellDetailText = [cellDetailText stringByAppendingString:[system numMoonsAsString]];
    }
    
    // Get the table cell
    cell = [tableView dequeueReusableCellWithIdentifier: cellIdentifier];
    
    // Create a new cell
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:cellStyle reuseIdentifier: cellIdentifier];
    }
    
    // Assign the label text
    cell.detailTextLabel.text = cellDetailText;
    cell.textLabel.text       = cellLabelText;
    
    return cell;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        // Delete the managed object at the given index path.
        NSManagedObject * systemToDelete = [systemsArray objectAtIndex:indexPath.row];
        [managedObjectContext deleteObject:systemToDelete];
        
        // Update the array and table view.
        [systemsArray removeObjectAtIndex:indexPath.row];
        
        // Commit the change.
        NSError *error = nil;
        if (![managedObjectContext save:&error])
        {
            // Handle the error.
        }

        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)viewDidUnload
{
    systemsArray = nil;
}

@end
