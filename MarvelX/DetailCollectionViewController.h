//
//  DetailCollectionViewController.h
//  MarvelX
//
//  Created by Safwat Shenouda on 26/01/2017.
//  Copyright © 2017 Safwat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MarvelClient.h"
#import "ImageViewController.h"

@interface DetailCollectionViewController : UICollectionViewController <UIGestureRecognizerDelegate>
@property (nonatomic,nullable) MarvelClient *marvel;
@property (nonatomic,nonnull) NSIndexPath *itemIndex;
@property (nonatomic) NSInteger letterIndex;
@property (nonatomic,nullable) UIActivityIndicatorView *activityIndicator;
@property (nonatomic,nonnull) NSMutableArray *stillLoadingArray;
@property (nonnull,nonatomic) UITapGestureRecognizer *gestureRecognizer;
@property (nonnull,nonatomic) ImageViewController  *myPopoverController;

@end
