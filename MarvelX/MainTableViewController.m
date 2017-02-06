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


@interface MainTableViewController ()

@end

@implementation MainTableViewController
@synthesize marvel,stillLoading,currentOffset,collectionViewItemIndex,collectionViewTag,stillLoadingArray;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    stillLoading = NO;
     marvel = [[MarvelRepo alloc]init];
    
    // test
    stillLoadingArray = [[NSMutableArray alloc]init];
    [stillLoadingArray addObject:[NSNumber numberWithBool:NO]];
    [stillLoadingArray addObject:[NSNumber numberWithBool:NO]];
    
    [self loadNextGroup:0];
    [self loadNextGroup:1];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 2;
}

-(void) loadNextGroup:(NSInteger)index {
    
    if (stillLoadingArray[index] == [NSNumber numberWithBool:NO]) {
        stillLoadingArray[index] = [NSNumber numberWithBool:YES];
        [marvel loadCharachters:^ {
            stillLoadingArray[index] = [NSNumber numberWithBool:NO];
            self.currentOffset += 20;
            NSInteger currentPath = index;
            dispatch_async(dispatch_get_main_queue(), ^{
                MainTableViewCell *cell = [self.tableView cellForRowAtIndexPath: [NSIndexPath indexPathForRow:index inSection:0]];
                [cell.collectionView reloadData];
            });
        } withOffset:currentOffset+20 forLetterIndex:index];
    }
}


-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // Configure the cell...
    MainTableViewCell *mycell = (MainTableViewCell *) cell;
    mycell.collectionView.delegate = self;
    mycell.collectionView.dataSource = self;
    mycell.collectionView.tag = indexPath.row;
    
    NSLog(@"will display cell called for index: %li",indexPath.row);
    //[self loadNextGroup:indexPath.row];
    //[mycell.collectionView reloadData];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tablecell" forIndexPath:indexPath];
    
    
   // [self loadNextGroup:indexPath];
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    NSLog(@"prepare for segue called..");
//    NSIndexPath *selectedPath = [self.collectionView indexPathsForSelectedItems][0];
    DetailCollectionViewController *detailView = segue.destinationViewController;
    detailView.marvel = self.marvel;
    detailView.itemIndex = collectionViewItemIndex;
    
}



// MARK: collection view

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MarvelCollectionViewCell *cell =(MarvelCollectionViewCell *) [collectionView dequeueReusableCellWithReuseIdentifier:@"collectioncell" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor blueColor];
    MarvelCharacter *aCharacter = marvel.letterCharactersArray[collectionView.tag][indexPath.row];
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
    } forLetterIndex:collectionView.tag];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    // [self performSegueWithIdentifier:@"showDetail" sender:self];
    NSLog(@"collection view cell selected .. : %li",indexPath.row);
    
    collectionViewItemIndex = indexPath;
    collectionViewTag = collectionView.tag;
    [self performSegueWithIdentifier:@"showDetail" sender:self];
}

-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
   // NSLog(@"array:%li",marvel.charactersArray.count);
    NSMutableArray *arr = marvel.letterCharactersArray[collectionView.tag];
    return arr.count;
    
}

-(NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger diff = ((NSMutableArray *)marvel.letterCharactersArray[collectionView.tag]).count -(indexPath.row+1);
    if (diff < 3) {
        [self loadNextGroup:collectionView.tag];
        NSLog(@"\nloading next group after offset:%lu, tag:%li ",currentOffset, collectionView.tag);
    }
    
}


@end
