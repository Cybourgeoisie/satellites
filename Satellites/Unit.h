//
//  Unit.h
//  Satellites
//
//  Created by Richard Benjamin Heidorn on 5/5/14.
//  Copyright (c) 2014 Richard B Heidorn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Unit : NSObject
{
    // Internal
    NSArray const * unitTypes;
    NSArray const * unitValues;
    NSArray const * unitNames;
    NSArray const * unitAbbrs;

    // External
    NSString * type;
    NSNumber * value;
    NSString * name;
    NSString * abbr;
}

@property (nonatomic, readonly)  NSArray  * unitTypes;
@property (nonatomic, readonly)  NSArray  * unitValues;
@property (nonatomic, readonly)  NSArray  * unitNames;
@property (nonatomic, readonly)  NSArray  * unitAbbrs;
@property (nonatomic, readwrite) NSString * type;
@property (nonatomic, readwrite) NSNumber * value;
@property (nonatomic, readwrite) NSString * name;
@property (nonatomic, readwrite) NSString * abbr;

- (id) initWithValue : (NSNumber *) unitValue forUnit : (NSString *) unitName;
- (Unit *) convertToBaseUnit;
- (Unit *) convertTo: (NSString *) unitName;
- (NSNumber *) convertValue : (NSNumber *) unitValue toUnit   : (NSString *) unitName;
- (NSNumber *) convertValue : (NSNumber *) unitValue fromUnit : (NSString *) unitName;
- (NSNumber *) getBaseValue;
- (NSNumber *) getValue;
- (NSString *) getAbbr;

@end
