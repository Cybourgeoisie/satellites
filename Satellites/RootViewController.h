//
//  RootViewController.h
//  Satellites
//
//  Created by Richard Benjamin Heidorn on 5/21/13.
//  Copyright (c) 2013 Richard B Heidorn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UINavigationController
{
    // Core Data
	NSManagedObjectContext * managedObjectContext;
}

// Core Data
@property (nonatomic, retain) NSManagedObjectContext * managedObjectContext;

// Public Methods
- (void) didFinishWithSave : (BOOL) save;

@end
