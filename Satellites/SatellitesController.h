//
//  SatellitesController.h
//  SatellitesStarter
//
//  Created by Richard Benjamin Heidorn on 3/8/13.
//  Copyright (c) 2013 Richard B Heidorn. All rights reserved.
//

//#import <stdlib.h>
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "Satellite.h"
#import "SystemObject.h"
#import "SatelliteObject.h"

@interface SatellitesController : NSObject
{
    SystemObject    * system;
    SatelliteObject * satellite;
    Satellite       * barycenter;
    NSMutableArray  * bodies;
    int              scale;
}

- (id) initWithSystemObject:    (SystemObject *)    systemObject;
- (id) initWithSatelliteObject: (SatelliteObject *) satelliteObject;
- (void) performCalculations;

@property SystemObject    * system;
@property SatelliteObject * satellite;
@property Satellite       * barycenter;
@property NSMutableArray  * bodies;
@property int              scale;

@end
