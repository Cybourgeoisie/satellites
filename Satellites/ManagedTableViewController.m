//
//  ManagedTableViewController.m
//  Satellites
//
//  Created by Richard Benjamin Heidorn on 6/12/13.
//  Copyright (c) 2013 Richard B Heidorn. All rights reserved.
//

#import "ManagedTableViewController.h"
#import "RootViewController.h"
#import "SystemObject.h"
#import "SatelliteObject.h"

@implementation ManagedTableViewController

@synthesize managedObjectContext;
@synthesize bShowAddButton;
@synthesize addButton;
@synthesize editButton;

- (id) init
{
    self = [super init];
    if (self)
    {
        bShowAddButton = true;
    }
    return self;
}

- (id) initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        bShowAddButton = true;
    }
    return self;
}

// Set the database connection
- (void) setRootManagedObjectContext
{
    // Get the managed object from the root
    RootViewController * root = (RootViewController *) self.navigationController;
    self.managedObjectContext = root.managedObjectContext;
}

// Set the configuration
- (void) setConfig
{
    bShowAddButton = true;
}

// Set the toolbar
- (void) setToolbar { }

// Set the toolbar visibility
- (void) setToolbarVisibility
{
    // Hide that sucker
    self.navigationController.toolbarHidden = true;
}

// Set up the table view - add, edit buttons, managed object context
- (void) viewDidLoad
{
    [super viewDidLoad];
    
    // Get the config
    [self setConfig];
    
    // Set the toolbar
    [self setToolbar];
    
    // Set the managed object context
    [self setRootManagedObjectContext];
    
    // Set the title.
    self.title = @"Managed Object Table Controller";
    
    // Create and delegate the add button
    addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                              target:self action:@selector(addHandler)];
    
    // Create and delegate the edit button
    editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                                               target:self action:@selector(editHandler)];
    
    // Use the add button
    if (bShowAddButton)
    {
        self.navigationItem.rightBarButtonItem = addButton;
    }
}

// Handle reloading the table data
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Reload the table data
    [self.tableView reloadData];
    
    // Make sure that Edit is not selected
    if (bShowAddButton)
    {
        self.navigationItem.rightBarButtonItem = self.addButton;
    }
    else
    {
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    // Determine if we show the toolbar
    [self setToolbarVisibility];
}

// Add Handler for Add button selection
- (void) addHandler { }

// Edit Handler for Edit button selection
- (void) editHandler { }

// Selection to display Add or Edit buttons
- (NSIndexPath *) tableView : (UITableView *) tableView willSelectRowAtIndexPath : (NSIndexPath *) indexPath
{
    // Get the currently selected row
    NSIndexPath * selectedIndexPath = [tableView indexPathForSelectedRow];
    
    // If this matches the row to be selected, deselect instead
    if (selectedIndexPath &&
        selectedIndexPath.section == indexPath.section &&
        selectedIndexPath.row == indexPath.row)
    {
        // Set the right button to add
        if (bShowAddButton)
        {
            self.navigationItem.rightBarButtonItem = self.addButton;
        }
        else
        {
            self.navigationItem.rightBarButtonItem = nil;
        }
        
        // Deselect the row
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        // Return nil to cease
        return nil;
    }
    
    // Set the right button to edit
    self.navigationItem.rightBarButtonItem = self.editButton;
    
    // Return the index path to continue
    return indexPath;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidUnload
{
    self.managedObjectContext = nil;
    self.addButton = nil;
    self.editButton = nil;
}

@end
