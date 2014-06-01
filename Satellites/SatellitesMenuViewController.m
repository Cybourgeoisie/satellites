//
//  SatellitesMenuViewController.m
//  Satellites
//
//  Created by Richard Benjamin Heidorn on 5/25/14.
//  Copyright (c) 2014 Richard B Heidorn. All rights reserved.
//

#import "SatellitesMenuViewController.h"

@implementation SatellitesMenuViewController
@synthesize menuOptions;
@synthesize showLabels;
@synthesize showTrails;
@synthesize viewScale;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set the values for the menu items
    [self setupMenu];
}

- (void) setupMenu
{
    // If we have options, set some values for everything found
    if ([menuOptions count] >= 1)
    {
        if ([menuOptions objectForKey:@"showLabels"])
        {
            [showLabels setOn:[[menuOptions valueForKey:@"showLabels"] boolValue]];
        }
        
        if ([menuOptions objectForKey:@"showTrails"])
        {
            [showTrails setOn:[[menuOptions valueForKey:@"showTrails"] boolValue]];
        }
    
        if ([menuOptions objectForKey:@"viewScale"])
        {
            [viewScale setSelectedSegmentIndex:[[menuOptions valueForKey:@"viewScale"] intValue]];
        }
    }
}

- (void) willMoveToParentViewController : (UIViewController *) parent
{
    // Has been popped - return the menu options
    if (!parent)
    {
        // Collect the values of the menu options
        [self updateMenuOptions];
        
        SatellitesViewController * viewController = (SatellitesViewController *) parent;
        [viewController setMenuOptions:menuOptions];
    }
}

- (void) updateMenuOptions
{
    // Go through the UI, set the current values
    [menuOptions setValue:[NSNumber numberWithBool:[showLabels isOn]] forKey:@"showLabels"];
    [menuOptions setValue:[NSNumber numberWithBool:[showTrails isOn]] forKey:@"showTrails"];
    [menuOptions setValue:[NSNumber numberWithInt:[viewScale selectedSegmentIndex]] forKey:@"viewScale"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
