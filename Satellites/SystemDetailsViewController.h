//
//  SystemDetailsViewController.h
//  Satellites
//
//  Created by Richard Benjamin Heidorn on 5/26/13.
//  Copyright (c) 2013 Richard B Heidorn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ManagedTableViewController.h"
#import "SystemObject.h"
#import "SatelliteObject.h"

@interface SystemDetailsViewController : ManagedTableViewController
{
    // System
    SystemObject * system;
    
    // Number of Rows
    int numStars;
    int numPlanets;
}

// System
@property (nonatomic, strong) SystemObject * system;

// Keep track of the number of rows
@property int numStars;
@property int numPlanets;

@end