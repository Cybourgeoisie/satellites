//
//  SatelliteSphere.h
//  Satellites
//
//  Created by Richard Benjamin Heidorn on 4/14/13.
//  Copyright (c) 2013 Richard B Heidorn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#import "AGLKVertexAttribArrayBuffer.h"

@interface SatelliteSphere : NSObject
{
    AGLKVertexAttribArrayBuffer * vertexPositionBuffer;
    AGLKVertexAttribArrayBuffer * vertexNormalBuffer;
    AGLKVertexAttribArrayBuffer * vertexTextureCoordBuffer;
}

@property (strong, nonatomic) AGLKVertexAttribArrayBuffer * vertexPositionBuffer;
@property (strong, nonatomic) AGLKVertexAttribArrayBuffer * vertexNormalBuffer;
@property (strong, nonatomic) AGLKVertexAttribArrayBuffer * vertexTextureCoordBuffer;

- (SatelliteSphere *) createSphere : (GLfloat) size;
- (void) drawSphere : (GLfloat) x : (GLfloat) y : (GLfloat) z : (GLfloat) rot;

@end