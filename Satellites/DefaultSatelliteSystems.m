//
//  DefaultSatelliteSystems.m
//  Satellites
//
//  Created by Richard Benjamin Heidorn on 5/4/14.
//  Copyright (c) 2014 Richard B Heidorn. All rights reserved.
//

#import "DefaultSatelliteSystems.h"

@implementation DefaultSatelliteSystems

@synthesize bodies;
@synthesize scale;

/* * * * * * * * * *
 
 Planetary Systems
 
 * * * * * * * * * */

- (id)init
{
    bodies = [[NSMutableArray alloc] init];
    return self;
}

- (NSMutableArray *) solarSystem
{
    // Sun
    Satellite *sun = [[Satellite alloc] init];
    [sun isStar : true];
    [sun setRotationSpeed: 0.05 * 1000];
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
    [earth setRotationSpeed: 0.01 * 3000];
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
    
    return bodies;
}

- (NSMutableArray *) randomBodies
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
    
    return bodies;
}

- (NSMutableArray *) binaryStars
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
    
    return bodies;
}

@end
