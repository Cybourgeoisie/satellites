//
//  SatellitesAppDelegate.h
//  Satellites
//
//  Created by Richard Benjamin Heidorn on 4/14/13.
//  Copyright (c) 2013 Richard B Heidorn. All rights reserved.
//

@interface SatellitesAppDelegate : UIResponder <UIApplicationDelegate>
{
    // Navigation Controller
    UINavigationController * navigationController;
    
    // Window
    UIWindow *window;
	
    // Core Data
    NSPersistentStoreCoordinator * persistentStoreCoordinator;
    NSManagedObjectModel         * managedObjectModel;
    NSManagedObjectContext       * managedObjectContext;
}

// Navigation View Controller
@property (nonatomic, retain) UINavigationController * navigationController;

// Window
@property (strong, nonatomic) UIWindow * window;

// Core Data
@property (nonatomic, retain, readonly) NSManagedObjectContext       * managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel         * managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator * persistentStoreCoordinator;

- (NSString *) applicationDocumentsDirectory;
- (void)       saveContext;

@end