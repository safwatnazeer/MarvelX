//
//  DetailCollectionViewController.m
//  MarvelX
//
//  Created by Safwat Shenouda on 26/01/2017.
//  Copyright © 2017 Safwat. All rights reserved.
//

#import "DetailCollectionViewController.h"
#import "DetailCollectionViewCell.h"

@interface DetailCollectionViewController ()

@end

@implementation DetailCollectionViewController
@synthesize marvel,itemIndex,activityIndicator,letterIndex;
static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    // set character namw
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return marvel.comicsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DetailCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    MarvelComic *comic = marvel.comicsArray[indexPath.row];
   // NSLog(@"title:%@,desc:%@,imageURL:%@", comic.title,comic.description,comic.imageURLString);
    if ([comic.title isEqual: [NSNull null]] ) cell.title.text =@"No Title .." ;
        else cell.title.text = comic.title;
    if ([comic.description isEqual: [NSNull null]])
        cell.description.text =@"No Details ..";
       else cell.description.text = comic.description;
    
    //loadImage
    cell.imageView.image = nil;
    
    if (![comic.imageURLString isEqual:[NSNull null]])
    {
    cell.imageURL = comic.imageURLString;
    [marvel loadComicImage:indexPath.row withCompletionHandler:^(UIImage * _Nullable image) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Image loaded ..");
            if ([cell.imageURL isEqualToString:comic.imageURLString]) {
                cell.imageView.image = image;
            }
        });
    }];
    }
    
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.view.frame.size.width-40, self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height);
}

-(UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}




@end
