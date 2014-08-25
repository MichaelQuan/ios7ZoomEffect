//
//  ViewController.m
//  ios7ZoomEffect
//
//  Created by Michael Quan on 2014-03-04.
//  Copyright (c) 2014 Michael Quan. All rights reserved.
//

#import "ViewController.h"
#import "ExpandingCollectionViewLayout.h"

@interface ViewController ()

@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, strong) ExpandingCollectionViewLayout *expandingLayout;

@end

static NSString * const CellIdentifier = @"cell";

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.expandingLayout = [ExpandingCollectionViewLayout new];
	self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.expandingLayout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CellIdentifier];
    self.collectionView.allowsMultipleSelection = YES;
    
    self.expandingLayout.minimumLineSpacing = 5;
    self.expandingLayout.minimumInteritemSpacing = 5;
    self.expandingLayout.itemSize = CGSizeMake(50, 50);
    
    [self.view addSubview:self.collectionView];
    NSDictionary *viewDictionary = @{@"cv" : self.collectionView};
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[cv]|" options:0 metrics:nil views:viewDictionary]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[cv]|" options:0 metrics:nil views:viewDictionary]];
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.expandingLayout expandCellAtIndexPath:indexPath];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.expandingLayout collapseExpandedCell];
}

#pragma mark - UICollectionViewDatasource

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor blueColor];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 50;
}

@end
