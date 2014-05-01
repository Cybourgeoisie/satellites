//
//  SatellitesController.m
//  SatellitesStarter
//
//  Created by Richard Benjamin Heidorn on 3/8/13.
//  Copyright (c) 2013 Richard B Heidorn. All rights reserved.
//

#import "SatellitesController.h"

static float G  = 100000; // 4 PI^2 * AU^3 / ( year ^2 * (solar system mass) )
static float dt = 1;

@implementation SatellitesController
@synthesize system;
@synthesize satellites;
@synthesize bodies;
@synthesize barycenter;
@synthesize scale;

- (id) init
{
    // Configuration
    [self setConfiguration];
    
    // Create the bodies
    [self initializeBodies];
    
    // Translate satellites to COM frame
    [self translateToCenterOfMass];
    
    // Calculuate initial velocities
    [self calculateInitialVelocities];
    
    return self;
}

- (id) initWithSystemObject: (SystemObject *) systemObject
{
    // Set a custom system
    [self setSystem: systemObject];
    
    // Initialize
    return [self init];
}

- (id) initWithSatelliteObjects: (NSMutableArray *) satelliteObjects
{
    // Set a custom system
    [self setSatellites: satelliteObjects];

    // Initialize
    return [self init];
}

- (void) setConfiguration
{
    // Multipliers
    scale = 1000;
}

- (void) initializeBodies
{
    // Instantiate
    barycenter = [[Satellite alloc] init];
    bodies     = [[NSMutableArray alloc] init];
    
    // If we have a system, create all bodies from it
    if (system != nil)
    {
        [self customSystem];
    }
    else if (satellites != nil)
    {
        [self createSystem: satellites];
    }
    else
    {
        // Random method of generating planets
        //[self randomBodies];
        
        // Simple Solar System Model
        [self solarSystem];
        
        // Binary Stars
        //[self binaryStars];
    }
}

- (void) createSystem : (NSMutableArray *) satelliteObjects
{
    for (SatelliteObject * satelliteObject in satelliteObjects)
    {
        // Create stars first
        if (!satelliteObject.bStar) { continue; }
        
        [self createSatellite: satelliteObject];
    }

    // If there is more than one star, set orbital bodies
    if (bodies.count == 2)
    {
        // Get the stars
        Satellite * star  = [bodies objectAtIndex:0];
        Satellite * star2 = [bodies objectAtIndex:1];
        
        // Set the second star at the opposite point
        [star2 setPosition : 0.0 : - star2.position.y : 0.0];
        
        // Set the orbital bodies
        [star  setOrbitalBody : star2];
        [star2 setOrbitalBody : star];
    }
    
    // Calculate the barycenter of these stars and set the COM
    [self translateToCenterOfMass];
    
    // For each satellite object, create a corresponding satellite
    for (SatelliteObject * satelliteObject in satelliteObjects)
    {
        // Already created stars
        if (satelliteObject.bStar) { continue; }
        
        [self createSatellite: satelliteObject];
    }
}

- (void) customSystem
{
    // For each sun, create a satellite
    for (SatelliteObject * starObject in system.getStars)
    {
        // Star
        Satellite * star = [[Satellite alloc] init];
        [star isStar : true];
        [star isMoon : false];
        [star setEccentricity : [starObject.eccentricity floatValue]];
        [star setInclination  : [starObject.inclination floatValue]];
        [star setAxialTilt    : [starObject.axialTilt floatValue]];
        [star setRotationSpeed : [starObject.rotation floatValue]];
        [star setPosition : 0.0 : [starObject.semimajorAxis floatValue] * scale : 0.0];
        [star setName : starObject.name];
        [star setTexture : ([starObject.texture length]) ? starObject.texture : @"Sun"];
        [star setMass : [starObject.mass floatValue]];
        
        // PROBLEM: Multiple stars need to be able to revolve with each other.
        // Temporary solution is to only allow single and double star systems.
        
        // Add the body
        [bodies addObject: star];
    }
    
    // If there is more than one star, set orbital bodies
    // YEAH THIS IS A HACK, SO WHAT?
    if (bodies.count == 2)
    {
        // Get the stars
        Satellite * star  = [bodies objectAtIndex:0];
        Satellite * star2 = [bodies objectAtIndex:1];
        
        // Set the second star at the opposite point
        [star2 setPosition : 0.0 : - star2.position.y : 0.0];
        
        // Set the orbital bodies
        [star  setOrbitalBody : star2];
        [star2 setOrbitalBody : star];
    }
    
    // Calculate the barycenter of these stars and set the COM
    [self translateToCenterOfMass];
    
    // For each satellite object, create a corresponding satellite
    for (SatelliteObject * planetObject in system.getPlanets)
    {
        [self createSatellite:planetObject];
    }
}

