//
//  MarvelCharachter.m
//  MarvelX
//
//  Created by Safwat Shenouda on 22/01/2017.
//  Copyright © 2017 Safwat. All rights reserved.
//

#import "MarvelCharacter.h"

@implementation MarvelCharacter
@synthesize image,imageURLString,name;

-(id) init:(NSString *)charName andURL:(NSString *)imageURL  andId:(NSString *)charId{
    
    if (self = [super init]) {
        self.name = charName;
        self.imageURLString = imageURL;
        self.characterId = charId;
        
    }
    return self;
}

@end
