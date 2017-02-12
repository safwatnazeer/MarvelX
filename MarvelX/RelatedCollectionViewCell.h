//
//  RelatedCollectionViewCell.h
//  MarvelX
//
//  Created by Safwat Shenouda on 12/02/2017.
//  Copyright © 2017 Safwat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RelatedCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic) NSString *imageURL;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@end
