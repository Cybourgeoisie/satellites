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

@synthesize satellites;
@synthesize followSatellite;
@synthesize focusSatellite;
@synthesize followActivityActionSheet;
@synthesize focusActivityActionSheet;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self setupSatelliteList];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set the values for the menu items
    [self setupMenu];
}

- (void) setupSatelliteList
{
    // Set up the list of satellites
    followActivityActionSheet = [[UIActionSheet alloc] initWithTitle:@"Follow Satellite"
                                                      delegate:self
                                             cancelButtonTitle:nil
                                        destructiveButtonTitle:@"Cancel"
                                             otherButtonTitles:nil];
    
    // Set up the list of satellites
    focusActivityActionSheet = [[UIActionSheet alloc] initWithTitle:@"Focus Satellite"
                                                            delegate:self
                                                   cancelButtonTitle:nil
                                              destructiveButtonTitle:@"Cancel"
                                                   otherButtonTitles:nil];
    
    // Add a "Don't Follow" button for focus
    [focusActivityActionSheet addButtonWithTitle:@"No Focus"];

    // Set the buttons
    for (Satellite * satellite in satellites)
    {
        [followActivityActionSheet addButtonWithTitle:[satellite name]];
        [focusActivityActionSheet  addButtonWithTitle:[satellite name]];
    }
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
        
        if ([menuOptions objectForKey:@"followSatellite"])
        {
            Satellite * satellite = [menuOptions valueForKey:@"followSatellite"];
            NSString * satelliteName = [satellite name];

            // Set the title
            [followSatellite setTitle:satelliteName forState:UIControlStateNormal];
        }
        
        if ([menuOptions objectForKey:@"focusSatellite"])
        {
            Satellite * satellite = [menuOptions valueForKey:@"focusSatellite"];
            NSString * satelliteName = [satellite name];
            
            // Set the title
            [focusSatellite setTitle:satelliteName forState:UIControlStateNormal];
        }
    }
}

- (IBAction) setUserFollowActivity: (id) sender
{
    followActivityActionSheet.tag = 1;
    [followActivityActionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    [followActivityActionSheet showInView:self.view];
}

- (IBAction) setUserFocusActivity: (id) sender
{
    focusActivityActionSheet.tag = 1;
    [focusActivityActionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    [focusActivityActionSheet showInView:self.view];
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

- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        return;
    }

    NSString * title = [popup title];
    if ([title isEqualToString:@"Follow Satellite"])
    {
        // Set the satellite in the menu options
        Satellite * satellite = [satellites objectAtIndex:buttonIndex - 1];
        [menuOptions setValue:satellite forKey:@"followSatellite"];

        // Update the selected name
        [followSatellite setTitle:[satellite name] forState:UIControlStateNormal];
    }
    else if ([title isEqualToString:@"Focus Satellite"])
    {
        // If we're using the "Don't Focus" option, reckless abandon
        if (buttonIndex < 2)
        {
            // Set the satellite in the menu options
            [menuOptions setValue:nil forKey:@"focusSatellite"];
            
            // Update the selected name
            [focusSatellite setTitle:@"No Focus" forState:UIControlStateNormal];

            return;
        }

        // Set the satellite in the menu options
        Satellite * satellite = [satellites objectAtIndex:buttonIndex - 2];
        [menuOptions setValue:satellite forKey:@"focusSatellite"];
        
        // Update the selected name
        [focusSatellite setTitle:[satellite name] forState:UIControlStateNormal];
    }
}

- (void) updateMenuOptions
{
    // Go through the UI, set the current values
    [menuOptions setValue:[NSNumber numberWithBool:[showLabels isOn]] forKey:@"showLabels"];
    [menuOptions setValue:[NSNumber numberWithBool:[showTrails isOn]] forKey:@"showTrails"];
    [menuOptions setValue:[NSNumber numberWithInt:[viewScale selectedSegmentIndex]] forKey:@"viewScale"];
    //[menuOptions setValue: forKey:@"followSatellite"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
