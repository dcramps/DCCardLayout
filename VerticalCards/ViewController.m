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
@property (nonatomic, strong) NSArray *colours;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class])];
    
    DCCardLayout *layout = [[DCCardLayout alloc] init];
    layout.minimumLineSpacing = 0.0f;
    self.collectionView.collectionViewLayout = layout;
    
    NSMutableArray *temp = [@[] mutableCopy];
    for (int x = 0; x < 100000; x++) {
        CGFloat hue = ( arc4random() % 256 / 256.0 );
        CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;
        CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;
        UIColor *colour = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
        [temp addObject:colour];
    }
    
    self.colours = [temp copy];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    ((DCCardLayout *)self.collectionView.collectionViewLayout).itemSize = CGSizeMake(CGRectGetWidth(self.collectionView.bounds), CGRectGetHeight(self.collectionView.bounds) - 100.0f);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.colours.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class]) forIndexPath:indexPath];
    UIColor *colour = self.colours[indexPath.item];
    
    UIImageView *catImageView = [[UIImageView alloc] initWithFrame:cell.bounds];
    catImageView.image = [UIImage imageNamed:@"cat"];
    [cell.contentView addSubview:catImageView];
    
    cell.contentView.backgroundColor = colour;
    
    return cell;
}

@end
