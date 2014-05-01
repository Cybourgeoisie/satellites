//
//  SceneSatellite.h
//  Satellites
//
//  Created by Richard Benjamin Heidorn on 4/27/13.
//  Copyright (c) 2013 Richard B Heidorn. All rights reserved.
//


#import "SceneMesh.h"
#import "SceneModel.h"

@interface SceneSatelliteModel : SceneModel

@property (nonatomic) GLfloat * vertices;
@property (nonatomic) GLfloat * normals;

- (id) initWithRadius : (GLfloat) radius;
- (id) updateRadius : (GLfloat) radius;

@end
