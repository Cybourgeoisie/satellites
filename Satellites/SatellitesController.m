//
//  SatellitesController.m
//  SatellitesStarter
//
//  Created by Richard Benjamin Heidorn on 3/8/13.
//  Copyright (c) 2013 Richard B Heidorn. All rights reserved.
//

#import "SatellitesController.h"

static float G     = 100000; // 4 PI^2 * AU^3 / ( year ^2 * (solar system mass) )
static float dt    = 1;
static float scale = 1000;

@implementation SatellitesController
@synthesize satellites;
@synthesize bodies;
@synthesize barycenter;
@synthesize centralBody;
@synthesize bEditorView;

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
    [self setSatellites:[[systemObject.satellites allObjects] mutableCopy]];
    
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
    //scale = 1000;
}

- (void) initializeBodies
{
    // Instantiate
    barycenter = [[Satellite alloc] init];
    bodies     = [[NSMutableArray alloc] init];

    // Now create the system
    if (satellites != nil)
    {
        [self createSystem: satellites];
    }
    else
    {
        DefaultSatelliteSystems * defaults = [[DefaultSatelliteSystems alloc] init];
        [defaults setScale:scale];

        // Random method of generating planets
        //bodies = [defaults randomBodies];
        
        // Simple Solar System Model
        bodies = [defaults solarSystem];

        // Binary Stars
        //bodies = [defaults binaryStars];
    }
    
    // Set the central body
    centralBody = [bodies objectAtIndex:0];
}

- (void) createSystem : (NSMutableArray *) satelliteObjects
{
    for (SatelliteObject * satelliteObject in satelliteObjects)
    {
        // Create stars first
        if (!satelliteObject.bStar) { continue; }
        
        [self createSatellite: satelliteObject];
    }

    // PROBLEM: Multiple stars need to be able to revolve with each other.
    // Temporary solution is to only allow single and double star systems.
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
    for (SatelliteObject * satelliteObject in satelliteObjects)
    {
        // Already created stars
        if (satelliteObject.bStar) { continue; }
        
        [self createSatellite: satelliteObject];
    }
}

- (Satellite *) createStarCenter
{
    Satellite * starCenter = [[Satellite alloc] init];
    starCenter.mass       = 0;
    starCenter.position.x = 0;
    starCenter.position.y = 0;
    starCenter.position.z = 0;
    
    for (Satellite * body in bodies)
    {
        if (![body isStar]) { continue; }
        
        // Add to the sum of masses
        starCenter.mass += body.mass;
        
        // Here, get the sum of masses and positions
        starCenter.position.x += body.position.x * body.mass;
        starCenter.position.y += body.position.y * body.mass;
        starCenter.position.z += body.position.z * body.mass;
    }
    
    if (starCenter.mass == 0)
    {
        return starCenter;
    }
    
    // Now divide by the total mass
    starCenter.position.x /= starCenter.mass;
    starCenter.position.y /= starCenter.mass;
    starCenter.position.z /= starCenter.mass;
    
    return starCenter;
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
        [satellite setDistance: [satelliteObject.semimajorAxis floatValue] * scale fromBody: [self createStarCenter]];
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
        if (centralBody != barycenter)
        {
            [self translateToBody : centralBody];
        }
    }
    else
    {
        SatelliteObject * satellite = [satellites lastObject];
        [self translateToBodyByName : satellite.name];
    }
}

- (void) restartCalculations
{
    // Translate satellites to COM frame
    [self translateToCenterOfMass];
    
    // Calculuate initial velocities
    [self calculateInitialVelocities];
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
            [body setOrbitalBody : [self createStarCenter]];
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
    if (a < 0.005)
    {
        NSLog(@"Semi-major Axis too short, did not calculate velocity");
        return;
    }
    
    // Get the coordinates of the velocity
    // Reverse the direction in quadrants where x is negative
    // TODO: Calculate in 3D space
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
            if (abs(dr) < (1 / scale))
            {
                NSLog(@"Distance between satellite too short, did not calculate velocity");
                continue;
            }
            
            // Update accelerations
            float massRatio = actor.mass / barycenter.mass;
            body.acceleration.x += (G * difference.x * massRatio) / pow(dr, 3);
            body.acceleration.y += (G * difference.y * massRatio) / pow(dr, 3);
            body.acceleration.z += (G * difference.z * massRatio) / pow(dr, 3);
        }
    }
}

- (void) translateToBodyByName : (NSString *) name
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

- (void) translateToBody : (Satellite *) body
{
    // Find the body
    for (Satellite * center in bodies)
    {
        // Find a matching name
        if (body != center) { continue; }

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
