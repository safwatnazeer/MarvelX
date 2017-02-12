//
//  DetailCollectionViewController.h
//  MarvelX
//
//  Created by Safwat Shenouda on 26/01/2017.
//  Copyright © 2017 Safwat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MarvelClient.h"

@interface DetailCollectionViewController : UICollectionViewController
@property (nonatomic,nullable) MarvelClient *marvel;
@property (nonatomic,nonnull) NSIndexPath *itemIndex;
@property (nonatomic) NSInteger letterIndex;
@property (nonatomic,nullable) UIActivityIndicatorView *activityIndicator;
@property (nonatomic,nonnull) NSMutableArray *stillLoadingArray;

@end