- (void) createSatellite: (SatelliteObject *) satelliteObject
{
    // Planet
    Satellite * satellite = [[Satellite alloc] init];
    [satellite isStar : satelliteObject.bStar];
    [satellite isMoon : satelliteObject.bMoon];
    [satellite setEccentricity : [satelliteObject.eccentricity floatValue]];
    [satellite setInclination  : [satelliteObject.inclination floatValue]];
    [satellite setAxialTilt    : [satelliteObject.axialTilt floatValue]];
    [satellite setRotationSpeed : [satelliteObject.rotation floatValue]];
    [satellite setName : satelliteObject.name];
    [satellite setMass : [satelliteObject.mass floatValue]];
    
    // Star-specific settings
    if (satelliteObject.bStar)
    {
        [satellite setPosition : 0.0 : [satelliteObject.semimajorAxis floatValue] * scale : 0.0];
        [satellite setTexture : ([satelliteObject.texture length]) ? satelliteObject.texture : @"Sun"];
    }
    else
    {
        [satellite setDistance: [satelliteObject.semimajorAxis floatValue] * scale fromBody: barycenter];
        [satellite setTexture : ([satelliteObject.texture length]) ? satelliteObject.texture : @"Venus"];
    }
    
    // Add the body
    [bodies addObject: satellite];
    
    // Add each moon
    for (SatelliteObject * moonObject in satelliteObject.relativeBody)
    {
        // Moon
        Satellite * moon = [[Satellite alloc] init];
        [moon isStar : moonObject.bStar];
        [moon isMoon : moonObject.bMoon];
        [moon setEccentricity : [moonObject.eccentricity floatValue]];
        [moon setInclination  : [moonObject.inclination floatValue]];
        [moon setAxialTilt    : [moonObject.axialTilt floatValue]];
        [moon setRotationSpeed : [moonObject.rotation floatValue]];
        [moon setDistance: [moonObject.semimajorAxis floatValue] * scale fromBody: satellite];
        [moon setName : moonObject.name];
        [moon setTexture : ([moonObject.texture length]) ? moonObject.texture : @"Moon"];
        [moon setMass : [moonObject.mass floatValue]];
        
        // Add the moons
        [bodies addObject: moon];
    }
}

- (void) performCalculations
{
    if ([bodies count] > 1)
    {
        // Calculate new positions
        [self calculateCurrentPositions];
        
        // Translate satellites to COM frame
        [self translateToCenterOfMass];
        
        // Translate to a particular body
        [self translateToBody : @"Earth"];
    }
    else
    {
        SatelliteObject * satellite = [satellites lastObject];
        [self translateToBody : satellite.name];
    }
}

/* * * * * * * * * *
 
  Planetary Systems
 
 * * * * * * * * * */

