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
@synthesize marvel,itemIndex;
static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // load data
    [marvel.comicsArray removeAllObjects];
    
    [marvel loadComics:self.itemIndex.row withCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"comics count = %lu , itemIndex = %lu",marvel.comicsArray.count, itemIndex.row);
            [self.collectionView reloadData];
        });
    }
    withOffset:0];
    
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
    NSLog(@"title:%@,desc:%@,imageURL:%@", comic.title,comic.description,comic.imageURLString);
    if (comic.title !=nil) cell.title.text = comic.title;
        else cell.title.text =@"No Title ..";
    if ([comic.description isEqual: [NSNull null]])
        cell.description.text =@"No Details ..";
       else cell.description.text = comic.description;
    
    //loadImage
    cell.imageView.image = nil;
    
    if (comic.imageURLString!=nil)
    {
    cell.imageURL = comic.imageURLString;
    [marvel loadComicImage:indexPath.row withCompletionHandler:^(UIImage * _Nullable image) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([cell.imageURL isEqualToString:comic.imageURLString]) {
                cell.imageView.image = image;
            }
        });
    }];
    }
    
    
    return cell;
}



@end
