//
//  MarvelCharachter.h
//  MarvelX
//
//  Created by Safwat Shenouda on 22/01/2017.
//  Copyright © 2017 Safwat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MarvelCharacter : NSObject

@property (nonatomic,nonnull) NSString * name;
@property (nonatomic,nullable) UIImage * image;
@property (nonatomic,nonnull) NSString * imageURLString;

-(_Nullable id) init:(NSString  * _Nonnull )charName andURL:(NSString * _Nonnull)imageURL;


@end
