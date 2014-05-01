//
//  SceneSatellite.h
//  Satellites
//
//  Created by Richard Benjamin Heidorn on 4/27/13.
//  Copyright (c) 2013 Richard B Heidorn. All rights reserved.
//

#import <GLKit/GLKit.h>
#import "SceneModel.h"
#import "SceneSatelliteModel.h"

@protocol SceneSatelliteControllerProtocol

- (NSTimeInterval)timeSinceLastUpdate;

@end


@interface SceneSatellite : NSObject

@property (strong, nonatomic, readwrite) SceneSatelliteModel * model;
@property (assign, nonatomic, readwrite) GLKVector3   position;
@property (assign, nonatomic, readwrite) GLfloat      tilt;
@property (assign, nonatomic, readwrite) GLfloat      rotationSpeed;
@property (assign, nonatomic, readwrite) GLKVector4   color;
@property (assign, nonatomic, readwrite) GLfloat      radius;
@property (assign, nonatomic, readwrite) GLfloat      currentRotation;
@property (nonatomic, readwrite) GLKTextureInfo * texture;

- (id) initWithPosition : (GLKVector3) aPosition
               rotation : (GLfloat)    aRotation
                   tilt : (GLfloat)    aTilt
                 radius : (GLfloat)    aRadius
                  color : (GLKVector4) aColor
                texture : (NSString *)  aTexture;

- (void) updateBody : (GLfloat) x : (GLfloat) y : (GLfloat) z;
- (void) updateSize : (GLfloat) size;

- (void) drawWithBaseEffect:(GLKBaseEffect *)anEffect;

@end


extern GLfloat SceneScalarFastLowPassFilter(
                                            NSTimeInterval timeSinceLastUpdate,
                                            GLfloat target,
                                            GLfloat current);

extern GLfloat SceneScalarSlowLowPassFilter(
                                            NSTimeInterval timeSinceLastUpdate,
                                            GLfloat target,
                                            GLfloat current);

extern GLKVector3 SceneVector3FastLowPassFilter(
                                                NSTimeInterval timeSinceLastUpdate,
                                                GLKVector3 target,
                                                GLKVector3 current);

extern GLKVector3 SceneVector3SlowLowPassFilter(
                                                NSTimeInterval timeSinceLastUpdate,
                                                GLKVector3 target,
                                                GLKVector3 current);
