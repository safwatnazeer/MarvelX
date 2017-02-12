//
//  ImageViewController.h
//  MarvelX
//
//  Created by Safwat Shenouda on 12/02/2017.
//  Copyright © 2017 Safwat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic,nullable) UIImage* image;

@end
