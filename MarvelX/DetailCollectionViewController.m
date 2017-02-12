//
//  DetailCollectionViewController.m
//  MarvelX
//
//  Created by Safwat Shenouda on 26/01/2017.
//  Copyright © 2017 Safwat. All rights reserved.
//

#import "DetailCollectionViewController.h"
#import "DetailCollectionViewCell.h"
#import "RelatedCollectionViewCell.h"

@interface DetailCollectionViewController ()

@end

@implementation DetailCollectionViewController
@synthesize marvel,itemIndex,activityIndicator,letterIndex,stillLoadingArray;
static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // gesture
    self.gestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gestureAction:)];
    self.gestureRecognizer.delegate = self;
    [self.collectionView addGestureRecognizer:self.gestureRecognizer];
    
    stillLoadingArray = [[NSMutableArray alloc]init];
    for (NSUInteger i=0; i<200; i++) {
        [stillLoadingArray addObject:[NSNumber numberWithBool:NO]];
    }
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    // set character name
    NSMutableArray *arr = marvel.letterCharactersArray[letterIndex];
    MarvelCharacter *marvelCharacter = arr[itemIndex.row];
    self.navigationItem.title = marvelCharacter.name;
    
    // load data
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.collectionView.backgroundView = activityIndicator;
    [activityIndicator startAnimating];
    [marvel.comicsArray removeAllObjects];
    
    [marvel loadComics:self.itemIndex.row withCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"comics count = %lu , itemIndex = %lu, letter index = %lu",marvel.comicsArray.count, itemIndex.row, letterIndex);
            [activityIndicator stopAnimating];
            [self.collectionView reloadData];
        });
    }
    withOffset:0 forLetterIndex:self.letterIndex];
    
}


-(void)gestureAction:(UITapGestureRecognizer *)gesture {
    
    CGPoint p = [gesture locationInView:self.collectionView];
    
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:p];
    if (indexPath == nil){
    } else {
        // get the cell at indexPath (the one you long pressed)
        DetailCollectionViewCell* cell =(DetailCollectionViewCell *) [self.collectionView cellForItemAtIndexPath:indexPath];
        CGRect frame = cell.imageView.frame;
        CGRect compareFrame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width+indexPath.row*cell.frame.size.width, frame.size.height);
        
        if (CGRectContainsPoint(compareFrame, p)) {
            [self showEnlargedImage:cell.imageView.image withFrame:cell.frame];
        }
    }
    
}

-(void) showEnlargedImage:(UIImage *)image withFrame:(CGRect)frame{
    if (self.myPopoverController == nil)
    {
        ImageViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"imageViewController"];
        viewController.image = image;
        [viewController.view setFrame:frame];
       [self presentViewController:viewController animated:YES completion:nil];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView.tag == 100) {
        return marvel.comicsArray.count;
    }
    else {
        return ((NSMutableArray *)marvel.comicsCharacters[collectionView.tag]).count;
    }
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell;
    //Detail cell
    NSLog(@"detail cell tag = %li",collectionView.tag);
    if (collectionView.tag == 100)
    {
        DetailCollectionViewCell *detailCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        MarvelComic *comic = marvel.comicsArray[indexPath.row];
        if ([comic.title isEqual: [NSNull null]] ) detailCell.title.text =@"No Title .." ;
            else detailCell.title.text = comic.title;
        if ([comic.description isEqual: [NSNull null]])
            detailCell.description.text =@"No Details ..";
           else detailCell.description.text = comic.description;
         
             //loadImage
             detailCell.imageView.image = nil;
             if (![comic.imageURLString isEqual:[NSNull null]])
             {
                 detailCell.imageURL = comic.imageURLString;
                 [marvel loadComicImage:indexPath.row withCompletionHandler:^(UIImage * _Nullable image) {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         NSLog(@"Image loaded ..");
                         if ([detailCell.imageURL isEqualToString:comic.imageURLString]) {
                             detailCell.imageView.image = image;
                         }
                     });
                 }];
             }
            
        // load related characters
        if (stillLoadingArray[indexPath.row] == [NSNumber numberWithBool:NO]) {
            stillLoadingArray[indexPath.row] = [NSNumber numberWithBool:YES];
            NSLog(@"Loading for comic collection cell:%li",indexPath.row);
            [marvel loadCharachters:^ {
                stillLoadingArray[indexPath.row] = [NSNumber numberWithBool:NO];
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"count of comic related characters = %li",((NSMutableArray *)marvel.comicsCharacters[indexPath.row]).count );
                 [detailCell.relatedCollectionView reloadData ];
                });
            } forComic:comic.comicId andIndex:indexPath.row];
        }
            
            
            
            cell = detailCell;
            
     }
     else
     // related collection view cell
     {
         RelatedCollectionViewCell *relatedCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"relatedCell" forIndexPath:indexPath];
         relatedCell.imageView.image = nil;
         
         NSMutableArray *arr = marvel.comicsCharacters[collectionView.tag];
         
         // check if related comic characters already loaded , then load the images
         if (arr.count >0 ) {
             MarvelCharacter *aCharacter = marvel.comicsCharacters[collectionView.tag][indexPath.row];
             
             // Load character image
             relatedCell.imageView.image = nil;
             relatedCell.imageURL = aCharacter.imageURLString;
             [relatedCell.activityIndicator startAnimating];
             [marvel loadImage:indexPath.row withCompletionHandler:^(UIImage * _Nullable image) {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     if ([relatedCell.imageURL isEqualToString:aCharacter.imageURLString]) {
                         [relatedCell.activityIndicator stopAnimating];
                         relatedCell.imageView.image = image;
                     }
                 });
             } forComicIndex:collectionView.tag];
         }
         cell = relatedCell;
     }
    
    
    return cell;
}

-(void) collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // handle only main cells not the realted ones
    if (collectionView.tag == 100) {
        // Configure the cell...
        DetailCollectionViewCell *mycell = (DetailCollectionViewCell *) cell;
        mycell.relatedCollectionView.delegate = self;
        mycell.relatedCollectionView.dataSource = self;
        mycell.relatedCollectionView.tag = indexPath.row;
        
    }
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.tag == 100) {
    return CGSizeMake(self.view.frame.size.width-40, self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height-40);
    }
    else {
        return CGSizeMake(55, 70);
    }
}

-(UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}




@end
