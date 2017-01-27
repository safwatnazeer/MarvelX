//
//  MarvelComic.h
//  MarvelX
//
//  Created by Safwat Shenouda on 27/01/2017.
//  Copyright © 2017 Safwat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MarvelComic : NSObject
@property (nonatomic,nonnull) NSString * title;
@property (nonatomic,nonnull) NSString * description;
@property (nonatomic,nullable) UIImage * image;
@property (nonatomic,nonnull) NSString * imageURLString;

-(_Nullable id) init:(NSString * _Nonnull)comicTitle  andDescription:(NSString * _Nonnull)comicDescription andURL:(NSString * _Nonnull)imageURL;
@end
