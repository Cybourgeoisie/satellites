//
//  DefaultSatelliteSystems.h
//  Satellites
//
//  Created by Richard Benjamin Heidorn on 5/4/14.
//  Copyright (c) 2014 Richard B Heidorn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Satellite.h"

@interface DefaultSatelliteSystems : NSObject
{
    NSMutableArray * bodies;
    float            scale;
}

@property NSMutableArray * bodies;
@property float            scale;

// Ready-made systems
- (NSMutableArray *) solarSystem;
- (NSMutableArray *) randomBodies;
- (NSMutableArray *) binaryStars;

@end
