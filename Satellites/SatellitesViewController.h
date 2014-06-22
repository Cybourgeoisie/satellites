//
//  SatellitesViewController.h
//  Satellites
//
//  Created by Richard Benjamin Heidorn on 4/14/13.
//  Copyright (c) 2013 Richard B Heidorn. All rights reserved.
//

#import <GLKit/GLKit.h>
#import "Vector.h"
#import "SatellitesController.h"
#import "SceneSatelliteModel.h"
#import "SceneSatellite.h"
#import "SystemObject.h"
#import "SatellitesMenuViewController.h"

@interface SatellitesViewController : GLKViewController
{
    SatellitesController * controller;
    
    // Menu
    UIBarButtonItem      * menuButton;
    NSMutableDictionary  * menuOptions;

    SystemObject         * system;
    NSMutableArray       * satellites;
    
    Satellite            * centralBody;
    
    NSMutableArray       * spheres;
    NSMutableArray       * bodies;
    GLKSkyboxEffect      * skybox;

    BOOL                   bLogMode;
    BOOL                   bEditorView;
    BOOL                   bUpdateSatellites;
}

@property (strong, nonatomic) GLKBaseEffect *baseEffect;
@property (strong, nonatomic) SatellitesController * controller;
@property (strong, nonatomic) SceneModel * satelliteModel;

// UI View Elements
@property (strong, nonatomic) UIBarButtonItem * menuButton;
@property (strong, nonatomic) NSMutableDictionary * menuOptions;

// Need to be cleaned up
@property (strong, nonatomic) SystemObject * system;
@property (strong, nonatomic) NSMutableArray * satellites;
@property (strong, nonatomic) Satellite * centralBody;

@property (strong, nonatomic) NSMutableArray * spheres;
@property (strong, nonatomic) NSMutableArray * bodies;
@property (strong, nonatomic) GLKSkyboxEffect * skybox;
@property (nonatomic, assign) GLKVector3 eyePosition;
@property (nonatomic, assign) GLKVector3 lookAtPosition;
@property (nonatomic, assign) GLKVector3 targetEyePosition;
@property (nonatomic, assign) GLKVector3 targetLookAtPosition;
@property (nonatomic, assign) GLKVector3 rotation;
@property (nonatomic, assign) GLfloat scale;
@property (nonatomic, assign) BOOL bLogMode;
@property (nonatomic, assign) BOOL bEditorView;
@property (nonatomic, assign) BOOL bUpdateSatellites;

// C'mon, c'mon, c'mon, c'mon, now touch me babe
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;

- (void)useEditorView:(BOOL)bUseView;
- (Satellite *)getSatelliteByManagedObject:(SatelliteObject *)satelliteObject;
- (void)propogateChanges:(Satellite *)satellite forProperty:(NSString *)property;

@end
