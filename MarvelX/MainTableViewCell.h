//
//  MainTableViewCell.h
//  MarvelX
//
//  Created by Safwat Shenouda on 05/02/2017.
//  Copyright © 2017 Safwat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MarvelClient.h"
#import "MainTableViewController.h"


@interface MainTableViewCell : UITableViewCell 

@property (weak, nonatomic,nullable) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic,nullable) IBOutlet UILabel *letterLabel;




@end