- (void) solarSystem
{
    // Sun
    Satellite *sun = [[Satellite alloc] init];
    [sun isStar : true];
    [sun setRotationSpeed: 0.05];
    [sun setMass : 330000];
    [sun setTexture : @"Sun"];
    [sun setName : @"Sun"];
    
    // Mercury
    Satellite *mercury = [[Satellite alloc] init];
    [mercury setEccentricity : 0.206];
    [mercury setInclination  : 7.01];
    [mercury setDistance: 0.4 * scale fromBody : sun];
    [mercury setMass : 0.06];
    [mercury setTexture : @"Mercury"];
    [mercury setName : @"Mercury"];
    
    // Venus
    Satellite *venus = [[Satellite alloc] init];
    [venus setEccentricity : 0.007];
    [venus setInclination  : 3.39];
    [venus setDistance : 0.7 * scale fromBody : sun];
    [venus setMass : 0.81];
    [venus setTexture : @"Venus"];
    [venus setName : @"Venus"];
    
    // Earth
    Satellite *earth = [[Satellite alloc] init];
    [earth setEccentricity : 0.017];
    [earth setAxialTilt: 23.5];
    [earth setRotationSpeed: 0.01];
    [earth setDistance : 1.0 * scale fromBody : sun];
    [earth setMass : 1];
    [earth setTexture : @"Earth"];
    [earth setName : @"Earth"];
    
    // Moon
    Satellite *moon = [[Satellite alloc] init];
    [moon isMoon : true];
    [moon setDistance : 0.0025 * scale fromBody : earth];
    [moon setMass : 0.0123];
    [moon setTexture : @"Moon"];
    [moon setName : @"Moon"];
    
    // Mars
    Satellite *mars = [[Satellite alloc] init];
    [mars setEccentricity : 0.093];
    [mars setInclination  : 1.85];
    [mars setDistance : 1.5 * scale fromBody : sun];
    [mars setMass : 0.11];
    [mars setTexture : @"Mars"];
    [mars setName : @"Mars"];
    
    // Ceres
    Satellite *ceres = [[Satellite alloc] init];
    [ceres setEccentricity : 0.079];
    [ceres setInclination  : 10.59];
    [ceres setDistance : 2.8 * scale fromBody : sun];
    [ceres setMass : 0.00015];
    [ceres setTexture : @"Moon"];
    [ceres setName : @"Ceres"];
    
    // Jupiter
    Satellite *jupiter = [[Satellite alloc] init];
    [jupiter setEccentricity : 0.004];
    [jupiter setInclination  : 1.31];
    [jupiter setDistance : 5.22 * scale fromBody : sun];
    [jupiter setMass : 317.8];
    [jupiter setTexture : @"Jupiter"];
    [jupiter setName : @"Jupiter"];

    // Saturn
    Satellite *saturn = [[Satellite alloc] init];
    [saturn setEccentricity : 0.056];
    [saturn setInclination  : 2.49];
    [saturn setDistance : 9.54 * scale fromBody : sun];
    [saturn setMass : 95.2];
    [saturn setTexture : @"Saturn"];
    [saturn setName : @"Saturn"];

    // Uranus
    Satellite *uranus = [[Satellite alloc] init];
    [uranus setEccentricity : 0.047];
    [uranus setInclination  : 0.77];
    [uranus setDistance : 19.2 * scale fromBody : sun];
    [uranus setMass : 14.5];
    [uranus setTexture : @"Uranus"];
    [uranus setName : @"Uranus"];
    
    // Neptune
    Satellite *neptune = [[Satellite alloc] init];
    [neptune setEccentricity : 0.009];
    [neptune setInclination  : 1.77];
    [neptune setDistance : 30.05 * scale fromBody : sun];
    [neptune setMass : 17.2];
    [neptune setTexture : @"Neptune"];
    [neptune setName : @"Neptune"];
    
    // Pluto -- Requires Charon for accuracy, which means another
    // update to the orbital velocity to include centers of masses
    // of multiple body systems. Could be helpful for binary stars.
    Satellite *pluto = [[Satellite alloc] init];
    [pluto setEccentricity : 0.248];
    [pluto setInclination  : 17.14];
    [pluto setDistance : 39.48 * scale fromBody : sun];
    [pluto setMass : 0.002];
    [pluto setTexture : @"Pluto"];
    [pluto setName : @"Pluto"];
    
    // Add the bodies to the array
    [bodies addObject:sun];
    [bodies addObject:mercury];
    [bodies addObject:venus];
    [bodies addObject:earth];
    [bodies addObject:moon];
    [bodies addObject:mars];
    [bodies addObject:ceres];
    [bodies addObject:jupiter];
    [bodies addObject:saturn];
    [bodies addObject:uranus];
    [bodies addObject:neptune];
    [bodies addObject:pluto];
}

