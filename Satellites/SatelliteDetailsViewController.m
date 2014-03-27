//
//  SatelliteDetailsViewController.m
//  Satellites
//
//  Created by Richard Benjamin Heidorn on 6/12/13.
//  Copyright (c) 2013 Richard B Heidorn. All rights reserved.
//

#import "SatelliteDetailsViewController.h"

// Sections
#define SECTION_DETAILS    0
#define SECTION_APPEARANCE 1
#define SECTION_PROPERTIES 2
#define SECTION_MOONS      3
#define NUM_SECTIONS       4

// Rows
#define ROW_NAME         0
#define ROW_TEXTURE      0
#define ROW_COLOR        1
#define ROW_MASS         0
#define ROW_DISTANCE     1
#define ROW_ECCENTRICITY 2
#define ROW_INCLINATION  3
#define ROW_ROTATION     4
#define ROW_AXIAL_TILT   5

@implementation SatelliteDetailsViewController

@synthesize satellite;

- (void) setConfig
{
    bShowAddButton = false;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Satellite";
}

// Selecting a row
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Segue to adding a satellite
    if (indexPath.section == SECTION_MOONS && indexPath.row == [[satellite relativeBody] count])
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
    if (indexPath.section == SECTION_DETAILS ||
        indexPath.section == SECTION_PROPERTIES)
    {
        [self performSegueWithIdentifier:@"EditSelectedItem" sender:self];
    }
    else if (indexPath.section == SECTION_APPEARANCE &&
             indexPath.row == ROW_TEXTURE)
    {
        [self performSegueWithIdentifier:@"ViewTextures" sender:self];
    }
    else if (indexPath.section == SECTION_MOONS)
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
        controller.editedObject = self.satellite;
        
        // Given a particular section and row, allow certain editing to occur
        if (indexPath.section == SECTION_DETAILS && indexPath.row == ROW_NAME)
        {
            controller.editedFieldKey = @"name";
            controller.editedFieldName = NSLocalizedString(@"Name", @"Name");
        }
        else if (indexPath.section == SECTION_PROPERTIES && indexPath.row == ROW_MASS)
        {
            controller.editedFieldKey = @"mass";
            controller.editedFieldName = NSLocalizedString(@"Mass", @"Mass");
        }
        else if (indexPath.section == SECTION_PROPERTIES && indexPath.row == ROW_ECCENTRICITY)
        {
            controller.editedFieldKey = @"eccentricity";
            controller.editedFieldName = NSLocalizedString(@"Eccentricity", @"Eccentricity");
        }
        else if (indexPath.section == SECTION_PROPERTIES && indexPath.row == ROW_INCLINATION)
        {
            controller.editedFieldKey = @"inclination";
            controller.editedFieldName = NSLocalizedString(@"Inclination", @"Inclination");
        }
        else if (indexPath.section == SECTION_PROPERTIES && indexPath.row == ROW_ROTATION)
        {
            controller.editedFieldKey = @"rotation";
            controller.editedFieldName = NSLocalizedString(@"Rotation", @"Rotation");
        }
        else if (indexPath.section == SECTION_PROPERTIES && indexPath.row == ROW_DISTANCE)
        {
            controller.editedFieldKey = @"semimajorAxis";
            controller.editedFieldName = NSLocalizedString(@"Distance", @"Distance");
        }
        else if (indexPath.section == SECTION_PROPERTIES && indexPath.row == ROW_AXIAL_TILT)
        {
            controller.editedFieldKey = @"axialTilt";
            controller.editedFieldName = NSLocalizedString(@"Axial Tilt", @"Axial Tilt");
        }
        else
        {
            // Set to name so that it won't break.
            controller.editedFieldKey = @"name";
            controller.editedFieldName = NSLocalizedString(@"TODO", @"todo");
        }
    }
    else if ([[segue identifier] isEqualToString:@"EditSelectedBody"])
    {
        // Prepare the Editing View Controller
        SatelliteDetailsViewController * controller = (SatelliteDetailsViewController *)[segue destinationViewController];
        
        // Get the satellite
        NSArray         * satellites = [[satellite relativeBody] allObjects];
        SatelliteObject * moon       = [satellites objectAtIndex:indexPath.row];
        
        // Set the object
        controller.satellite = moon;
    }
    else if ([[segue identifier] isEqualToString:@"ViewTextures"])
    {
        NSLog(@"Viewing Textures.");
        
        // Prepare the View Textures Controller
        TextureViewController * controller = (TextureViewController *)[segue destinationViewController];

        // Set the object
        controller.editedObject = self.satellite;
    }
    else if ([[segue identifier] isEqualToString:@"AddNewBody"])
    {
        // Prepare the Editing View Controller
        SatelliteDetailsViewController * controller = (SatelliteDetailsViewController *)[segue destinationViewController];
        
        // Create and configure a new instance of the Event entity.
        SatelliteObject * moon = (SatelliteObject *)[NSEntityDescription insertNewObjectForEntityForName:@"SatelliteObject" inManagedObjectContext:managedObjectContext];
        
        // Set default information
        [moon setName : @"Untitled Moon"];
        [moon setBMoon: [NSNumber numberWithBool:true]];
        [moon setOrbitalBody: satellite];
        
        // Save the default information
        NSError *error = nil;
        if (![managedObjectContext save : &error])
        {
            // Handle the error.
        }
        
        // Add the moon to the system
        [satellite addRelativeBodyObject: moon];
        
        // Set the object
        controller.satellite = moon;
    }
    
    // Reset the right-side button
    self.navigationItem.rightBarButtonItem = nil;
}

