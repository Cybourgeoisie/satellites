//
//  TextureViewController.h
//  Satellites
//
//  Created by Richard Benjamin Heidorn on 8/21/13.
//  Copyright (c) 2013 Richard B Heidorn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UIKit/UIImage.h>
#import "TextureCollectionViewLayout.h"
#import "TextureCollectionViewCell.h"

@interface TextureViewController : UICollectionViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, weak)   IBOutlet TextureCollectionViewLayout * textureViewLayout;
@property (nonatomic, strong) NSMutableArray                       * albums;

@end
