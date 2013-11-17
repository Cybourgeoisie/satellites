//
//  SystemDetailsViewController.m
//  Satellites
//
//  Created by Richard Benjamin Heidorn on 5/26/13.
//  Copyright (c) 2013 Richard B Heidorn. All rights reserved.
//

#import "SystemDetailsViewController.h"
#import "RootViewController.h"
#import "EditingViewController.h"
#import "SatelliteDetailsViewController.h"
#import "SatellitesViewController.h"

#define SECTION_DETAILS 0
#define SECTION_STARS   1
#define SECTION_PLANETS 2
#define NUM_SECTIONS    3

@implementation SystemDetailsViewController

@synthesize system;

- (void) setConfig
{
    bShowAddButton = false;
}

- (void) setToolbar
{
    // Create buttons
    UIBarButtonItem * playButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(viewSatellites)];
    
    // Flexible
    UIBarButtonItem * flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    // Set the toolbar items
    self.toolbarItems = [NSArray arrayWithObjects: flexibleSpace, playButton, flexibleSpace, nil];
}

- (void) setToolbarVisibility
{
    // Make sure that we can see the toolbar
    self.navigationController.toolbarHidden = false;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Configure the title, title bar, and table view.
    self.title = @"System Details";
}

// Get the number of stars and planets
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
}

// Selecting a row
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Segue to adding a satellite
    if ((indexPath.section == SECTION_STARS   && indexPath.row == [system numStars]) ||
        (indexPath.section == SECTION_PLANETS && indexPath.row == [system numPlanets]))
    {
        [self performSegueWithIdentifier:@"AddNewBody" sender:self];
    }
}

// Edit Handler for Edit button selection
- (void) editHandler
{
    // Get the index, determine which seque to use
    NSIndexPath * indexPath = [self.tableView indexPathForSelectedRow];
    
    // Edit the selected item
    if (indexPath.section == SECTION_DETAILS)
    {
        [self performSegueWithIdentifier:@"EditSelectedItem" sender:self];
    }
    else if (indexPath.section == SECTION_STARS || indexPath.section == SECTION_PLANETS)
    {
        [self performSegueWithIdentifier:@"EditSelectedBody" sender:self];
    }
}

// Handle Segues
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the index path
    NSIndexPath * indexPath = [self.tableView indexPathForSelectedRow];
    
    if ([[segue identifier] isEqualToString:@"EditSelectedItem"])
    {
        // Prepare the Editing View Controller
        EditingViewController * controller = (EditingViewController *)[segue destinationViewController];
        
        // Set the object
        controller.editedObject = self.system;
        
        // Given a particular row, allow certain editing to occur
        switch (indexPath.row)
        {
            case 0:
            default: {
                controller.editedFieldKey = @"name";
                controller.editedFieldName = NSLocalizedString(@"System Name", @"Display system name");
            } break;
        }
    }
    // Edit a Satellite - Star or Planet
    else if ([[segue identifier] isEqualToString:@"EditSelectedBody"])
    {
        // Prepare the Editing View Controller
        SatelliteDetailsViewController * controller = (SatelliteDetailsViewController *)[segue destinationViewController];
        
        // Prepare the satellite
        SatelliteObject * satellite  = nil;
        
        // Stars
        if (indexPath.section == SECTION_STARS)
        {
            NSArray * satellites = [[system getStars] allObjects];
            satellite = [satellites objectAtIndex:indexPath.row];
        }
        // Planet
        else
        {
            NSArray * satellites = [[system getPlanets] allObjects];
            satellite = [satellites objectAtIndex:indexPath.row];
        }
        
        // Set the object
        controller.satellite = satellite;
    }
    // Add a Satellite - Star or Planet
    else if ([[segue identifier] isEqualToString:@"AddNewBody"])
    {
        // Prepare the Editing View Controller
        SatelliteDetailsViewController * controller = (SatelliteDetailsViewController *)[segue destinationViewController];
        
        // Create and configure a new instance of the Event entity.
        SatelliteObject * satellite = (SatelliteObject *)[NSEntityDescription insertNewObjectForEntityForName:@"SatelliteObject" inManagedObjectContext:managedObjectContext];
        
        // Stars
        if (indexPath.section == SECTION_STARS)
        {
            [satellite setName : @"New Star"];
            [satellite setBStar:[NSNumber numberWithBool:true]];
        }
        // Planet
        else
        {
            [satellite setName : @"New Planet"];
        }
        
        // Save the default information
        NSError *error = nil;
        if (![managedObjectContext save : &error])
        {
            // Handle the error.
        }
        
        // Add the satellite to the system
        [system addSatellitesObject: satellite];

        // Set the object
        controller.satellite = satellite;
    }
    // View the system in the Satellites view
    else if ([[segue identifier] isEqualToString:@"ViewSatellites"])
    {
        // Seque to the Satellites controller
        SatellitesViewController * controller = (SatellitesViewController *)[segue destinationViewController];
        
        // Set the system
        [controller setSystem: system];
    }
    
    // Reset the right-side button
    self.navigationItem.rightBarButtonItem = nil;
}

