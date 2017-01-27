//
//  MarvelCollectionViewController.m
//  MarvelX
//
//  Created by Safwat Shenouda on 21/01/2017.
//  Copyright © 2017 Safwat. All rights reserved.
//

#import "MarvelCollectionViewController.h"
#import "MarvelCollectionViewCell.h"
#import "DetailCollectionViewController.h"

@interface MarvelCollectionViewController ()

@end

@implementation MarvelCollectionViewController
@synthesize marvel,stillLoading,currentOffset;
static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    // Do any additional setup after loading the view.
    marvel = [[MarvelRepo alloc]init];
    currentOffset = 0;
    [self loadNextGroup];
    
    
}


-(void) loadNextGroup {
    
    if (stillLoading == NO) {
        stillLoading = YES;
        [marvel loadCharachters:^ {
            NSLog(@"characters count= %lu",marvel.charactersArray.count);
            self.stillLoading = NO;
            self.currentOffset += 20;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionView reloadData];
            });
        } withOffset:currentOffset+20 ];
    }
}


-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger diff = marvel.charactersArray.count -(indexPath.row+1);
    if (diff < 3) {
        [self loadNextGroup];
        NSLog(@"\nloading next group after offset:%lu",currentOffset);
    }
    
}



#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    if(stillLoading == YES ) return 0;
    else
        return marvel.charactersArray.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MarvelCollectionViewCell *cell =(MarvelCollectionViewCell *) [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor redColor];
    MarvelCharacter *aCharacter = marvel.charactersArray[indexPath.row];
    cell.name.text =aCharacter.name;
    NSLog(@"IndexPath.row = %li",(long)indexPath.row);
    // Load character image
    cell.imageView.image = nil;
    cell.imageURL = aCharacter.imageURLString;
    [cell.activityIndicator startAnimating];
    [marvel loadImage:indexPath.row withCompletionHandler:^(UIImage * _Nullable image) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([cell.imageURL isEqualToString:aCharacter.imageURLString]) {
            [cell.activityIndicator stopAnimating];
            cell.imageView.image = image;
            }
        });
    }];
    return cell;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"showDetail" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"showDetail"]){
        NSIndexPath *selectedPath = [self.collectionView indexPathsForSelectedItems][0];
        DetailCollectionViewController *detailView = segue.destinationViewController;
        detailView.marvel = self.marvel;
        detailView.itemIndex = selectedPath;
        

    }
    
}

@end
