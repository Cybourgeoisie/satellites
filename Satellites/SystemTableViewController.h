//
//  SystemTableViewController.h
//  Satellites
//
//  Created by Richard Benjamin Heidorn on 5/19/13.
//  Copyright (c) 2013 Richard B Heidorn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ManagedTableViewController.h"

@interface SystemTableViewController : ManagedTableViewController
{
    // Core Data Managers
    NSMutableArray * systemsArray;
}

// Core Data
@property (nonatomic, retain) NSMutableArray * systemsArray;

@end
