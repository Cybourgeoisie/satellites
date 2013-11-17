//
//  ManagedTableViewController.h
//  Satellites
//
//  Created by Richard Benjamin Heidorn on 6/12/13.
//  Copyright (c) 2013 Richard B Heidorn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ManagedTableViewController : UITableViewController
{
    // Core Data Managers
    NSManagedObjectContext * managedObjectContext;

    // UI / Functional Triggers
    BOOL                     bShowAddButton;
    
    // View Buttons
    UIBarButtonItem        * addButton;
    UIBarButtonItem        * editButton;
}

// Core Data
@property (nonatomic, retain) NSManagedObjectContext * managedObjectContext;

// UI / Functional Triggers
@property (nonatomic)         BOOL                     bShowAddButton;

// Buttons
@property (nonatomic, retain) UIBarButtonItem        * addButton;
@property (nonatomic, retain) UIBarButtonItem        * editButton;

@end
