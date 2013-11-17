//
//  SatelliteObject.h
//  Satellites
//
//  Created by Richard Benjamin Heidorn on 5/19/13.
//  Copyright (c) 2013 Richard B Heidorn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SatelliteObject, System;

@interface SatelliteObject : NSManagedObject

@property (nonatomic, retain) NSNumber * axialTilt;
@property (nonatomic, retain) NSNumber * bMoon;
@property (nonatomic, retain) NSNumber * bStar;
@property (nonatomic, retain) NSNumber * eccentricity;
@property (nonatomic, retain) NSNumber * inclination;
@property (nonatomic, retain) NSNumber * mass;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * rotation;
@property (nonatomic, retain) NSNumber * semimajorAxis;
@property (nonatomic, retain) NSNumber * size;
@property (nonatomic, retain) NSString * texture;
@property (nonatomic, retain) NSSet *relativeBody;
@property (nonatomic, retain) System *system;
@property (nonatomic, retain) SatelliteObject *orbitalBody;
@end

@interface SatelliteObject (CoreDataGeneratedAccessors)

- (void)addRelativeBodyObject:(SatelliteObject *)value;
- (void)removeRelativeBodyObject:(SatelliteObject *)value;
- (void)addRelativeBody:(NSSet *)values;
- (void)removeRelativeBody:(NSSet *)values;

@end
