//
//  MainTableViewController.h
//  MarvelX
//
//  Created by Safwat Shenouda on 05/02/2017.
//  Copyright © 2017 Safwat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MarvelClient.h"


@interface MainTableViewController : UITableViewController <UICollectionViewDataSource,UICollectionViewDelegate>


@property (nonatomic,nullable) MarvelClient *marvel;
//@property (nonatomic) BOOL stillLoading;
@property (nonatomic) NSInteger currentOffset; //support pagination to allow large number of characters
@property (nonatomic,nonnull) NSIndexPath* collectionViewItemIndex;
@property (nonatomic) NSInteger collectionViewTag;
@property (nonatomic,nonnull) NSMutableArray *stillLoadingArray;
//-(void) loadNextGroup;
@end
