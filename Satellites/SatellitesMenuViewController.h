//
//  SatellitesMenuViewController.h
//  Satellites
//
//  Created by Richard Benjamin Heidorn on 5/25/14.
//  Copyright (c) 2014 Richard B Heidorn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SatellitesViewController.h"

@interface SatellitesMenuViewController : UIViewController
{
    NSMutableDictionary * menuOptions;
    UISwitch * showLabels;
    UISwitch * showTrails;
    UISegmentedControl * viewScale;
    
    // Following a central satellite
    NSMutableArray * satellites;
    UIButton       * followSatellite;
    UIActionSheet  * activityActionSheet;
}

@property NSMutableDictionary * menuOptions;
@property (retain, nonatomic) IBOutlet UISwitch * showLabels;
@property (retain, nonatomic) IBOutlet UISwitch * showTrails;
@property (retain, nonatomic) IBOutlet UISegmentedControl * viewScale;

@property NSMutableArray * satellites;
@property (retain, nonatomic) IBOutlet UIButton * followSatellite;
@property (nonatomic) UIActionSheet * activityActionSheet;

- (void) setMenuOptions:(NSMutableDictionary *)menuOptions;

@end
