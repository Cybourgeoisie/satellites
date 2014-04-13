//
//  EditingViewController.m
//  Satellites
//
//  Created by Richard Benjamin Heidorn on 5/28/13.
//  Copyright (c) 2013 Richard B Heidorn. All rights reserved.
//

#import "EditingViewController.h"

@implementation EditingViewController

@synthesize editedFieldKey;
@synthesize editedFieldName;
@synthesize editedObject;
@synthesize textField;
@synthesize unitField;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set the title to the user-visible name of the field.
    self.title = self.editedFieldName;
    
    // Set the various options
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Get the value
    id value = [self.editedObject valueForKey:self.editedFieldKey];
    
    // If the value is numeric, convert to string
    if ([value isKindOfClass:[NSNumber class]])
    {
        value = [value stringValue];
    }
    
    // If we're editing a text field..
    self.textField.hidden = NO;
    self.textField.text = value;
    self.textField.placeholder = self.title;
}

- (IBAction) setUserActivity: (id) sender
{
    UIActionSheet *activityActionSheet = [[UIActionSheet alloc] initWithTitle:@"Unit of Measurement"
                                                             delegate:self
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Kilograms", @"Earth Masses", @"Solar Masses", nil];
    activityActionSheet.tag = 1;
    
    [activityActionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    [activityActionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex
{    
    switch (popup.tag) {
        default:
            switch (buttonIndex)
            {
                default:
                    // Switch the button text to the proper unit
                    [unitField setTitle:@"Unit: Kilograms" forState:UIControlStateNormal];
                    break;
            }
            break;
    }
}

// Save Action
- (IBAction) save: (id) sender
{
    // Pass current value to the edited object
    [self.editedObject setValue:self.textField.text forKey:self.editedFieldKey];
    
    // Save
    RootViewController * controller = (RootViewController *) self.navigationController;
    [controller didFinishWithSave : YES];
    
    // Pop.
    [self.navigationController popViewControllerAnimated:YES];
}

// Cancel Action
- (IBAction) cancel:(id)sender
{
    // Don't pass current value to the edited object. Just pop.
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
