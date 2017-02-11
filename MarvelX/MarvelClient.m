//
//  MarvelRepo.m
//  MarvelX
//
//  Created by Safwat Shenouda on 22/01/2017.
//  Copyright © 2017 Safwat. All rights reserved.
//

#import "MarvelClient.h"


@implementation MarvelClient
@synthesize imageCache;

-(id) init {
    if (self = [super init]) {
        self.apiClient = [[ApiClient alloc]init];
        self.charactersArray = [[NSMutableArray alloc]init];
        self.lettersArray = [[NSMutableArray alloc]init];
        self.letterCharactersArray = [[NSMutableArray alloc]init];
        
        for (NSInteger i=0;i<26;i++ ) {
            NSMutableArray *arr1= [[NSMutableArray alloc]init];
            [self.letterCharactersArray addObject:arr1];
            [self.lettersArray addObject:[NSString stringWithFormat:@"%c", i+65]]; // conver ascii code  to a string
         }

        self.imageCache = [[NSCache alloc]init];
    }
    return self;
}


-(void) loadCharachters:(void (^) (void)) completionHandler withOffset:(NSInteger)offset forLetterIndex:(NSInteger)index{
    
    //https://gateway.marvel.com:443/v1/public/characters?name=iron%20man&
    NSString * targetURLString = [[NSString alloc]initWithFormat:@"https://gateway.marvel.com:443/v1/public/characters?nameStartsWith=%@&offset=%lu&limit=20&modifiedSince=2005-01-01&orderBy=name&",self.lettersArray[index],offset ];
    [self.apiClient downloadJson:targetURLString withCompletionHandler:^(NSDictionary * _Nullable dict) {
        
       
        // load image
        NSArray *results = [dict valueForKeyPath:@"data.results"];
        for (NSDictionary *aResult in results) {
            
            NSString *path =[aResult valueForKeyPath:@"thumbnail.path"];
            NSString *name =[aResult valueForKeyPath:@"name"];
            NSString *characterId =[aResult valueForKeyPath:@"id"];
            
            
            
            NSString *imageURLString =[[NSString alloc] initWithFormat:@"%@/portrait_uncanny.jpg",path];
            MarvelCharacter *marvelCharacter = [[MarvelCharacter alloc] init:name andURL:imageURLString andId:characterId];
            
            // check if image available then add it to charahters else ignor it
            if (![path containsString:@"image_not_available"] ) {
                [self.letterCharactersArray[index] addObject:marvelCharacter];
            }
        }
        completionHandler();
    }];
 
}

-(void) loadImage:(NSInteger)itemIndex withCompletionHandler:(void (^ _Nullable) (UIImage* _Nullable)) completionHandler forLetterIndex:(NSInteger)index{
    
    NSMutableArray *arr = self.letterCharactersArray[index];
    MarvelCharacter *aCharacter = arr[itemIndex];
    
    // check if image exists in cache
    UIImage *imageFromCache = [imageCache objectForKey:aCharacter.imageURLString];
    if (imageFromCache) {
        //NSLog(@"Loaded from cache: >>> %@ for row:%lu ", aCharacter.name ,itemIndex);
        completionHandler(imageFromCache);
    } else
        // load image
    {
        [self.apiClient downloadImage:aCharacter.imageURLString withCompletionHandler:^(UIImage * _Nullable image) {
            [self.imageCache setObject:image forKey:aCharacter.imageURLString];
            //  NSLog(@"Loaded from Internet VVVV: %@ for row:%lu ", aCharacter.name ,itemIndex);
            completionHandler(image);
            
        }];
    }
    
    
}



-(void) loadComics:(NSInteger)itemIndex withCompletionHandler:(void (^) (void)) completionHandler withOffset:(NSInteger)offset forLetterIndex:(NSInteger)index{
    
    NSMutableArray *arr = self.letterCharactersArray[index];
    MarvelCharacter *aCharacter = arr[itemIndex];
    NSString * targetURLString = [[NSString alloc]initWithFormat:@"https://gateway.marvel.com:443/v1/public/characters/%@/comics?formatType=comic&orderBy=-onsaleDate&",aCharacter.characterId];
    
    [self.apiClient downloadJson:targetURLString withCompletionHandler:^(NSDictionary * _Nullable dict){
        
        NSLog(@"\napi returned..");
        NSArray *results = [dict valueForKeyPath:@"data.results"];
        for (NSDictionary *aResult in results) {
            NSString *path =[aResult valueForKeyPath:@"thumbnail.path"];
            NSString *title =[aResult valueForKeyPath:@"title"];
            NSString *description =[aResult valueForKeyPath:@"description"];
            NSString *imageURLString =[[NSString alloc] initWithFormat:@"%@/portrait_uncanny.jpg",path];
            MarvelComic *marvelComic = [[MarvelComic alloc] init:title andDescription:description andURL:imageURLString];
            [self.comicsArray addObject:marvelComic];
            
        }
        completionHandler();
    }];
}

-(void) loadComicImage:(NSInteger)itemIndex withCompletionHandler:(void (^ _Nullable) (UIImage* _Nullable)) completionHandler {
    
    MarvelComic *comic = self.comicsArray[itemIndex];
    
    // check if image exists in cache
    UIImage *imageFromCache = [imageCache objectForKey:comic.imageURLString];
    if (imageFromCache) {
      //  NSLog(@"Loaded from cache: >>> %@ for row:%lu ", comic.title ,itemIndex);
        completionHandler(imageFromCache);
    } else
        // load image
    {
        [self.apiClient downloadImage:comic.imageURLString withCompletionHandler:^(UIImage * _Nullable image) {
            [self.imageCache setObject:image forKey:comic.imageURLString];
          //  NSLog(@"Loaded from Internet VVVV: %@ for row:%lu ", comic.title ,itemIndex);
            completionHandler(image);
            
        }];
    }
 
}

@end
