//
//  Vector.m
//  SatellitesStarter
//
//  Created by Richard Benjamin Heidorn on 2/24/13.
//  Copyright (c) 2013 Richard B Heidorn. All rights reserved.
//

#import "Vector.h"

@implementation Vector
@synthesize x;
@synthesize y;
@synthesize z;

- (Vector *) init
{
    // Set to the default values
    self.x = 0;
    self.y = 0;
    self.z = 0;
    return self;
}

- (Vector *) copy
{
    // Return a copy of these values
    Vector * copy = [[Vector alloc] init];
    copy.x = x;
    copy.y = y;
    copy.z = z;
    return copy;
}

- (void) set : (float) a : (float) b : (float) c
{
    self.x = a;
    self.y = b;
    self.z = c;
}

- (float) getMagnitude
{
    return sqrt(pow(self.x, 2) + pow(self.y, 2) + pow(self.z, 2));
}

- (Vector *) getLogPosition
{
    Vector * log = [[Vector alloc] init];
    
    // Get the logarithm of the semi major axis
    float a     = [self getMagnitude];
    float a_log = log2f(a);
    
    // Get the angle between the x & y coordinates
    float theta = atan2f(y, x);
    if (theta < 0)
        theta = 2 * M_PI + theta;

    // Get the angle between the x-y plane & z coordinate
    // Simplified math from equation to calculate angle between line and plane
    float omega = asinf(z/a);
    if (omega < 0)
        omega = 2 * M_PI + omega;
    
    // Get the logarithmic values for x, y & z
    [log setX: a_log * cosf(theta)];
    [log setY: a_log * sinf(theta)];
    [log setZ: a_log * sinf(omega)];

    // Return the logarithmic coordinates
    return log;
}

@end
