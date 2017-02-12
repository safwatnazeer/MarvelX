//
//  DetailCollectionViewCell.h
//  MarvelX
//
//  Created by Safwat Shenouda on 27/01/2017.
//  Copyright © 2017 Safwat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic,nullable) IBOutlet UILabel *title;
@property (weak, nonatomic,nullable) IBOutlet UIImageView *imageView;
@property (weak, nonatomic,nullable) IBOutlet UILabel *description;
@property (weak, nonatomic,nullable) IBOutlet UICollectionView *relatedCollectionView;


@property (nonatomic,nullable) NSString *imageURL;
@end
