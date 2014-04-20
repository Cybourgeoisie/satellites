//
//  EditingViewController.h
//  Satellites
//
//  Created by Richard Benjamin Heidorn on 5/28/13.
//  Copyright (c) 2013 Richard B Heidorn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"

@interface EditingViewController : UIViewController
{
    // Data Management
    NSManagedObject * editedObject;
    NSString        * editedFieldKey;
    NSString        * editedFieldName;
    
    // Internal stuff
    NSMutableDictionary * unitsToRange;
    
    // UI Elements
    IBOutlet UISlider    * slider;
    IBOutlet UITextField * textField;
    IBOutlet UIButton    * unitField;
    UIActionSheet * activityActionSheet;
}

// Data Management
@property (nonatomic, strong) NSManagedObject * editedObject;
@property (nonatomic, strong) NSString        * editedFieldKey;
@property (nonatomic, strong) NSString        * editedFieldName;

// Internal stuff
@property (nonatomic, strong) NSMutableDictionary * unitsToRange;

// UI Elements
@property (nonatomic) IBOutlet UISlider    * slider;
@property (nonatomic) IBOutlet UITextField * textField;
@property (nonatomic) IBOutlet UIButton    * unitField;
@property (nonatomic) UIActionSheet * activityActionSheet;

@end