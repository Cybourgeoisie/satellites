//
//  Vector.h
//  SatellitesStarter
//
//  Created by Richard Benjamin Heidorn on 2/24/13.
//  Copyright (c) 2013 Richard B Heidorn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Vector : NSObject
{
@public
    float x;
    float y;
    float z;
}

@property float x;
@property float y;
@property float z;

- (Vector *) copy;
- (void)  set : (float) a : (float) b : (float) c;
- (float) getMagnitude;
- (Vector *) getLogPosition;

@end