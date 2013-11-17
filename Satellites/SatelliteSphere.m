//
//  SatelliteSphere.m
//  Satellites
//
//  Created by Richard Benjamin Heidorn on 4/14/13.
//  Copyright (c) 2013 Richard B Heidorn. All rights reserved.
//

#import "SatelliteSphere.h"
#import "sphere.h"

@implementation SatelliteSphere

@synthesize vertexPositionBuffer;
@synthesize vertexNormalBuffer;
@synthesize vertexTextureCoordBuffer;

- (SatelliteSphere *) init
{
    return [self createSphere : 1.0f];
}

- (SatelliteSphere *) createSphere : (GLfloat) size
{
    // Create the vertices buffer
    self.vertexPositionBuffer = [[AGLKVertexAttribArrayBuffer alloc]
                                 initWithAttribStride:(3 * sizeof(GLfloat))
                                 numberOfVertices:sizeof(sphereVerts) / (3 * sizeof(GLfloat))
                                 bytes:sphereVerts
                                 usage:GL_STATIC_DRAW];
    
    // Create the normal buffer
    self.vertexNormalBuffer = [[AGLKVertexAttribArrayBuffer alloc]
                               initWithAttribStride:(3 * sizeof(GLfloat))
                               numberOfVertices:sizeof(sphereNormals) / (3 * sizeof(GLfloat))
                               bytes:sphereNormals
                               usage:GL_STATIC_DRAW];
    
    // Create the texture buffer
    self.vertexTextureCoordBuffer = [[AGLKVertexAttribArrayBuffer alloc]
                                     initWithAttribStride:(2 * sizeof(GLfloat))
                                     numberOfVertices:sizeof(sphereTexCoords) / (2 * sizeof(GLfloat))
                                     bytes:sphereTexCoords
                                     usage:GL_STATIC_DRAW];
    
    return self;
}

- (void) drawSphere : (GLfloat) x : (GLfloat) y : (GLfloat) z : (GLfloat) rot
{
    // Load the identity matrix for translation and rotation operations
    glLoadIdentity();
    glTranslatef(x, y, z);
    glRotatef(rot, 0.0f, 1.0f, 0.0f);
    
    glEnableClientState(GL_VERTEX_ARRAY);
    glEnableClientState(GL_NORMAL_ARRAY);
    
    // Prepare to draw the buffers
    [self.vertexPositionBuffer
     prepareToDrawWithAttrib:GLKVertexAttribPosition
     numberOfCoordinates:3
     attribOffset:0
     shouldEnable:YES];
    [self.vertexNormalBuffer
     prepareToDrawWithAttrib:GLKVertexAttribNormal
     numberOfCoordinates:3
     attribOffset:0
     shouldEnable:YES];
    [self.vertexTextureCoordBuffer
     prepareToDrawWithAttrib:GLKVertexAttribTexCoord0
     numberOfCoordinates:2
     attribOffset:0
     shouldEnable:YES];
    
    glDisableClientState(GL_VERTEX_ARRAY);
    glDisableClientState(GL_NORMAL_ARRAY);
    
    // Draw triangles using vertices in the prepared vertex mbuffers
    [AGLKVertexAttribArrayBuffer
     drawPreparedArraysWithMode:GL_TRIANGLES
     startVertexIndex:0
     numberOfVertices:sphereNumVerts];
}

@end
