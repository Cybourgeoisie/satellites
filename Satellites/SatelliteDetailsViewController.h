//
//  SatelliteDetailsViewController.h
//  Satellites
//
//  Created by Richard Benjamin Heidorn on 6/12/13.
//  Copyright (c) 2013 Richard B Heidorn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ManagedTableViewController.h"
#import "Unit.h"
#import "SatelliteObject.h"
#import "EditingViewController.h"
#import "TextureViewController.h"

@interface SatelliteDetailsViewController : ManagedTableViewController
{
    // Satellite
    SatelliteObject * satellite;
}

// Satellite
@property (nonatomic, retain) SatelliteObject * satellite;

@end
