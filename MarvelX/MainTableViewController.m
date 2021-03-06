//
//  MainTableViewController.m
//  MarvelX
//
//  Created by Safwat Shenouda on 05/02/2017.
//  Copyright © 2017 Safwat. All rights reserved.
//

#import "MainTableViewController.h"
#import "MainTableViewCell.h"
#import "DetailCollectionViewController.h"
#import "MarvelCollectionViewCell.h"


@interface MainTableViewController ()

@end

@implementation MainTableViewController
@synthesize marvel,currentOffset,collectionViewItemIndex,collectionViewTag,stillLoadingArray;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    marvel = [[MarvelClient alloc]init];
    
    [self startLoading];
    [self.tableView reloadData];

}

-(void) startLoading {
     stillLoadingArray = [[NSMutableArray alloc]init];
    for (NSUInteger i=0; i<marvel.lettersArray.count; i++) {
        [stillLoadingArray addObject:[NSNumber numberWithBool:NO]];
    }
    
}


// MARK:--------------------------- Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return stillLoadingArray.count;
}

-(void) loadNextGroup:(NSInteger)index {
    
    if (stillLoadingArray[index] == [NSNumber numberWithBool:NO]) {
        stillLoadingArray[index] = [NSNumber numberWithBool:YES];
        [marvel loadCharachters:^ {
            stillLoadingArray[index] = [NSNumber numberWithBool:NO];
           // self.currentOffset += 20;
            dispatch_async(dispatch_get_main_queue(), ^{
                MainTableViewCell *cell = [self.tableView cellForRowAtIndexPath: [NSIndexPath indexPathForRow:index inSection:0]];
                [cell.collectionView reloadData];
            });
        } withOffset:currentOffset forLetterIndex:index];
    }
}


-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // Configure the cell...
    MainTableViewCell *mycell = (MainTableViewCell *) cell;
    mycell.collectionView.delegate = self;
    mycell.collectionView.dataSource = self;
    mycell.collectionView.tag = indexPath.row;
    [mycell.collectionView reloadData];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tablecell" forIndexPath:indexPath];
    
    // load only in case of no characters were loded before
    NSMutableArray *arr = marvel.letterCharactersArray[indexPath.row];
    if (arr.count == 0) {
        [self loadNextGroup:indexPath.row];
    }
    cell.letterLabel.text = [marvel.lettersArray objectAtIndex:indexPath.row];
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    DetailCollectionViewController *detailView = segue.destinationViewController;
    detailView.marvel = self.marvel;
    detailView.itemIndex = collectionViewItemIndex;
    detailView.letterIndex = collectionViewTag;
    
}

-(UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

// MARK: --------------------- collection view

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MarvelCollectionViewCell *cell =(MarvelCollectionViewCell *) [collectionView dequeueReusableCellWithReuseIdentifier:@"collectioncell" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor blackColor];
    MarvelCharacter *aCharacter = marvel.letterCharactersArray[collectionView.tag][indexPath.row];
    cell.name.text =aCharacter.name;
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
    } forLetterIndex:collectionView.tag];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    collectionViewItemIndex = indexPath;
    collectionViewTag = collectionView.tag;
    [self performSegueWithIdentifier:@"showDetail" sender:self];
}

-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    NSMutableArray *arr = marvel.letterCharactersArray[collectionView.tag];
    return arr.count;
    
}

-(NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger diff = ((NSMutableArray *)marvel.letterCharactersArray[collectionView.tag]).count -(indexPath.row+1);
    if (diff < 1) {
        NSLog(@"\nloading next group after offset:%lu, tag:%li ",currentOffset, collectionView.tag);
    }
    
}


@end
