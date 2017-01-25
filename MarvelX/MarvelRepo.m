//
//  MarvelRepo.m
//  MarvelX
//
//  Created by Safwat Shenouda on 22/01/2017.
//  Copyright © 2017 Safwat. All rights reserved.
//

#import "MarvelRepo.h"

@implementation MarvelRepo
@synthesize imageCache;

-(id) init {
    if (self = [super init]) {
        self.apiClient = [[ApiClient alloc]init];
        self.charactersArray = [[NSMutableArray alloc]init];
        self.imageCache = [[NSCache alloc]init];
    }
    return self;
}

-(void) loadCharachters:(void (^) (void)) completionHandler withOffset:(NSInteger)offset{
//-(void) loadCharachters:(void (^ _Nullable) (NSDictionary* _Nullable)) completionHandler {
//https://gateway.marvel.com:443/v1/public/characters?name=iron%20man&
    NSString * targetURLString = [[NSString alloc]initWithFormat:@"https://gateway.marvel.com:443/v1/public/characters?offset=%lu&limit=50&",offset ];
    [self.apiClient downloadJson:targetURLString withCompletionHandler:^(NSDictionary * _Nullable dict) {
        
        //NSLog(@"name= %@",[dict valueForKeyPath:@"data.results.name"]);
        //NSLog(@"url= %@",[dict valueForKeyPath:@"data.results.thumbnail.path"]);
        // load image
        NSArray *results = [dict valueForKeyPath:@"data.results"];
        for (NSDictionary *aResult in results) {
            
            NSString *path =[aResult valueForKeyPath:@"thumbnail.path"];
            NSString *name =[aResult valueForKeyPath:@"name"];
            NSString *imageURLString =[[NSString alloc] initWithFormat:@"%@/portrait_uncanny.jpg",path];
            MarvelCharacter *marvelCharacter = [[MarvelCharacter alloc] init:name andURL:imageURLString];
            NSLog(@"Image path: %@",path);
            // check if image available then add it to charahters else ignor it
            if (![path containsString:@"image_not_available"]) {
            [self.charactersArray addObject:marvelCharacter];
            //NSLog(@"\narray count = %lu",self.charactersArray.count);
            }
        }
        
        completionHandler();
        
    }];
    
    //[self.apiClient downloadJson:@"https://gateway.marvel.com:443/v1/public/characters?name=iron%20man" withCompletionHandler:completionHandler];
}

-(void) loadImage:(NSInteger)itemIndex withCompletionHandler:(void (^ _Nullable) (UIImage* _Nullable)) completionHandler {
    
    MarvelCharacter *aCharacter = self.charactersArray[itemIndex];
    
    // check if image exists in cache
    UIImage *imageFromCache = [imageCache objectForKey:aCharacter.imageURLString];
    if (imageFromCache) {
        NSLog(@"Loaded from cache: >>> %@ for row:%lu ", aCharacter.name ,itemIndex);
        completionHandler(imageFromCache);
    } else
    // load image
    {
        [self.apiClient downloadImage:aCharacter.imageURLString withCompletionHandler:^(UIImage * _Nullable image) {
            [self.imageCache setObject:image forKey:aCharacter.imageURLString];
            NSLog(@"Loaded from Internet VVVV: %@ for row:%lu ", aCharacter.name ,itemIndex);
            completionHandler(image);
            
        }];
    }
    
    
}

@end
