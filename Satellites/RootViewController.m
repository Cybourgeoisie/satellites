//
//  RootViewController.m
//  Satellites
//
//  Created by Richard Benjamin Heidorn on 5/21/13.
//  Copyright (c) 2013 Richard B Heidorn. All rights reserved.
//

#import "RootViewController.h"
#import "SatellitesAppDelegate.h"
#import "SystemObject.h"

@implementation RootViewController

@synthesize managedObjectContext;

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
	// Do any additional setup after loading the view.
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    self.navigationController.toolbarHidden = true;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Save any changes
- (void) didFinishWithSave: (BOOL)save
{
    if (save)
    {
        // Prepare for errors
        NSError * error;
        
        // Save
        if (![self.managedObjectContext save:&error])
        {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
