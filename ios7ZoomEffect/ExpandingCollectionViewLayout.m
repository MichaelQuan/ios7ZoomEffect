//
//  ExpandingCollectionViewLayout.m
//  ios7ZoomEffect
//
//  Created by Michael Quan on 2014-03-04.
//  Copyright (c) 2014 Michael Quan. All rights reserved.
//

#import "ExpandingCollectionViewLayout.h"

@interface ExpandingCollectionViewLayout ()

@property (nonatomic, assign) CGRect selectedCellFrame;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

@end

@implementation ExpandingCollectionViewLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        _selectedCellFrame = CGRectNull;
        _selectedIndexPath = nil;
        _tightScale = NO;
    }
    return self;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray *layoutAttributes = [super layoutAttributesForElementsInRect:rect];
    
    [layoutAttributes enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes *obj, NSUInteger idx, BOOL *stop) {
        [self _transformLayoutAttributes:obj];
    }];
    
    return layoutAttributes;
}
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *layoutAttributes = [super layoutAttributesForItemAtIndexPath:indexPath];
    
    [self _transformLayoutAttributes:layoutAttributes];
    
    return layoutAttributes;
}

- (void)_transformLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    if (self.selectedIndexPath != nil)
    {
        if ([layoutAttributes.indexPath isEqual:self.selectedIndexPath]) {
            // set the frame to be the bounds of the collectionView to expand to the entire collectionView
            layoutAttributes.frame = self.collectionView.bounds;
        } else {
            //scale = collectionView.size / cell_selected.size
            //translate = (scale - 1)(cell_i.center - cell_selected.center) + (collectionView.center - cell_selected.center)
            //fun fun fun
            
            CGRect collectionViewBounds = self.collectionView.bounds;
            // TODO: verify that if the collection views bounds.size is smaller than the collection views frame.size that this animation still works properly
            
            CGRect selectedFrame = self.selectedCellFrame;
            CGRect notSelectedFrame = layoutAttributes.frame;
            
            // Calculate the scale transform based on the ratio between the selected cell's frame and the collection views bound
            // Scale on that because we want everything to look scaled by the same amount, and the scale is dependent on how much the selected cell has to expand
            CGFloat x_scale = collectionViewBounds.size.width / selectedFrame.size.width;
            CGFloat y_scale = collectionViewBounds.size.height / selectedFrame.size.height;
            CGAffineTransform scaleTransform = CGAffineTransformMakeScale(x_scale, y_scale);
            if (self.tightScale)
            {
                CGFloat minScale = MIN(x_scale, y_scale);
                scaleTransform = CGAffineTransformMakeScale(minScale, minScale);
            }
            
            // Translation based on how much the selected cell has been scaled
            // translate based on the (scale - 1) and delta between the centers
            CGFloat x_zoomTranslate = (x_scale - 1) * (CGRectGetMidX(notSelectedFrame) - CGRectGetMidX(selectedFrame));
            CGFloat y_zoomTranslate = (y_scale - 1) * (CGRectGetMidY(notSelectedFrame) - CGRectGetMidY(selectedFrame));
            CGAffineTransform zoomTranslate = CGAffineTransformMakeTranslation(x_zoomTranslate, y_zoomTranslate); //Translation based on how much the cells are scaled
            
            // Translation based on where the selected cells center is
            // since we move the center of the selected cell when expanded to full screen, all other cells must move by that amount as well
            CGFloat x_offsetTranslate = CGRectGetMidX(collectionViewBounds) - CGRectGetMidX(selectedFrame);
            CGFloat y_offsetTranslate = CGRectGetMidY(collectionViewBounds) - CGRectGetMidY(selectedFrame);
            CGAffineTransform offsetTranslate = CGAffineTransformMakeTranslation(x_offsetTranslate, y_offsetTranslate);
            
            // multiply translations first
            CGAffineTransform transform = CGAffineTransformConcat(zoomTranslate, offsetTranslate);
            transform = CGAffineTransformConcat(scaleTransform, transform);
            
            if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
                layoutAttributes.frame = CGRectApplyAffineTransform(layoutAttributes.frame, transform);
            } else {
                layoutAttributes.transform = transform;
            }
        }
        
    }
}

- (void)expandCellAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedCellFrame = [self layoutAttributesForItemAtIndexPath:indexPath].frame;
    self.selectedIndexPath = indexPath;

    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:9 options:0 animations:^{
        [self.collectionView performBatchUpdates:^{
            
        } completion:^(BOOL finished) {
            //TODO: add callback for finished animating
        }];
    } completion:^(BOOL finished) {
    }];

}

- (void)collapseExpandedCell
{
    self.selectedCellFrame = CGRectNull;
    self.selectedIndexPath = nil;

    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:9 options:0 animations:^{
        [self.collectionView performBatchUpdates:^{
            
        } completion:^(BOOL finished) {
            //TODO: add callback for finished animating
        }];
    } completion:^(BOOL finished) {
    }];
}

@end
