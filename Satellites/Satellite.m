//
//  Satellite.m
//  SatellitesStarter
//
//  Created by Richard Benjamin Heidorn on 2/24/13.
//  Copyright (c) 2013 Richard B Heidorn. All rights reserved.
//

#import "Satellite.h"

@implementation Satellite

// Flags
@synthesize bStar;
@synthesize bMoon;
@synthesize orbitalBody;

// Extrinsic Properties
@synthesize size;
@synthesize name;
@synthesize color;
@synthesize texture;

// Intrinsic Properties
@synthesize mass;
@synthesize eccentricity;
@synthesize inclination;
@synthesize axialTilt;
@synthesize rotationSpeed;

// Motion
@synthesize position;
@synthesize velocity;
@synthesize acceleration;

- (Satellite *) init
{
    // Initialize the necessary variables
    self.position     = [[Vector alloc] init];
    self.velocity     = [[Vector alloc] init];
    self.acceleration = [[Vector alloc] init];
    
    // Set the remainder to 0
    self.size = 0;
    self.mass = 0;
    self.eccentricity = 0;
    self.inclination  = 0;
    
    // Set the properties to empty strings
    self.name    = @"";
    self.texture = @"";
    
    // Create random colors
    self.color   = [[Vector alloc] init];
    self.color.x = arc4random_uniform(80) / 100.0;
    self.color.y = arc4random_uniform(80) / 100.0;
    self.color.z = arc4random_uniform(80) / 100.0;
    
    // Pass back
    return self;
}

- (void) updateField : (NSString *) fieldName withValue : (id) value
{
    if ([self respondsToSelector:NSSelectorFromString(fieldName)])
    {
        [self setValue: value forKey: fieldName];
    }
}

/*
 Parameter: Semi-major axis
 Creates position based on random orientation
 */
- (void) setDistance : (float) a
{
    [self setDistance: a fromBody: nil];
}

/*
 Parameter: Semi-major axis
 Creates position based on random orientation
 */
- (void) setDistance : (float) a fromBody : (Satellite *) body
{
    // If none is provided, assume the center of gravity
    body = (!body) ? [[Satellite alloc] init] : body;
    self.orbitalBody = body;
    
    // Prepare the coordinates
    float x, y, z;
    float theta = (arc4random_uniform(360)) * 3.141592 / 180;
    
    // Coordinates
    float periapsis = a * (1 - self.eccentricity);
    x = body.position.x + periapsis * cosf(theta) * cosf(self.inclination);
    y = body.position.y + periapsis * sinf(theta) * cosf(self.inclination);
    z = body.position.z + periapsis * sinf(self.inclination);
    
    // Set the position
    [self setPosition: x : y : z];
}

- (void) updateDistance : (float) a
{
    // Use this body's orbital body.. or none
    Satellite * body = self.orbitalBody ?: [[Satellite alloc] init];

    // Move the body closer or further.. somehow.
    // Prepare the coordinates
    float x = self.position.x, y = self.position.y, z = self.position.z;
    float theta = atanf(y/x);

    // Coordinates
    float periapsis = a * (1 - self.eccentricity);
    x = body.position.x + periapsis * cosf(theta) * cosf(self.inclination);
    y = body.position.y + periapsis * sinf(theta) * cosf(self.inclination);
    z = body.position.z + periapsis * sinf(self.inclination);
    
    // Set the position
    [self setPosition: x : y : z];
}

// Override to also set the size
- (void) setMass : (float) m
{
    // Set the mass directly
    self->mass = m;
    
    // Create the size
    // The radius of the body is proportional to mass ^ 1/3
    // The logarithm allows us to see everything on the screen
    //self.size = log2f(pow(m * 10000, 1.0/3.0f));
    
    self.size = log2f(pow(m * 1000, 1.0/2.0f));
}

- (void) isStar : (bool)isStar
{
    self.bStar = isStar;
}

- (bool) isStar
{
    return self.bStar;
}

- (void) isMoon : (bool) isMoon
{
    self.bMoon = isMoon;
}

- (bool) isMoon
{
    return self.bMoon;
}

- (void) setPosition : (float) a : (float) b : (float) c
{
    [self.position set:a:b:c];
}

- (void) setVelocity : (float) a : (float) b : (float) c
{
    [self.velocity set:a:b:c];
}

- (void) setAcceleration : (float) a : (float) b : (float) c
{
    [self.acceleration set:a:b:c];
}

// Provided in degrees
- (void) setInclination : (float) i
{
    self->inclination = [self convertToRadians: i];
}

// Provided in degrees
- (void) setAxialTilt : (float) theta
{
    self->axialTilt = [self convertToRadians: theta];
}

- (void) setRotationSpeed : (float) theta
{
    self->rotationSpeed = [self convertToRadians: theta] / 30; // Assuming 30 FPS
}

- (float) convertToRadians : (float) deg
{
    return deg * 3.141592 / 180;
}

@end