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




@interface MarvelClient : NSObject

@property (nonnull,nonatomic) ApiClient *apiClient;
@property (nonnull,nonatomic) NSMutableArray *charactersArray;
@property (nonnull,nonatomic) NSMutableArray *comicsArray;
@property (nonnull,nonatomic) NSMutableArray *letterCharactersArray;
@property (nonnull,nonatomic) NSMutableArray *lettersArray;
@property (nonnull,nonatomic) NSMutableArray *comicsCharacters;
@property (nonatomic,nonnull) NSCache *imageCache;



-(void) loadComics:(NSInteger)characterId withCompletionHandler:(void (^ _Nullable) (void)) completionHandler withOffset:(NSInteger)offset forLetterIndex:(NSInteger)index;
-(void) loadComicImage:(NSInteger)itemIndex withCompletionHandler:(void (^ _Nullable) (UIImage* _Nullable)) completionHandler;

//test
-(void) loadCharachters:(void (^ _Nullable) (void)) completionHandler withOffset:(NSInteger)offset forLetterIndex:(NSInteger)index;
-(void) loadImage:(NSInteger)itemIndex withCompletionHandler:(void (^ _Nullable) (UIImage* _Nullable)) completionHandler forLetterIndex:(NSInteger)index;
-(void) loadImage:(NSInteger)itemIndex withCompletionHandler:(void (^ _Nullable) (UIImage* _Nullable)) completionHandler forComicIndex:(NSInteger)index;
-(void) loadCharachters:(void (^ _Nullable) (void)) completionHandler forComic:(NSString *)comicId  andIndex:(NSInteger)index;

@end
