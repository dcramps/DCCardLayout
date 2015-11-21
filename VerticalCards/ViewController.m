//
//  ViewController.m
//  VerticalCards
//
//  Created by Daniel Crampton on 2015-11-20.
//  Copyright © 2015 Daniel Crampton. All rights reserved.
//

#import "ViewController.h"
#import "DCCardLayout.h"

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class])];
    
    DCCardLayout *layout = [[DCCardLayout alloc] init];
    layout.minimumLineSpacing = 0.0f;
    self.collectionView.collectionViewLayout = layout;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    ((DCCardLayout *)self.collectionView.collectionViewLayout).itemSize = CGSizeMake(CGRectGetWidth(self.collectionView.bounds), CGRectGetHeight(self.collectionView.bounds) - 100.0f);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class]) forIndexPath:indexPath];
    
    UIImageView *catImageView = [[UIImageView alloc] initWithFrame:cell.bounds];
    catImageView.image = [UIImage imageNamed:@"cat"];
    [cell.contentView addSubview:catImageView];
    
    return cell;
}

@end
