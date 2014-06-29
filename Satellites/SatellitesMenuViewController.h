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
    UIButton       * focusSatellite;
    UIActionSheet  * followActivityActionSheet;
    UIActionSheet  * focusActivityActionSheet;
}

@property NSMutableDictionary * menuOptions;
@property (retain, nonatomic) IBOutlet UISwitch * showLabels;
@property (retain, nonatomic) IBOutlet UISwitch * showTrails;
@property (retain, nonatomic) IBOutlet UISegmentedControl * viewScale;

@property NSMutableArray * satellites;
@property (retain, nonatomic) IBOutlet UIButton * followSatellite;
@property (retain, nonatomic) IBOutlet UIButton * focusSatellite;
@property (nonatomic) UIActionSheet * followActivityActionSheet;
@property (nonatomic) UIActionSheet * focusActivityActionSheet;

- (void) setMenuOptions:(NSMutableDictionary *)menuOptions;

@end
