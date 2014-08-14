//
//  SatellitesViewController.m
//  Satellites
//
//  Created by Richard Benjamin Heidorn on 4/14/13.
//  Copyright (c) 2013 Richard B Heidorn. All rights reserved.
//

#import "SatellitesViewController.h"

@implementation SatellitesViewController

@synthesize baseEffect;
@synthesize controller;
@synthesize menuButton;
@synthesize satelliteModel;

@synthesize system;
@synthesize satellites;

@synthesize spheres;
@synthesize bodies;
@synthesize skybox;
@synthesize eyePosition;
@synthesize lookAtPosition;
@synthesize rotation;
@synthesize scale;

@synthesize bLogMode;
@synthesize bEditorView;
@synthesize bUpdateSatellites;

- (id) init
{
    self = [super init];
    if (self)
    {
        // Any Initializations
    }
    
    return self;
}

- (void) useEditorView: (BOOL) bUseView
{
    self.bEditorView = bUseView;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    // Hide the toolbar
    self.navigationController.toolbarHidden = true;
    self.navigationController.navigationBar.translucent = NO;
    
    // Set the toolbar and menu stuff
    [self setToolbar];
    
    // Create the system
    [self initSystem];
    
    // Build the menu options
    [self buildMenuOptions];
    
    // Perform the setup operations
    [self initViewContext];
    
    // Create a base effect that provides standard OpenGL ES 2.0
    [self initBaseEffect];
    
    // Initiate gestures
    [self initGestureRecognizers];
    
    // Initialize the camera
    [self initCamera];
    
    // Set the background color of the current context
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
    
    // Context parameters
    glEnable(GL_DEPTH_TEST);
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
    // Generate, bind, and initialize contents of a buffer to be stored in GPU memory
    [self drawElements];
    
    // Lastly, provide the skybox
    [self initSkybox];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    // Set the viewing scale - log is 1, linear is 0
    bLogMode = !![[menuOptions valueForKey:@"viewScale"] intValue];

    // Set the central body
    centralBody = (Satellite *)[menuOptions objectForKey:@"followSatellite"];
    
    // Handle the focused body
    Satellite * newFocusBody = (Satellite *)[menuOptions objectForKey:@"focusSatellite"];
    
    // Reset the rotation, if focus satellite is new
    if (focusBody != newFocusBody)
        self.rotation = GLKVector3Make(0.0, 0.0, 0.0);

    // Set the look-at (focused) body
    focusBody = newFocusBody;
    
    // Update the satellite sizes if needed
    [self setSatelliteSizes];
}

- (void) setToolbar
{
    menuButton = [[UIBarButtonItem alloc] initWithTitle:@"Menu"
                                                  style:UIBarButtonSystemItemAction
                                                 target:self
                                                 action:@selector(openMenu)];
    self.navigationItem.rightBarButtonItem = menuButton;
}

- (void) openMenu
{
    // Go to the menu page
    [self performSegueWithIdentifier: @"OpenMenu" sender: self];
}

- (void) buildMenuOptions
{
    // Default options
    menuOptions = [[NSMutableDictionary alloc] init];
    [menuOptions setValue:NO forKey:@"showLabels"];
    [menuOptions setValue:NO forKey:@"showTrails"];
    [menuOptions setValue:[NSNumber numberWithBool:bLogMode] forKey:@"viewScale"];
    [menuOptions setValue:centralBody forKey:@"followSatellite"];
    [menuOptions setValue:focusBody   forKey:@"focusSatellite"];
}

#pragma mark - Segue management

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"OpenMenu"])
    {
        // Pass the selected book to the new view controller.
        SatellitesMenuViewController * menuViewController = (SatellitesMenuViewController *) [segue destinationViewController];
        [menuViewController setMenuOptions:menuOptions];
        [menuViewController setSatellites:bodies];
    }
}

- (void) initSystem
{
    // Check for a valid system
    if (system != nil)
    {
        // Initialize the controller with the system at hand
        controller = [[SatellitesController alloc] initWithSystemObject: system];
    }
    // Check for valid satellites
    else if (satellites != nil)
    {
        controller = [[SatellitesController alloc] initWithSatelliteObjects:satellites];
    }
    else
    {
        // Initialize the controller with default parameters
        controller = [[SatellitesController alloc] init];
    }
    
    // Get the bodies
    bodies = controller.bodies;
    
    // Set the central body to the first body
    if (!centralBody && [controller.bodies count] > 0)
        centralBody = (Satellite *)[controller.bodies objectAtIndex:0];

    // Set the focus body to nothing at all
    if (!focusBody)
        focusBody = nil;
}


