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

@end
