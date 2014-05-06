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
#import "DefaultSatelliteSystems.h"

@interface SatellitesController : NSObject
{
    NSMutableArray  * satellites;
    Satellite       * barycenter;
    NSMutableArray  * bodies;
    BOOL              bEditorView;
}

- (id) initWithSystemObject:     (SystemObject *)    systemObject;
- (id) initWithSatelliteObjects: (NSMutableArray *) satelliteObjects;
- (void) performCalculations;
- (void) restartCalculations;
- (void) updateSatellite : (Satellite *) satellite;

@property NSMutableArray  * satellites;
@property Satellite       * barycenter;
@property NSMutableArray  * bodies;
@property BOOL              bEditorView;

@end