// View context
- (void) initViewContext
{
    // Create the GLKView & ensure creation
    GLKView *view = (GLKView *) self.view;
    NSAssert([view isKindOfClass : [GLKView class]], @"View controller's view is not a GLKView");
    
    // Set the drawable depth
    view.drawableDepthFormat = GLKViewDrawableDepthFormat16;
    
    // Create an OpenGL ES 2.0 context and provide it to the view, then set current
    view.context = [[EAGLContext alloc] initWithAPI : kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext : view.context];
}

// Base Effect
- (void) initBaseEffect
{
    // Create a base effect that provides standard OpenGL ES 2.0
    self.baseEffect = [[GLKBaseEffect alloc] init];
    self.baseEffect.lightingType           = GLKLightingTypePerPixel;
    self.baseEffect.lightModelAmbientColor = GLKVector4Make(0.0f, 0.0f, 0.0f, 1.0f);
    self.baseEffect.colorMaterialEnabled   = GL_TRUE;

    // This little fucker caused me hours of grief over a malloc bug.
    //self.baseEffect.texture2d0.envMode = GLKTextureEnvModeModulate;
    
    self.baseEffect.light0.enabled      = GL_TRUE;
    self.baseEffect.light0.ambientColor = GLKVector4Make(0.1f, 0.1f, 0.1f, 1.0f);
    self.baseEffect.light0.diffuseColor = GLKVector4Make(1.0f, 1.0f, 1.0f, 1.0f);
    self.baseEffect.light0.position     = GLKVector4Make(0.0f, 0.0f, 0.1f, 0.0f);
}

// Gestures
- (void) initGestureRecognizers
{
    // Pinch
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handleScale:)];
    [self.view addGestureRecognizer : pinch];
}

// Camera Properties
- (void) initCamera
{
    if (bEditorView)
    {
        //[self initCameraEditorView];
        [self initCameraNormal];
    }
    else
    {
        [self initCameraNormal];
    }
}

- (void) initCameraNormal
{
    // Set initial point of view
    self.eyePosition    = GLKVector3Make(0.0, 0.0, 100.0);
    self.lookAtPosition = GLKVector3Make(0.0, 0.0, 0.0);

    // Set the current matrix propertites
    self.scale = 0.6;
    self.rotation = GLKVector3Make(0.0, 0.0, 0.0);
}

- (void) initCameraEditorView
{
    // Set initial point of view
    self.eyePosition    = GLKVector3Make(100.0, 0.0, 0.0);
    self.lookAtPosition = GLKVector3Make(0.0, 0.0, 0.0);

    // Set the current matrix propertites
    self.scale = 2.4;
    self.rotation = GLKVector3Make(0.0, -90.0, 0.0);
}

// Draw elements that belong in the scene
- (void) drawElements
{
    // Initialize the bodies
    spheres = [[NSMutableArray alloc] init];
    
    for (Satellite * body in bodies)
    {
        // Create the sphere
        SceneSatellite * sphere = [[SceneSatellite alloc]
                                    initWithPosition : GLKVector3Make(0.0, 0.0, 0.0)
                                    rotation : body.rotationSpeed
                                    tilt     : body.axialTilt
                                    radius   : body.size
                                    color    : GLKVector4Make(1.0f, 1.0f, 1.0f, 1.0f)
                                    texture  : body.texture];
        
        // Add to our collection
        [spheres addObject : sphere];
    }
}

- (Satellite *) getSatelliteByManagedObject : (SatelliteObject *)satelliteObject
{
    // Store the managed object ID
    NSManagedObjectID * MOID = [satelliteObject objectID];
    NSString * MOIDString = [[MOID URIRepresentation] absoluteString];
    
    for (Satellite * body in bodies)
    {
        if ([body.managedObjectId isEqualToString:MOIDString])
        {
            return body;
        }
    }
    
    return nil;
}

