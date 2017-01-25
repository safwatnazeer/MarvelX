//
//  MarvelCollectionViewController.h
//  MarvelX
//
//  Created by Safwat Shenouda on 21/01/2017.
//  Copyright © 2017 Safwat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MarvelRepo.h"

@interface MarvelCollectionViewController : UICollectionViewController

@property (nonnull,nonatomic) UIImage *image;
@property (nonatomic,nullable) MarvelRepo *marvel;
@property (nonatomic) BOOL stillLoading;
@property (nonatomic) NSInteger currentOffset; //support pagination to allow large number of characters


@end
