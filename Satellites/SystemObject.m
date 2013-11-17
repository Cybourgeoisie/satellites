//
//  SystemObject.m
//  Satellites
//
//  Created by Richard Benjamin Heidorn on 5/19/13.
//  Copyright (c) 2013 Richard B Heidorn. All rights reserved.
//

#import "SystemObject.h"
#import "SatelliteObject.h"


@implementation SystemObject

@dynamic name;
@dynamic satellites;

- (NSSet *) getStars
{
    // Prepare to collect all stars
    NSMutableSet * stars = [[NSMutableSet alloc] init];
    
    // Get all satellites with bStar set
    for (SatelliteObject * satellite in [self satellites])
    {
        if ([satellite bStar])
        {
            [stars addObject:satellite];
        }
    }
    
    return stars;
}

- (NSSet *) getPlanets
{
    // Prepare to collect all stars
    NSMutableSet * planets = [[NSMutableSet alloc] init];
    
    // Get all satellites with bStar set
    for (SatelliteObject * satellite in [self satellites])
    {
        if (![satellite bStar] && ![satellite bMoon])
        {
            [planets addObject:satellite];
        }
    }
    
    return planets;
}

- (unsigned int) numSatellites
{
    return [[self satellites] count] + [self numMoons];
}

- (unsigned int) numStars
{
    // Prepare to get the number of stars
    unsigned int numStars = 0;
    
    // Get all satellites with bStar set
    for (SatelliteObject * satellite in [self satellites])
    {
        numStars += [satellite.bStar intValue];
    }
    
    return numStars;
}

- (unsigned int) numPlanets;
{
    return [[self satellites] count] - [self numStars];
}

- (unsigned int) numMoons;
{
    // Prepare to get the number of moons
    unsigned int numMoons = 0;
    
    // Get all satellites with bStar set
    for (SatelliteObject * satellite in [self satellites])
    {
        numMoons += [[satellite relativeBody] count];
    }
    
    return numMoons;
}

- (NSString *) numSatellitesAsString
{
    return [self prepareStringDescription:[self numSatellites] : @"Satellite"];
}

- (NSString *) numStarsAsString
{
    return [self prepareStringDescription:[self numStars] : @"Star"];
}

- (NSString *) numPlanetsAsString
{
    return [self prepareStringDescription:[self numPlanets] : @"Planet"];
}

- (NSString *) numMoonsAsString
{
    return [self prepareStringDescription:[self numMoons] : @"Moon"];
}

- (NSString *) prepareStringDescription : (unsigned int) number : (NSString *) property
{
    // Display the number of satellites
    NSString * string = [NSString stringWithFormat:[@"%d " stringByAppendingString:property], number];
    
    // Handle plural case
    if (number != 1)
    {
        // Add an 's' - 0 Satellites, 2 Satellites, 3.. etc.
        string = [string stringByAppendingString:@"s"];
    }
    
    return string;
}

@end