- (void) randomBodies
{
    // Create a massive star first
    Satellite *star = [[Satellite alloc] init];
    [star setMass : 5000 * scale];
    [bodies addObject:star];
    
    // Create all of the bodies
    for (int i = 0; i < 30; i++)
    {
        // Create the body
        Satellite *body = [[Satellite alloc] init];
        [body setEccentricity  : arc4random_uniform(50) / 100.0];
        [body setInclination   : arc4random_uniform(30)];
        [body setDistance : ((arc4random_uniform(200) / 100.0 * scale + scale / 10))];
        [body setMass : arc4random_uniform(20000) / 100.0 + 1];
        
        // Add the body to the array
        [bodies addObject:body];
    }
}

- (void) binaryStars
{
    // Create a massive star first
    Satellite *star = [[Satellite alloc] init];
    [star isStar : true];
    [star setPosition: 0.0 : 1.0 * scale : 0];
    [star setTexture : @"Sun"];
    [star setMass : 1000];
    
    // Another star
    Satellite *star2 = [[Satellite alloc] init];
    [star2 isStar : true];
    [star2 setPosition: 0.0 : - 1.0 * scale : 0];
    [star2 setTexture : @"Sun"];
    [star2 setMass : 1000];
    
    // Set the relative bodies and add to the system
    [star  setOrbitalBody : star2];
    [star2 setOrbitalBody : star];
    [bodies addObject:star];
    [bodies addObject:star2];
}

/* * * * * * * * * *
 
 Calculations ahoy
 
 * * * * * * * * * */

- (void) calculateInitialVelocities
{
    for (Satellite *body in bodies)
    {
        // If the body orbits something else, calculate with respect to that body
        if (!body.orbitalBody)
        {
            [body setOrbitalBody : barycenter];
        }
        
        // Determine the orbital velocity
        [self calculateOrbitalVelocity : body];
    }
}

- (void) calculateOrbitalVelocity : (Satellite *) body
{
    // Get the body orbited
    Satellite * actor = body.orbitalBody;
    
    // Get the relative position
    Vector * relPosition = [[Vector alloc] init];
    relPosition.x = body.position.x - actor.position.x;
    relPosition.y = body.position.y - actor.position.y;
    relPosition.z = body.position.z - actor.position.z;
    
    // Get the variables
    float a = [relPosition getMagnitude];
    float m = (body.mass + actor.mass) / barycenter.mass;
    float e = body.eccentricity;
    float velocity = sqrtf(G * m * (1 + e) / (a));
    float theta    = atanf(relPosition.y / relPosition.x);
    
    // Bail if too close
    if (a < 0.01) { return; }
    
    // Get the coordinates of the velocity
    // Reverse the direction in quadrants where x is negative
    float vx =   velocity * sinf(theta) * (relPosition.x < 0 ? -1 : 1);
    float vy = - velocity * cosf(theta) * (relPosition.x < 0 ? -1 : 1);
    float vz = 0;
    
    // Velocity
    [body setVelocity: actor.velocity.x + vx : actor.velocity.y + vy : actor.velocity.z + vz];
}

