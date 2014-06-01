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
    Satellite       * centralBody;
    NSMutableArray  * bodies;
    BOOL              bEditorView;
}

- (id) initWithSystemObject:     (SystemObject *)    systemObject;
- (id) initWithSatelliteObjects: (NSMutableArray *) satelliteObjects;
- (void) performCalculations;
- (void) restartCalculations;
- (void) updateSatellite : (Satellite *) satellite;
- (Satellite *) getCentralBody;
- (void) setCentralBody : (Satellite *) body;
- (void) translateToBody : (Satellite *) body;

@property NSMutableArray  * satellites;
@property Satellite       * barycenter;
@property Satellite       * centralBody;
@property NSMutableArray  * bodies;
@property BOOL              bEditorView;

@end
