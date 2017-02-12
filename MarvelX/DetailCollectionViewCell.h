//
//  DetailCollectionViewCell.h
//  MarvelX
//
//  Created by Safwat Shenouda on 27/01/2017.
//  Copyright © 2017 Safwat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *description;
@property (weak, nonatomic,nullable) IBOutlet UICollectionView *relatedCollectionView;


@property (nonatomic) NSString *imageURL;
@end