// Calculate the acceleration - n^2 operation
- (void) calculateCurrentPositions
{
    // First, we need the accelerations
    [self calculateGravity];
    
    // Get the new velocities and positions
    for (Satellite *body in bodies)
    {
        // Velocities
        body.velocity.x += 0.5 * body.acceleration.x * dt;
        body.velocity.y += 0.5 * body.acceleration.y * dt;
        body.velocity.z += 0.5 * body.acceleration.z * dt;
        
        // Positions
        body.position.x += body.velocity.x * dt;
        body.position.y += body.velocity.y * dt;
        body.position.z += body.velocity.z * dt;
    }
    
    // Recalculate accelerations
    [self calculateGravity];
    
    // Leapfrog method
    for (Satellite * body in bodies)
    {
        // Velocities
        body.velocity.x += 0.5 * body.acceleration.x * dt;
        body.velocity.y += 0.5 * body.acceleration.y * dt;
        body.velocity.z += 0.5 * body.acceleration.z * dt;
    }
}

- (void) calculateGravity
{
    for (Satellite * body in bodies)
    {
        // Reset accelerations
        body.acceleration.x = 0;
        body.acceleration.y = 0;
        body.acceleration.z = 0;
        
        for (Satellite * actor in bodies)
        {
            // Obviously don't calculate itself
            if (actor == body) { continue; }
            
            // Get the magnitude of the total distance
            Vector * difference = [[Vector alloc] init];
            difference.x = actor.position.x - body.position.x;
            difference.y = actor.position.y - body.position.y;
            difference.z = actor.position.z - body.position.z;
            float dr = [difference getMagnitude];
            
            // Don't allow calculations close to the same point
            // Soon, don't allow calculations when bodies touch
            if (abs(dr) < 1 / scale) { continue; }
            
            // Update accelerations
            float massRatio = actor.mass / barycenter.mass;
            body.acceleration.x += (G * difference.x * massRatio) / pow(dr, 3);
            body.acceleration.y += (G * difference.y * massRatio) / pow(dr, 3);
            body.acceleration.z += (G * difference.z * massRatio) / pow(dr, 3);
        }
    }
}

- (void) translateToBody : (NSString *) name
{
    // Find the body
    for (Satellite * center in bodies)
    {
        // Find a matching name
        if (![name isEqualToString : center->name]) { continue; }
        
        // Move everything wrt the body in question
        for (Satellite * body in bodies)
        {
            if (body == center) { continue; }
            
            body.position.x -= center.position.x;
            body.position.y -= center.position.y;
            body.position.z -= center.position.z;
        }
        
        // Lastly, move this body
        center.position.x = 0.0;
        center.position.y = 0.0;
        center.position.z = 0.0;

        break;
    }
}

- (void) translateToCenterOfMass
{
    // Calculate the center of mass
    [self calculateCenterOfMass];
    
    // Move everything wrt com
    for (Satellite * body in bodies)
    {
        body.position.x -= barycenter.position.x;
        body.position.y -= barycenter.position.y;
        body.position.z -= barycenter.position.z;
    }
    
    // Adjust the size of the center of mass
    barycenter.size = 10;
}

// Center of mass calculation:
// R = 1 / M * sum of individual masses * positions
- (void) calculateCenterOfMass
{
    // Reset the values
    barycenter.mass       = 0;
    barycenter.position.x = 0;
    barycenter.position.y = 0;
    barycenter.position.z = 0;
    
    for (Satellite * body in bodies)
    {
        // Add to the sum of masses
        barycenter.mass += body.mass;
        
        // Here, get the sum of masses and positions
        barycenter.position.x += body.position.x * body.mass;
        barycenter.position.y += body.position.y * body.mass;
        barycenter.position.z += body.position.z * body.mass;
    }
    
    if (barycenter.mass == 0)
    {
        return;
    }
    
    // Now divide by the total mass
    barycenter.position.x /= barycenter.mass;
    barycenter.position.y /= barycenter.mass;
    barycenter.position.z /= barycenter.mass;
}

@end