- (void) initSkybox
{
    // Get all six textures
    NSArray * paths = [[NSArray alloc] initWithObjects:
                       [[NSBundle bundleForClass:[self class]] pathForResource:@"right" ofType:@"png" inDirectory:@"skybox"],
                       [[NSBundle bundleForClass:[self class]] pathForResource:@"left" ofType:@"png" inDirectory:@"skybox"],
                       [[NSBundle bundleForClass:[self class]] pathForResource:@"south" ofType:@"png" inDirectory:@"skybox"],
                       [[NSBundle bundleForClass:[self class]] pathForResource:@"north" ofType:@"png" inDirectory:@"skybox"],
                       [[NSBundle bundleForClass:[self class]] pathForResource:@"top" ofType:@"png" inDirectory:@"skybox"],
                       [[NSBundle bundleForClass:[self class]] pathForResource:@"bottom" ofType:@"png" inDirectory:@"skybox"],
                       nil];
    
    // Get the texture infomation
    NSError *error = nil;
    GLKTextureInfo *skyboxTextureInfo = [GLKTextureLoader cubeMapWithContentsOfFiles:paths options:nil error:&error];
    NSAssert(nil != skyboxTextureInfo, @"Invalid skyboxTextureInfo: %@", error);

    // Create the skybox
    self.skybox = [[GLKSkyboxEffect alloc] init];
    self.skybox.textureCubeMap.name   = skyboxTextureInfo.name;
    self.skybox.textureCubeMap.target = skyboxTextureInfo.target;

    // Size up the skybox
    GLfloat maxDimension = 3000.0f;
    self.skybox.xSize = maxDimension;
    self.skybox.ySize = maxDimension;
    self.skybox.zSize = maxDimension;
    //self.skyboxEffect.center = GLKVector3Make(0.5f * maxDimension, 0.5f * maxDimension, 0.5f * maxDimension);
    self.skybox.center = GLKVector3Make(0.0f, 0.0f, 0.0f);
}

// Update operations
- (void) update
{
    // Calculate new positions
    [controller performCalculations];
    
    // Update scene
    [self updateCameraPosition];
}

// Any changes to the camera position
- (void) updateCameraPosition
{
    // Set the model view matrix to match current eye and look-at positions
    GLKMatrix4 modelViewMatrix = GLKMatrix4MakeLookAt(self.eyePosition.x, self.eyePosition.y, self.eyePosition.z,
                                                      self.lookAtPosition.x, self.lookAtPosition.y, self.lookAtPosition.z,
                                                      0, 1, 0);
    
    // Alter the view matrix
    modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, GLKMathDegreesToRadians(self.rotation.y), 1.0, 0.0, 0.0);
    modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, GLKMathDegreesToRadians(self.rotation.x), 0.0, 1.0, 0.0);
    modelViewMatrix = GLKMatrix4Scale(modelViewMatrix, scale, scale, scale);
    
    // Set the model view matrix
    self.baseEffect.transform.modelviewMatrix = modelViewMatrix;
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    // Clear Frame Buffer
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

    // Calculate the aspect ratio for the scene and setup a perspective projection
    const GLfloat aspectRatio = (GLfloat) view.drawableWidth / (GLfloat) view.drawableHeight;
    self.baseEffect.transform.projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(35.0f), aspectRatio, 0.01f, 100000000.0f * scale);

    // Alter the calculations if necessary
    [self updateSatellites];

    // Reposition all of the bodies to the scaled amount
    [self drawSatellites];

    // Draw the skybox
    [self drawSkybox];

    // Draw test path
    //[self drawQuadBezier];
}

- (void) castLight : (GLint) lightNum : (GLfloat) x : (GLfloat) y : (GLfloat) z
{
    GLKEffectPropertyLight * light;
    switch (lightNum)
    {
        case 1:
            light = self.baseEffect.light1;
            break;
        case 0:
        default:
            light = self.baseEffect.light0;
            break;
    }
    
    //light.enabled = GL_TRUE;
    light.spotCutoff = 180.0f;
    light.spotExponent = 45.0f;
    light.ambientColor = GLKVector4Make(0.1f, 0.1f, 0.1f, 1.0f);
    light.diffuseColor = GLKVector4Make(1.0f, 1.0f, 1.0f, 1.0f);
    //light.specularColor = GLKVector4Make(1.0f, 1.0f, 1.0f, 1.0f);
    light.position = GLKVector4Make(x, y, z, 1.0f);
    //light.quadraticAttenuation = 0.000002f;
    [self.baseEffect prepareToDraw];
}

