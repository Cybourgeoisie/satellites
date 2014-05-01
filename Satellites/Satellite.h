//
//  Satellite.h
//  SatellitesStarter
//
//  Created by Richard Benjamin Heidorn on 2/24/13.
//  Copyright (c) 2013 Richard B Heidorn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Vector.h"

@interface Satellite : NSObject
{
    // Visual variables
@public
    float      size;
    Vector   * color;
    NSString * name;
    NSString * texture;
    
    // Properties
@public
    bool        bStar;
    bool        bMoon;
    float       mass;
    float       eccentricity;
    float       inclination;
    float       axialTilt;
    float       rotationSpeed;
    Vector    * position;
    Vector    * velocity;
    Vector    * acceleration;
    Satellite * orbitalBody;
}

// Flags
@property (nonatomic) bool bStar;
@property (nonatomic) bool bMoon;
@property Satellite * orbitalBody;

// Extrinsic Properties
@property GLfloat size;
@property Vector * color;
@property NSString * name;
@property NSString * texture;

// Intrinsic properties
@property (nonatomic) float mass;
@property (nonatomic) float eccentricity;
@property (nonatomic) float inclination;
@property (nonatomic) float axialTilt;
@property (nonatomic) float rotationSpeed;

// Motion
@property (retain) Vector * position;
@property (retain) Vector * velocity;
@property (retain) Vector * acceleration;

- (bool) isStar;
- (void) isStar           : (bool) isStar;

- (bool) isMoon;
- (void) isMoon           : (bool) isMoon;

- (void) setDistance      : (float) a;
- (void) setDistance      : (float) a fromBody : (Satellite *) body;

- (void) setMass          : (float) m;
- (void) setInclination   : (float) i;

- (void) setPosition      : (float) a : (float) b : (float) c;
- (void) setVelocity      : (float) a : (float) b : (float) c;
- (void) setAcceleration  : (float) a : (float) b : (float) c;

- (void) updateField      : (NSString *) fieldName withValue : (id) value;

@end