- (void) viewSatellites
{
    // Perform the segue to the satellites view controller
    [self performSegueWithIdentifier:@"ViewSatellites" sender:self];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Total number of sections reflects static content
    // Static: System Details
    // And dynamic content
    // Dynamic: Stars, Planets
    
    // If we don't have stars, then don't show the last section (planets)
    return NUM_SECTIONS - ![system numStars];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == SECTION_DETAILS)
    {
        return @"System Details";
    }
    else if (section == SECTION_STARS)
    {
        return @"Stars";
    }
    else if (section == SECTION_PLANETS)
    {
        return @"Planets";
    }
    
    return @"Section Name Not Found";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Details
    if (section == SECTION_DETAILS)
    {
        return 1; // Static cells: Name
    }
    // Stars
    else if (section == SECTION_STARS)
    {
        return [system numStars] < 2 ? [system numStars] + 1 : 2; // Num Stars + Add New Star
    }

    // Planets
    return [system numPlanets] + 1; // Num Planets + Add New Planet (Only if we have stars)
}

-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    // Initialize the cell and info
    UITableViewCell * cell = nil;
    NSString        * cellIdentifier = nil;
    NSString        * cellDetailText = @"";
    NSString        * cellLabelText  = @"";
    NSInteger         cellStyle      = UITableViewCellStyleValue2;
    
    // Static Cells
    if (indexPath.section == SECTION_DETAILS)
    {
        cellIdentifier = @"systemDetailCell";
        cellLabelText  = @"Name";
        cellDetailText = system.name;
    }
    // Stars
    else if (indexPath.section == SECTION_STARS)
    {
        if ([system numStars] > 0 && indexPath.row < [system numStars])
        {
            // Get the satellite
            NSArray         * satellites = [[system getStars] allObjects];
            SatelliteObject * satellite  = [satellites objectAtIndex:indexPath.row];
            
            cellIdentifier = @"systemStarCell";
            cellLabelText  = @"Star";
            cellDetailText = satellite.name;
        }
        
        // Last row, add option
        if (indexPath.row == [system numStars]) // Add Row
        {
            cellIdentifier = @"addSystemStarCell";
            cellLabelText  = @"Add New Star";
            cellDetailText = @"+";
            cellStyle      = UITableViewCellStyleValue1;
        }
    }
    // Planets
    else if (indexPath.section == SECTION_PLANETS)
    {
        if ([system numPlanets] > 0 && indexPath.row < [system numPlanets])
        {
            // Get the satellite
            NSArray         * satellites = [[system getPlanets] allObjects];
            SatelliteObject * satellite  = [satellites objectAtIndex:indexPath.row];
            
            cellIdentifier = @"systemPlanetCell";
            cellLabelText  = @"Planet";
            cellDetailText = satellite.name;
        }
        
        // Last row, add option
        if (indexPath.row == [system numPlanets]) // Add Row
        {
            cellIdentifier = @"addSystemPlanetCell";
            cellLabelText  = @"Add New Planet";
            cellDetailText = @"+";
            cellStyle      = UITableViewCellStyleValue1;
        }
    }
    
    // Create the cell
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    // Ensure creation
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:cellStyle reuseIdentifier:cellIdentifier];
    }
    
    // Assign the label text
    cell.detailTextLabel.text = cellDetailText;
    cell.textLabel.text       = cellLabelText;
    
    // Return the formatted cell
    return cell;
}

// Override to support editing the table view.
- (UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Only allow deletion for certain sections
    if (//(indexPath.section == SECTION_STARS && indexPath.row != [system numStars]) || // TODO: Enable for stars
        (indexPath.section == SECTION_PLANETS && indexPath.row != [system numPlanets]))
    {
        return UITableViewCellEditingStyleDelete;
    }

    // No editing style
    return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        // Define the objects array to use
        NSArray * objects = nil;
        
        // Determine if we're removing a star or a planet
        if (indexPath.section == SECTION_STARS)
        {
            //objects = [[system getStars] allObjects];
            return; // TODO -- we run into UI errors while deleting stars,
            // due to the variable numbers of sections or rows depending
            // on the stars... So we need to refactor this a bit, or handle
            // it as a special case..
        }
        else if (indexPath.section == SECTION_PLANETS)
        {
            objects = [[system getPlanets] allObjects];
        }
        else return; // Don't delete details
        
        // Delete the managed object at the given index path.
        NSManagedObject * toDelete = [objects objectAtIndex:indexPath.row];
        [managedObjectContext deleteObject: toDelete];
        
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

@end
