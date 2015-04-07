//
//  SceneSatellite.m
//  Satellites
//
//  Created by Richard Benjamin Heidorn on 4/27/13.
//  Copyright (c) 2013 Richard B Heidorn. All rights reserved.
//

#import "SceneSatelliteModel.h"
#import "sphere.h"

@implementation SceneSatelliteModel

@synthesize vertices;
@synthesize normals;

// Initialize using the sphere.h file
- (id) initWithRadius : (GLfloat) radius
{
    // Get the sizes of the arrays
    int numVertices = sizeof sphereVerts / sizeof sphereVerts[0];
    //int numTextures = sizeof sphereTexCoords / sizeof sphereTexCoords[0];

    // Create our vertices arrays
    vertices = (GLfloat *) malloc(sizeof sphereVerts);
    normals  = (GLfloat *) malloc(sizeof sphereNormals);

    // Change the sphere vertices to resize the body
    for (int i = 0; i < numVertices; i++)
    {
        vertices[i] = sphereVerts[i]   * radius;
        normals[i]  = sphereNormals[i] * radius;
    }

    SceneMesh * satelliteMesh = [[SceneMesh alloc]
                                 initWithPositionCoords:vertices
                                 normalCoords:normals
                                 texCoords0:sphereTexCoords
                                 numberOfPositions:sphereNumVerts
                                 indices:NULL
                                 numberOfIndices:0];
    
    if(nil != (self = [super initWithName:@"satellite"
                                     mesh:satelliteMesh
                         numberOfVertices:sphereNumVerts]))
    {
        [self updateAlignedBoundingBoxForVertices:sphereVerts
                                            count:sphereNumVerts];
    }
    
    return self;
}

- (id) updateRadius : (GLfloat) radius
{
    // Get the sizes of the arrays
    int numVertices = sizeof sphereVerts / sizeof sphereVerts[0];

    // Change the sphere vertices to resize the body
    for (int i = 0; i < numVertices; i++)
    {
        vertices[i] = sphereVerts[i]   * radius;
        normals[i]  = sphereNormals[i] * radius;
    }
    
    // This is probably pretty fucked for memory
    SceneMesh * satelliteMesh = [[SceneMesh alloc]
                                 initWithPositionCoords:vertices
                                 normalCoords:normals
                                 texCoords0:sphereTexCoords
                                 numberOfPositions:sphereNumVerts
                                 indices:NULL
                                 numberOfIndices:0];
    
    // Update the mesh and bounding box
    self.mesh = nil;
    self.mesh = satelliteMesh;
    [self updateAlignedBoundingBoxForVertices:sphereVerts
                                        count:sphereNumVerts];
    
    return self;
}

@end