- (void) drawSkybox
{
    glDisable(GL_BLEND);
    
    self.skybox.transform.projectionMatrix = self.baseEffect.transform.projectionMatrix;
    self.skybox.transform.modelviewMatrix  = GLKMatrix4Translate(self.baseEffect.transform.modelviewMatrix, self.lookAtPosition.x, self.lookAtPosition.y, self.lookAtPosition.z);
    
    [self.skybox prepareToDraw];
    [self.skybox draw];
    glBindVertexArrayOES(0);
}

- (void)propogateChanges:(Satellite *)satellite forProperty:(NSString *)property
{
    bUpdateSatellites = true;
    
    if (//[property isEqualToString:@"mass"]         ||
        [property isEqualToString:@"inclination"]  ||
        [property isEqualToString:@"eccentricity"] ||
        [property isEqualToString:@"semimajorAxis"])
    {
        [controller restartCalculations];
    }
}

- (void) updateSatellites
{
    // Only allow updating properties from editor mode
    if (!bEditorView || !bUpdateSatellites) { return; }

    int i = 0;
    for (Satellite * body in bodies)
    {
        // Update whatever is necessary
        [spheres[i] updateSize:body.size];
        [spheres[i] setTilt:body.axialTilt];
        [spheres[i] setRotationSpeed:body.rotationSpeed];
        i++;
    }
    
    bUpdateSatellites = false;
}

- (void) setSatelliteSizes
{
    int i = 0;
    for (Satellite * body in bodies)
    {
        float size;
        if (true) // bLogMode
        {
            size = log2f(pow(body.mass * 1000, 1.0/2.0f));
        }
        else
        {
            size = pow(body.mass, 1.0/3.0f) * 10;
        }
        
        [spheres[i++] updateSize:size];
    }
}

- (void) drawSatellites
{
    // Get the central body, and convert to log if needed
    Vector * center = [centralBody.position copy];
    if (bLogMode)
        center = [center getLogPosition];

    int i = 0;
    GLint starCount = 0;
    for (Satellite * body in bodies)
    {
        // Redraw each body
        float x, y, z;
        if (bLogMode && [body.position getMagnitude] > 0.01)
        {
            Vector * log = [body.position getLogPosition];
            x = ([log x] - [center x]) * 2.5;
            y = ([log y] - [center y]) * 2.5;
            z = ([log z] - [center z]) * 2.5;
        }
        else
        {
            x = (body.position.x - [center x]) / 40;
            y = (body.position.y - [center y]) / 40;
            z = (body.position.z - [center z]) / 40;
        }
        
        // If this body is a star, illuminate
        if ([body isStar])
        {
            if (!bEditorView)
            {
                [self castLight : starCount : x : y : z];
                [self disableLighting];
            }
        }
        
        // If this body is a moon, increase the spacing
        if (body.isMoon && [bodies count] > 1)
        {
            x += (body.position.x - body.orbitalBody.position.x);
            y += (body.position.y - body.orbitalBody.position.y);
            z += (body.position.z - body.orbitalBody.position.z);
        }

        // Render the body
        [spheres[i] updateBody : x : y : z];
        [spheres[i] drawWithBaseEffect : self.baseEffect];

        // Determine if we're looking at this satellite currently
        if (focusBody != nil && body == focusBody)
        {
            // Get the current angle from the x-y plane to the z-axis
            Vector * vec = [[Vector alloc] initWithCoordinates:x :y :z];
            [vec setMagnitude: -10];

            // Set the eye position and look at position
            self.eyePosition    = GLKVector3Make(vec.x, vec.y, vec.z);
            self.lookAtPosition = GLKVector3Make(x, y, z);
        }

        // If we're done with the star, turn the light back on
        if ([body isStar])
        {
            if (!bEditorView)
            {
                [self enableLighting];
            }
            
            starCount++;
        }
        
        // Keep count of the current satellite
        i++;
    }
}

- (void) disableLighting
{
    self.baseEffect.light1.enabled = GL_FALSE;
    self.baseEffect.light0.enabled = GL_FALSE;
}

- (void) enableLighting
{
    self.baseEffect.light1.enabled = GL_TRUE;
    self.baseEffect.light0.enabled = GL_TRUE;
}

