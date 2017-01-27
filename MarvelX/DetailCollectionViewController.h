//
//  DetailCollectionViewController.h
//  MarvelX
//
//  Created by Safwat Shenouda on 26/01/2017.
//  Copyright © 2017 Safwat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MarvelRepo.h"

@interface DetailCollectionViewController : UICollectionViewController
@property (nonatomic,nullable) MarvelRepo *marvel;
@property (nonatomic,nonnull) NSIndexPath *itemIndex;
@end
