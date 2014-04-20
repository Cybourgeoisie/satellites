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
    NSMutableArray  * buttons;
    
    // UI Elements
    IBOutlet UITextField * textField;
    IBOutlet UIButton    * unitField;
    UIActionSheet * activityActionSheet;
}

// Data Management
@property (nonatomic, strong) NSManagedObject * editedObject;
@property (nonatomic, strong) NSString        * editedFieldKey;
@property (nonatomic, strong) NSString        * editedFieldName;
@property (nonatomic, strong) NSMutableArray  * buttons;

// UI Elements
@property (nonatomic) IBOutlet UITextField * textField;
@property (nonatomic) IBOutlet UIButton    * unitField;
@property (nonatomic) UIActionSheet * activityActionSheet;

@end