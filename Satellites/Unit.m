//
//  Unit.m
//  Satellites
//
//  Created by Richard Benjamin Heidorn on 5/5/14.
//  Copyright (c) 2014 Richard B Heidorn. All rights reserved.
//

#import "Unit.h"

@implementation Unit
@synthesize unitTypes;
@synthesize unitValues;
@synthesize unitNames;
@synthesize unitAbbrs;
@synthesize type;
@synthesize value;
@synthesize name;
@synthesize abbr;

- (void) prepareUnits
{
    unitTypes  = [[NSArray alloc] initWithObjects:
                  @"length", @"length",
                  @"mass", @"mass", @"mass",
                  @"angle", @"angle",
                  @"angle/time", @"angle/time",
                  @"none",
                  nil];
    unitNames  = [[NSArray alloc] initWithObjects:
                  @"Astronomical Unit", @"Lunar Distance",
                  @"Earth Masses", @"Solar Masses", @"Lunar Masses",
                  @"Degrees", @"Radians",
                  @"Degrees per Second", @"Radians per Second",
                  @"Unitless",
                  nil];
    unitAbbrs  = [[NSArray alloc] initWithObjects:
                  @"AU", @"Lunar Dist.",
                  @"Earth Mass", @"Solar Mass", @"Lunar Mass",
                  @"Deg", @"Rad",
                  @"Deg / Sec", @"Rad / Sec",
                  @"Unitless",
                  nil];
    unitValues = [[NSArray alloc] initWithObjects:
                  [[NSNumber alloc] initWithFloat:1.0f], [[NSNumber alloc] initWithFloat:388.6f],
                  [[NSNumber alloc] initWithFloat:1.0f], [[NSNumber alloc] initWithFloat:0.00000300347f], [[NSNumber alloc] initWithFloat:81.3f],
                  [[NSNumber alloc] initWithFloat:1.0f], [[NSNumber alloc] initWithFloat:0.017453293f],
                  [[NSNumber alloc] initWithFloat:1.0f], [[NSNumber alloc] initWithFloat:0.017453293f],
                  [[NSNumber alloc] initWithFloat:1.0f],
                  nil];
}

- (id) initWithValue : (NSNumber *) unitValue forUnit : (NSString *) unitName
{
    // Set the default values
    [self prepareUnits];
    
    // Set the value and name
    [self setValue:unitValue];
    [self setName:unitName];
    
    return self;
}

- (id) initWithBaseValue : (NSNumber *) unitValue forUnit : (NSString *) unitName
{
    // Set the default values
    [self prepareUnits];
    
    // Get the converted value
    NSUInteger toIndex   = [unitNames indexOfObject:unitName];
    NSNumber * convTo    = [unitValues objectAtIndex:toIndex];
    float convertedValue = [unitValue floatValue] * [convTo floatValue];
    
    // Set the value and name
    [self setValue:[[NSNumber alloc] initWithFloat: convertedValue]];
    [self setName:unitName];
    
    return self;
}


- (void) setName : (NSString *) unitName
{
    // Make sure that the name is in the allowed list
    if (![unitNames containsObject:unitName])
    {
        [NSException raise:@"Unit name does not exist in this list." format:nil];
    }
    
    self->name = unitName;

    // Set the unit type and abbr
    NSUInteger index = [unitNames indexOfObject:unitName];
    [self setType:[unitTypes objectAtIndex:index]];
    [self setAbbr:[unitAbbrs objectAtIndex:index]];
}

- (void) setType : (NSString *) unitType
{
    if (![unitTypes containsObject: unitType])
    {
        [NSException raise:@"Unit type does not exist in this list." format:nil];
    }
    
    self->type = unitType;
}

- (NSNumber *) getBaseValue
{
    // Get the unit name index
    NSUInteger index = [unitNames indexOfObject:name];

    // Now divide this value by the conversion rate
    NSNumber * convRate = [unitValues objectAtIndex:index];
    float convertedValue = [value floatValue] / [convRate floatValue];

    // Convert to NSNumber, return
    return [[NSNumber alloc] initWithFloat:convertedValue];
}

- (NSNumber *) getValue
{
    return value;
}

- (NSString *) getAbbr
{
    return abbr;
}

- (NSNumber *) convertValue : (NSNumber *) unitValue toUnit : (NSString *) unitName
{
    // Get the unit name index
    NSUInteger fromIndex = [unitNames indexOfObject:name];
    NSUInteger toIndex   = [unitNames indexOfObject:unitName];
    
    // Now divide this value by the conversion rate
    NSNumber * convFrom = [unitValues objectAtIndex:fromIndex];
    NSNumber * convTo   = [unitValues objectAtIndex:toIndex];
    float convertedValue = ([unitValue floatValue] / [convFrom floatValue]) * [convTo floatValue];
    
    return [[NSNumber alloc] initWithFloat:convertedValue];
}

- (NSNumber *) convertValue : (NSNumber *) unitValue fromUnit : (NSString *) unitName
{
    // Get the unit name index
    NSUInteger fromIndex = [unitNames indexOfObject:unitName];
    NSUInteger toIndex   = [unitNames indexOfObject:name];
    
    // Now divide this value by the conversion rate
    NSNumber * convFrom = [unitValues objectAtIndex:fromIndex];
    NSNumber * convTo   = [unitValues objectAtIndex:toIndex];
    float convertedValue = ([unitValue floatValue] / [convFrom floatValue]) * [convTo floatValue];
    
    return [[NSNumber alloc] initWithFloat:convertedValue];
}

// Incomplete
- (Unit *) convertToBaseUnit
{
    return self;
}

- (Unit *) convertTo: (NSString *) unitName
{
    // Set the value, name, type, abbr
    value = [self convertValue:value toUnit:unitName];
    [self setName:unitName];
    
    return self;
}


@end
