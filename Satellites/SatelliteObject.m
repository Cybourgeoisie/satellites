//
//  SatelliteObject.m
//  Satellites
//
//  Created by Richard Benjamin Heidorn on 5/19/13.
//  Copyright (c) 2013 Richard B Heidorn. All rights reserved.
//

#import "SatelliteObject.h"
#import "SystemObject.h"


@implementation SatelliteObject

@dynamic axialTilt;
@dynamic bMoon;
@dynamic bStar;
@dynamic eccentricity;
@dynamic inclination;
@dynamic mass;
@dynamic name;
@dynamic rotation;
@dynamic semimajorAxis;
@dynamic size;
@dynamic texture;
@dynamic relativeBody;
@dynamic system;
@dynamic orbitalBody;

// Override a few setters...
- (void) setMass:(id) value
{
    [self setNumericValue:value forField:@"mass"];
}

- (void) setEccentricity: (id) value
{
    [self setNumericValue:value forField:@"eccentricity"];
}

- (void) setInclination: (id) value
{
    [self setNumericValue:value forField:@"inclination"];
}

- (void) setAxialTilt: (id) value
{
    [self setNumericValue:value forField:@"axialTilt"];
}

- (void) setRotation: (id) value
{
    [self setNumericValue:value forField:@"rotation"];
}

- (void) setSemimajorAxis: (id) value
{
    [self setNumericValue:value forField:@"semimajorAxis"];
}

// To set values of indeterminate type
- (void) setNumericValue: (id) value forField: (NSString *) field
{
    // Trigger the will change value event
    [self willChangeValueForKey:field];
    
    if ([value isKindOfClass:[NSString class]])
    {
        // Set the field value
        [self setNumericUsingNSString:value forField:field];
    }
    else
    {
        // Set the default
        [self setPrimitiveValue:value forKey:field];
    }
    
    // Trigger the did change value event
    [self didChangeValueForKey:field];
}

// To set a numeric value using an NSString
- (void) setNumericUsingNSString: (NSString *) value forField: (NSString *) field
{
    // Prepare the number formatter
    NSNumberFormatter * formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber * numericValue = [formatter numberFromString: value];
    
    // Validate value
    if (numericValue)
    {
        // Set the numeric value
        [self setPrimitiveValue:numericValue forKey:field];
    }
    else
    {
        // Error.. But for now, do nothing.
    }
}

@end
