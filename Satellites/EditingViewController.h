//
//  EditingViewController.h
//  Satellites
//
//  Created by Richard Benjamin Heidorn on 5/28/13.
//  Copyright (c) 2013 Richard B Heidorn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
#import "RootViewController.h"
#import "Unit.h"
#import "Satellite.h"
#import "SatellitesViewController.h"

@interface EditingViewController : UIViewController <UITextFieldDelegate>
{
    // Data Management
    NSManagedObject * editedObject;
    NSString        * editedFieldKey;
    NSString        * editedFieldName;
    
    // Internal stuff
    NSMutableArray * units;
    NSMutableArray * unitRange;
    Unit * currentUnit;

    // UI Elements
    IBOutlet UISlider    * slider;
    IBOutlet UITextField * textField;
    IBOutlet UIButton    * unitField;
    UIActionSheet * activityActionSheet;
    
    // GLKView
    Satellite * satellite;
    SatellitesViewController * satellitesViewController;
    SystemObject * system;
}

// Data Management
@property (nonatomic, strong) NSManagedObject * editedObject;
@property (nonatomic, strong) NSString        * editedFieldKey;
@property (nonatomic, strong) NSString        * editedFieldName;

// Internal stuff
@property (nonatomic, strong) NSMutableArray * units;
@property (nonatomic, strong) NSMutableArray * unitRange;
@property (nonatomic, strong) Unit * currentUnit;

// UI Elements
@property (nonatomic) IBOutlet UISlider    * slider;
@property (nonatomic) IBOutlet UITextField * textField;
@property (nonatomic) IBOutlet UIButton    * unitField;
@property (nonatomic) UIActionSheet * activityActionSheet;

// GLKView
@property (nonatomic, strong) Satellite * satellite;
@property (nonatomic, strong) SatellitesViewController * satellitesViewController;
@property (strong, nonatomic) SystemObject * system;

@end