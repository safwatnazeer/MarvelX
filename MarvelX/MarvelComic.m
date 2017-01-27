//
//  MarvelComic.m
//  MarvelX
//
//  Created by Safwat Shenouda on 27/01/2017.
//  Copyright © 2017 Safwat. All rights reserved.
//

#import "MarvelComic.h"

@implementation MarvelComic
@synthesize image,imageURLString,title,description;
-(id) init:(NSString *)comicTitle  andDescription:(NSString *)comicDescription andURL:(NSString *)imageURL {
    
    if (self = [super init]) {
        self.title = comicTitle;
        self.description = comicDescription;
        self.imageURLString = imageURL;
        
    }
    return self;
}

@end
