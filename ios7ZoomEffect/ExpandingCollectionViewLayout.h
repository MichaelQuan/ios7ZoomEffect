//
//  ExpandingCollectionViewLayout.h
//  ios7ZoomEffect
//
//  Created by Michael Quan on 2014-03-04.
//  Copyright (c) 2014 Michael Quan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExpandingCollectionViewLayout : UICollectionViewFlowLayout

- (void)expandCellAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(7_0);
- (void)collapseExpandedCell NS_AVAILABLE_IOS(7_0);

@end
