//
//  DCViewCardsLayout.m
//  VerticalCards
//
//  Created by dc on 2015-11-20.
//  Copyright © 2015 dc. All rights reserved.
//

#import "DCCardLayout.h"

@interface DCCardLayout ()

@property (nonatomic, weak) UIView *superview;

@end

@implementation DCCardLayout

- (void)prepareLayout
{
    self.superview = self.collectionView.superview;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray *attributes = [super layoutAttributesForElementsInRect:rect];
    
    //Need to do this deep copy bullshit to not break caching
    NSMutableArray *copyAttributes = [@[] mutableCopy];
    for (UICollectionViewLayoutAttributes *attribute in attributes) {
        [copyAttributes addObject:[attribute copy]];
    }

    NSMutableArray *modifiedArray = [NSMutableArray array];
    
    [copyAttributes enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes *attribute, NSUInteger idx, BOOL * _Nonnull stop) {
        CGPoint originSuperView = [self.superview convertPoint:attribute.frame.origin fromView:self.collectionView];
        
        if (originSuperView.y < 0.0f && fabs(originSuperView.y) < self.itemSize.height) {
            CGFloat scale = (self.itemSize.height - fabs(originSuperView.y)) / self.itemSize.height;
            
            CGPoint newOrigin = self.collectionView.contentOffset;
            
            attribute.frame = (CGRect) {
                .size = attribute.frame.size,
                .origin = newOrigin
            };
            
            CGFloat alphaScale = [self map:scale min:0.0f max:1.0f newMin:0.5f newMax:1.0f];
            attribute.alpha = alphaScale;
            
            CGFloat originScale = [self map:scale min:0.0f max:1.0f newMin:0.95f newMax:1.0f];
            CGAffineTransform scaleTransform = CGAffineTransformMakeScale(originScale, originScale);
            attribute.transform = CGAffineTransformTranslate(scaleTransform, 0.0f, -(1-scale)*50.0f);

            attribute.zIndex = -attribute.indexPath.item;
        }

        [modifiedArray addObject:attribute];
    }];
    
    return modifiedArray;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

- (CGSize)collectionViewContentSize
{
    CGSize size = [super collectionViewContentSize];
    size.width = CGRectGetWidth(self.collectionView.bounds);
    
    return size;
}

//Credit: http://stackoverflow.com/a/22238385/219148
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    CGFloat rawPageValue = self.collectionView.contentOffset.y / self.itemSize.height;
    CGFloat currentPage = (velocity.y > 0.0) ? floor(rawPageValue) : ceil(rawPageValue);
    CGFloat nextPage = (velocity.y > 0.0) ? ceil(rawPageValue) : floor(rawPageValue);
    
    BOOL pannedLessThanAPage = fabs(1 + currentPage - rawPageValue) > 0.5;
    BOOL flicked = fabs(velocity.y) > 0.3f;
    if (pannedLessThanAPage && flicked) {
        proposedContentOffset.y = nextPage * self.itemSize.height;
    } else {
        proposedContentOffset.y = round(rawPageValue) * self.itemSize.height;
    }
    
    return proposedContentOffset;
}

#pragma mark -
//Credit: https://www.arduino.cc/en/Reference/Map
- (CGFloat)map:(CGFloat)numIn min:(CGFloat)min max:(CGFloat)max newMin:(CGFloat)newMin newMax:(CGFloat)newMax
{
    return (numIn - min) / (max - min) * (newMax - newMin) + newMin;
}

@end
