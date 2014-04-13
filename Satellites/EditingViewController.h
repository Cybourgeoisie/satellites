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
    
    // UI Elements
    IBOutlet UITextField * textField;
    IBOutlet UIButton    * unitField;
}

// Data Management
@property (nonatomic, strong) NSManagedObject * editedObject;
@property (nonatomic, strong) NSString        * editedFieldKey;
@property (nonatomic, strong) NSString        * editedFieldName;

// UI Elements
@property (nonatomic) IBOutlet UITextField * textField;
@property (nonatomic) IBOutlet UIButton    * unitField;

@end