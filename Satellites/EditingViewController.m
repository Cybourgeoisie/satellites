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
@synthesize slider;
@synthesize unitsToRange;
@synthesize textField;
@synthesize unitField;
@synthesize activityActionSheet;

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
    
    // Prepare UI elements
    [self prepareTextField];
    [self prepareSlider];
    [self prepareUnitOfMeasurementActionSheet];
    
    // Get the value
    id value = [self.editedObject valueForKey:self.editedFieldKey];
    [self updateSliderValue:[value floatValue]];
}

- (void) prepareTextField
{
    self.textField.hidden = NO;
    self.textField.placeholder = self.title;
    [textField addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
}

- (void) prepareSlider
{
    // Handle the slider value change event
    [slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    // Set the min and max values for the slider
    [self setRange:0];
}

- (void) setRange : (NSUInteger) index
{
    // Get the keys
    NSArray * units = [unitsToRange allKeys];
    
    // Set the initial minimum and maximum values for the default UOM
    NSDictionary * dict  = [unitsToRange valueForKey:[units objectAtIndex:index]];
    NSArray      * range = [dict valueForKey:@"range"];
    NSNumber     * min   = [range objectAtIndex:0];
    NSNumber     * max   = [range objectAtIndex:1];
    
    [slider setMinimumValue:[min floatValue]];
    [slider setMaximumValue:[max floatValue]];
}

- (IBAction) textFieldValueChanged : (UITextField *) sender
{
    // Float this shit
    NSString * textValue = sender.text;
    float value = [textValue floatValue];
    
    // Validate that we are within range
    float min = [slider minimumValue];
    float max = [slider maximumValue];
    if (min > value)
    {
        value = min;
        [textField setText:[NSString stringWithFormat:@"%1.3f", value]];
    }
    else if (max < value)
    {
        value = max;
        [textField setText:[NSString stringWithFormat:@"%1.3f", value]];
    }
    
    // Update slider value
    [slider setValue:value];
}

- (IBAction) sliderValueChanged : (UISlider *) sender
{
    // Update the text field
    NSString * value = [NSString stringWithFormat:@"%1.3f", sender.value];
    [textField setText : value];
}

- (void) updateSliderValue : (float) value
{
    [slider setValue:value];
    
    // Update the text field
    NSString * textValue = [NSString stringWithFormat:@"%1.3f", value];
    [textField setText : textValue];
}

- (void) prepareUnitOfMeasurementActionSheet
{
    activityActionSheet = [[UIActionSheet alloc] initWithTitle:@"Unit of Measurement"
                                                      delegate:self
                                             cancelButtonTitle:nil
                                        destructiveButtonTitle:@"Cancel"
                                             otherButtonTitles:nil];

    // Set the buttons
    NSArray * units = [self.unitsToRange allKeys];
    for (NSString * buttonName in units)
    {
        [activityActionSheet addButtonWithTitle:buttonName];
    }
    
    // Update the button name
    if ([units count] > 0)
    {
        NSDictionary * dict  = [unitsToRange valueForKey:[units objectAtIndex:0]];
        NSString * uomAbbr = [dict valueForKey:@"abbr"];
        [unitField setTitle:uomAbbr forState:UIControlStateNormal];
    }
    else
    {
        [unitField setHidden:true];
    }
}

- (IBAction) setUserActivity: (id) sender
{
    activityActionSheet.tag = 1;
    [activityActionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    [activityActionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        return;
    }
    
    // Get the units
    NSArray      * units = [unitsToRange allKeys];
    NSDictionary * dict  = [unitsToRange valueForKey:[units objectAtIndex:buttonIndex-1]];

    // Get the new value
    float value = [self convertValue : buttonIndex - 1];

    // Update the range
    [self setRange:buttonIndex - 1];
    
    // New value
    [self updateSliderValue : value];
    
    // Update the unit of measurement
    NSString * uomAbbr = [dict valueForKey:@"abbr"];
    [unitField setTitle:uomAbbr forState:UIControlStateNormal];
}

- (float) convertValue : (NSUInteger) convertToIndex
{
    // Get the units
    NSArray      * units = [unitsToRange allKeys];
    NSDictionary * dict  = [unitsToRange valueForKey:[units objectAtIndex:convertToIndex]];
    
    // Using the range of the previous units and the new units,
    // Convert the current value to a new value
    float maxConvertFrom = [slider maximumValue];
    float valConvertFrom = [slider value];
    
    // Get the value to convert to
    NSArray  * range   = [dict valueForKey:@"range"];
    NSNumber * max     = [range objectAtIndex:1];
    float maxConvertTo = [max floatValue];
    
    // New value
    return valConvertFrom * maxConvertTo / maxConvertFrom;
}

// Save Action
- (IBAction) save: (id) sender
{
    // Convert the value to the expected unit
    float      value       = [self convertValue : 0];
    NSString * stringValue = [NSString stringWithFormat:@"%1.3f", value];
    
    // Pass current value to the edited object
    [self.editedObject setValue:stringValue forKey:self.editedFieldKey];

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
