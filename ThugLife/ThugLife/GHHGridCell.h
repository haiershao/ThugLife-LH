//
//  GHHGridCell.h
//  ThugLife
//
//  Created by 高瑞浩 on 2017/3/13.
//  Copyright © 2017年 高瑞浩. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectBoxBlock)(BOOL isSelected);

@interface GHHGridCell : UICollectionViewCell

@property (nonatomic, strong)UIImageView *imageView;
@property (nonatomic, copy)SelectBoxBlock btnActionBlock;

@end
