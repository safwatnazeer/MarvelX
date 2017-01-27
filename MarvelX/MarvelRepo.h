//
//  MarvelRepo.h
//  MarvelX
//
//  Created by Safwat Shenouda on 22/01/2017.
//  Copyright © 2017 Safwat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ApiClient.h"
#import "MarvelCharacter.h"
#import "MarvelComic.h"




@interface MarvelRepo : NSObject

@property (nonnull,nonatomic) ApiClient *apiClient;
@property (nonnull,nonatomic) NSMutableArray *charactersArray;
@property (nonnull,nonatomic) NSMutableArray *comicsArray;

@property (nonatomic,nonnull) NSCache *imageCache;
//-(void) loadCharachters:(void (^ _Nullable) (NSDictionary* _Nullable)) completionHandler ;
-(void) loadCharachters:(void (^ _Nullable) (void)) completionHandler withOffset:(NSInteger)offset;
-(void) loadImage:(NSInteger)itemIndex withCompletionHandler:(void (^ _Nullable) (UIImage* _Nullable)) completionHandler;
-(void) loadComics:(NSInteger)characterId withCompletionHandler:(void (^ _Nullable) (void)) completionHandler withOffset:(NSInteger)offset;
-(void) loadComicImage:(NSInteger)itemIndex withCompletionHandler:(void (^ _Nullable) (UIImage* _Nullable)) completionHandler;
@end
