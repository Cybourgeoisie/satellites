//
//  SceneSatellite.m
//  Satellites
//
//  Created by Richard Benjamin Heidorn on 4/27/13.
//  Copyright (c) 2013 Richard B Heidorn. All rights reserved.
//

#import "SceneSatellite.h"

@implementation SceneSatellite

@synthesize model;
@synthesize position;
@synthesize rotation;
@synthesize color;
@synthesize radius;
@synthesize texture;
@synthesize currentRotation;

// Catch invalid initialization
- (id)init
{
    NSAssert(0, @"Invalid initializer");
    self = nil;
    return self;
}

- (id) initWithPosition : (GLKVector3) aPosition
               rotation : (GLfloat)    aRotation
                   tilt : (GLfloat)    aTilt
                 radius : (GLfloat)    aRadius
                  color : (GLKVector4) aColor
                texture : (NSString *) aTexture
{
    if(nil != (self = [super init]))
    {
        // Create the object// Create the object
        self.model = [[SceneSatelliteModel alloc] initWithRadius : aRadius];

        // Set attributes
        self.position = aPosition;
        self.rotation = aRotation;
        self.tilt     = aTilt;
        self.radius   = aRadius;
        self.color    = aColor;
        self.texture  = nil;
        
        // Set default values
        self.currentRotation = 0.0;
        
        // Assign the texture if one is provided
        if ([aTexture length] > 0)
        {
            // Find the image
            NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:aTexture ofType:@"jpg"];
            
            // Load the texture
            NSError *error = nil;
            self.texture = [GLKTextureLoader textureWithContentsOfFile:path
                                                               options:nil
                                                                 error:&error];
            NSAssert(self.texture != nil, @"Invalid texture: %@", error);
        }
    }
    
    return self;
}

// Update the state of the object
- (void) updateBody : (GLfloat) x : (GLfloat) y : (GLfloat) z
{
    self.position = GLKVector3Make(x, y, z);
}

/////////////////////////////////////////////////////////////////
// Draw the receiver: This method sets anEffect's current
// material color to the receivers color, translates to the
// receiver's position, rotates to match the receiver's yaw
// angle, draws the receiver's model. This method restores the
// values of anEffect's properties to values in place when the
// method was called.
- (void)drawWithBaseEffect:(GLKBaseEffect *)anEffect;
{
    // Save effect attributes that will be changed
    GLKMatrix4 savedModelviewMatrix  = anEffect.transform.modelviewMatrix;
    GLKVector4 savedDiffuseColor     = anEffect.material.diffuseColor;
    GLKVector4 savedAmbientColor     = anEffect.material.ambientColor;
    GLKEffectPropertyTexture * savedTexture = anEffect.texture2d0;
    
    // Translate to the model's position
    anEffect.transform.modelviewMatrix = GLKMatrix4Translate(savedModelviewMatrix, position.x, position.y, position.z);
    
    // Rotate to match the axis of rotation
    anEffect.transform.modelviewMatrix = GLKMatrix4Rotate(anEffect.transform.modelviewMatrix, self.tilt, 0.0, 1.0, 0.0);
    
    // Rotate about the x-z plane wrt time
    self.currentRotation += self.rotation;
    anEffect.transform.modelviewMatrix = GLKMatrix4Rotate(anEffect.transform.modelviewMatrix, self.currentRotation, 0.0, 0.0, 1.0);
    
    // Rotate to match model's yaw angle (rotation about Y)
    anEffect.transform.modelviewMatrix = GLKMatrix4Rotate(anEffect.transform.modelviewMatrix, - M_PI / 2.0, 1.0, 0.0, 0.0);
    
    // Set the model's material color
    anEffect.material.diffuseColor = self.color;
    anEffect.material.ambientColor = self.color;
    
    // Set the texture if one exists
    if (self.texture != nil)
    {
        anEffect.texture2d0.name   = self.texture.name;
        anEffect.texture2d0.target = self.texture.target;
    }

    // Prepare
    [anEffect prepareToDraw];
    
    // Draw
    [model draw];
    
    // Restore saved attributes
    anEffect.transform.modelviewMatrix = savedModelviewMatrix;
    anEffect.material.diffuseColor     = savedDiffuseColor;
    anEffect.material.ambientColor     = savedAmbientColor;
    anEffect.texture2d0.name           = savedTexture.name;
    anEffect.texture2d0.target         = savedTexture.target;
}

@end


/////////////////////////////////////////////////////////////////
// This function returns a value between target and current. Call
// this function repeatedly to asymptotically return values closer
// to target: "ease in" to the target value.
GLfloat SceneScalarFastLowPassFilter(
                                     NSTimeInterval elapsed,    // seconds elapsed since last call
                                     GLfloat target,            // target value to approach
                                     GLfloat current)           // current value
{  // Constant 50.0 is an arbitrarily "large" factor
    return current + (50.0 * elapsed * (target - current));
}


/////////////////////////////////////////////////////////////////
// This function returns a value between target and current. Call
// this function repeatedly to asymptotically return values closer
// to target: "ease in" to the target value.
GLfloat SceneScalarSlowLowPassFilter(
                                     NSTimeInterval elapsed,    // seconds elapsed since last call
                                     GLfloat target,            // target value to approach
                                     GLfloat current)           // current value
{  // Constant 4.0 is an arbitrarily "small" factor
    return current + (4.0 * elapsed * (target - current));
}


/////////////////////////////////////////////////////////////////
// This function returns a vector between target and current.
// Call repeatedly to asymptotically return vectors closer
// to target: "ease in" to the target value.
GLKVector3 SceneVector3FastLowPassFilter(
                                         NSTimeInterval elapsed,    // seconds elapsed since last call
                                         GLKVector3 target,         // target value to approach
                                         GLKVector3 current)        // current value
{
    return GLKVector3Make(
                          SceneScalarFastLowPassFilter(elapsed, target.x, current.x),
                          SceneScalarFastLowPassFilter(elapsed, target.y, current.y),
                          SceneScalarFastLowPassFilter(elapsed, target.z, current.z));
}


/////////////////////////////////////////////////////////////////
// This function returns a vector between target and current.
// Call repeatedly to asymptotically return vectors closer
// to target: "ease in" to the target value.
GLKVector3 SceneVector3SlowLowPassFilter(
                                         NSTimeInterval elapsed,    // seconds elapsed since last call
                                         GLKVector3 target,         // target value to approach
                                         GLKVector3 current)        // current value
{  
    return GLKVector3Make(
                          SceneScalarSlowLowPassFilter(elapsed, target.x, current.x),
                          SceneScalarSlowLowPassFilter(elapsed, target.y, current.y),
                          SceneScalarSlowLowPassFilter(elapsed, target.z, current.z));
}