- (void) drawQuadBezier
{
    GLKVector3 origin      = GLKVector3Make(0.0f, 0.0f, 0.0f);
    GLKVector3 control     = GLKVector3Make(10.0f, 5.0f, 0.0f);
    GLKVector3 destination = GLKVector3Make(20.0f, 10.0f, 0.0f);
    
    // Bezier quadratic code
    GLfloat vertices[12];
    GLfloat t = 0.0f;
    for (int i = 0; i < 4; i++)
    {
        vertices[i] = pow(1 - t, 2) * origin.x + 2.0 * (1 - t) * t * control.x + t * t * destination.x;
        vertices[i] = pow(1 - t, 2) * origin.y + 2.0 * (1 - t) * t * control.y + t * t * destination.y;
        vertices[i] = pow(1 - t, 2) * origin.x + 2.0 * (1 - t) * t * control.x + t * t * destination.x;
        t += 1.0f / 4.0f;
    }
    
    /*GLfloat verts[] = {
        0.0f, 0.0f, 0.0f,
        0.0f, 50.0f, 0.0f,
        30.0f, 30.0f, 50.0f,
        -10.0f, 50.0f, 0.0f};*/
    
    [self draw3dVertices: vertices : sizeof(vertices)];
    
}

- (void) draw3dVertices : (GLfloat *) verts : (size_t) sizeVerts
{
    // Turn off the lights
    self.baseEffect.light0.enabled = GL_FALSE;
    
    // Plain ol' color
    self.baseEffect.useConstantColor = GL_TRUE;
    self.baseEffect.constantColor = GLKVector4Make(0.0f, 1.0f, 0.0f, 1.0f);
    
    // Prepare for drawing
    [self.baseEffect prepareToDraw];
   
    // Create an handle for a buffer object array
    // Have OpenGL generate a buffer name and store it in the buffer object array
    // Bind the buffer object array to the GL_ARRAY_BUFFER target buffer
    GLuint bufferObjectNameArray;
    glGenBuffers(1, &bufferObjectNameArray);
    glBindBuffer(GL_ARRAY_BUFFER, bufferObjectNameArray);
    
    // Send the line data over to the target buffer in GPU RAM
    glBufferData(GL_ARRAY_BUFFER, sizeVerts, verts, GL_STATIC_DRAW);
    
    // Enable vertex data to be fed down the graphics pipeline to be drawn
    // Specify how the GPU looks up the data
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, // the currently bound buffer holds the data
                          3,                       // number of coordinates per vertex
                          GL_FLOAT,                // the data type of each component
                          GL_FALSE,                // can the data be scaled
                          3*sizeof(GLfloat),       // how many bytes per vertex (3 floats per vertex)
                          NULL);                   // offset to the first coordinate, in this case 0
    
    // Set the line width
    glLineWidth(2.0);
    
    // Render
    glDrawArrays(GL_LINE_STRIP, 0, 4);
    
    // Clean up
    glDisableVertexAttribArray(GLKVertexAttribPosition);
    self.baseEffect.light0.enabled = GL_TRUE;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event { }

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([touches count]) // Rotate this shit
	{
        // Movement -> Rotate
        [self handleRotate : touches withEvent: event];
    }
}

- (void) handleRotate: (NSSet *) touches withEvent: (UIEvent *) event
{
    UITouch* t = [touches anyObject];
    rotation.x += ([t locationInView:self.view].x - [t previousLocationInView:self.view].x) / 10.0f;
    rotation.y += ([t locationInView:self.view].y - [t previousLocationInView:self.view].y) / 10.0f;
}

- (void) handleScale : (UIPinchGestureRecognizer*) sender
{
    // Don't allow the user to go too far out
    if (scale < 0.15 && sender.scale < scale)
    {
        return;
    }
    
    if ([(UIPinchGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan)
    {
        sender.scale = scale;
    }
    else if ([(UIPinchGestureRecognizer*)sender state] != UIGestureRecognizerStateEnded)
    {
        scale = sender.scale;
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    // Make the view's context current
    GLKView *view = (GLKView *) self.view;
    [EAGLContext setCurrentContext:view.context];
    
    // Delete buffers that aren't needed when view is unloaded
    self.controller = nil;
    self.spheres    = nil;
    self.bodies     = nil;
    self.skybox     = nil;
    
    // Stop using the context created in -viewDidLoad
    ((GLKView *) self.view).context = nil;
    [EAGLContext setCurrentContext:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
