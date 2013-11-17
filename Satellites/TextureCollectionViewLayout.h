//
//  TextureCollectionViewLayout.h
//  Satellites
//
//  Created by Richard Benjamin Heidorn on 8/25/13.
//  Copyright (c) 2013 Richard B Heidorn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextureCollectionViewLayout : UICollectionViewLayout

@property (nonatomic)         UIEdgeInsets   itemInsets;
@property (nonatomic)         CGSize         itemSize;
@property (nonatomic)         CGFloat        interItemSpacingY;
@property (nonatomic)         NSInteger      numberOfColumns;
@property (nonatomic, strong) NSDictionary * layoutInfo;

@end
