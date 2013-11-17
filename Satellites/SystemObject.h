//
//  SystemObject.h
//  Satellites
//
//  Created by Richard Benjamin Heidorn on 5/19/13.
//  Copyright (c) 2013 Richard B Heidorn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SatelliteObject;

@interface SystemObject : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet * satellites;

- (NSSet *) getStars;
- (NSSet *) getPlanets;

- (unsigned int) numSatellites;
- (unsigned int) numStars;
- (unsigned int) numPlanets;
- (unsigned int) numMoons;

- (NSString *) numSatellitesAsString;
- (NSString *) numStarsAsString;
- (NSString *) numPlanetsAsString;
- (NSString *) numMoonsAsString;

@end

@interface SystemObject (CoreDataGeneratedAccessors)

- (void)addSatellitesObject:(SatelliteObject *)value;
- (void)removeSatellitesObject:(SatelliteObject *)value;
- (void)addSatellites:(NSSet *)values;
- (void)removeSatellites:(NSSet *)values;

@end