// Sections: Details, Appearance, Properties
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Total number of sections reflects static content
    // Static: Satellite Details, Appearance, Properties
    // Dynamic: Moons
    
    // Don't include Moons if satellite is a moon
    if (satellite != nil && (satellite.bMoon || satellite.bStar))
    {
        return NUM_SECTIONS - 1;
    }
    
    return NUM_SECTIONS;
}

// Section Header Titles
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == SECTION_DETAILS)
    {
        return @"Details";
    }
    else if (section == SECTION_APPEARANCE)
    {
        return @"Appearance";
    }
    else if (section == SECTION_PROPERTIES)
    {
        return @"Properties";
    }
    else if (section == SECTION_MOONS)
    {
        return @"Moons";
    }
    
    return @"Section Name Not Found";
}

// Rows in each section
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Details
    if (section == SECTION_DETAILS)
    {
        return 1; // Name
    }
    // Appearance
    else if (section == SECTION_APPEARANCE)
    {
        return 2; // Texture, Color
    }
    // Properties
    else if (section == SECTION_PROPERTIES)
    {
        return 6; // Mass, Distance, Eccentricity, Inclination, Rotation Period, Axial Tilt
    }
    
    // Moons
    // [[satellite moons] count] + (add new moon);
    return [[satellite relativeBody] count] + 1;
}

// Design and label the cells
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Initialize the cell and info
    UITableViewCell * cell = nil;
    NSString        * cellIdentifier = nil;
    NSString        * cellDetailText = @"";
    NSString        * cellLabelText  = @"";
    NSInteger         cellStyle      = UITableViewCellStyleValue2;
    
    // Details
    if (indexPath.section == SECTION_DETAILS)
    {
        cellIdentifier = @"satelliteDetailCell";
        
        if (indexPath.row == 0)
        {
            cellLabelText  = @"Name";
            cellDetailText = satellite.name;
        }
    }
    // Appearance
    else if (indexPath.section == SECTION_APPEARANCE)
    {
        cellIdentifier = @"satelliteAppearanceCell";
        cellDetailText = @"Details";

        if (indexPath.row == 0)
        {
            cellLabelText  = @"Texture";
            cellDetailText = @"To do"; //satellite.texture;
        }
        else if (indexPath.row == 1)
        {
            cellLabelText  = @"Color";
            cellDetailText = @"To do";
        }
    }
    // Properties
    else if (indexPath.section == SECTION_PROPERTIES)
    {
        cellIdentifier = @"satellitePropertyCell";
        cellDetailText = @"Details";
        
        if (indexPath.row == ROW_MASS)
        {
            cellLabelText  = @"Mass";
            cellDetailText = [satellite.mass stringValue];
        }
        else if (indexPath.row == ROW_DISTANCE)
        {
            cellLabelText  = @"Distance";
            cellDetailText = [satellite.semimajorAxis stringValue];
        }
        else if (indexPath.row == ROW_ECCENTRICITY)
        {
            cellLabelText  = @"Eccentricity";
            cellDetailText = [satellite.eccentricity stringValue];
        }
        else if (indexPath.row == ROW_INCLINATION)
        {
            cellLabelText  = @"Inclination";
            cellDetailText = [satellite.inclination stringValue];
        }
        else if (indexPath.row == ROW_ROTATION)
        {
            cellLabelText  = @"Rotation";
            cellDetailText = [satellite.rotation stringValue];
        }
        else if (indexPath.row == ROW_AXIAL_TILT)
        {
            cellLabelText  = @"Axial Tilt";
            cellDetailText = [satellite.axialTilt stringValue];
        }
    }
    // Moons
    else if (indexPath.section == SECTION_MOONS)
    {
        if ([[satellite relativeBody] count] > 0 && indexPath.row < [[satellite relativeBody] count])
        {
            // Get the satellite
            NSArray         * satellites = [[satellite relativeBody] allObjects];
            SatelliteObject * body       = [satellites objectAtIndex:indexPath.row];
            
            cellIdentifier = @"satelliteMoonCell";
            cellLabelText  = @"Moon";
            cellDetailText = body.name;
        }
        
        // Last row, add option
        if (indexPath.row == [[satellite relativeBody] count]) // Add Row
        {
            cellIdentifier = @"addSatelliteMoonCell";
            cellLabelText  = @"Add New Moon";
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
    if (indexPath.section == SECTION_MOONS && indexPath.row != [[satellite relativeBody] count])
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
        if (indexPath.section == SECTION_MOONS)
        {
            objects = [[satellite relativeBody] allObjects];
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
