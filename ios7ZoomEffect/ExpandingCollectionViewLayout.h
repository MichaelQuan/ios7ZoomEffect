//
//  ExpandingCollectionViewLayout.h
//  ios7ZoomEffect
//
//  Created by Michael Quan on 2014-03-04.
//  Copyright (c) 2014 Michael Quan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExpandingCollectionViewLayout : UICollectionViewFlowLayout

- (void)expandCellAtIndexPath:(NSIndexPath *)indexPath;
- (void)collapseExpandedCell;

/**
 * Set this property to yes to have views maintain their width:height ratio when being scaled
 *
 * NO by default
 */
@property(nonatomic, assign) BOOL tightScale;

@end
