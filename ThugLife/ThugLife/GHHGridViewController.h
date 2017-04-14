//
//  GHHGridViewController.h
//  ThugLife
//
//  Created by 高瑞浩 on 2017/3/13.
//  Copyright © 2017年 高瑞浩. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectPhotosBlock)(NSArray *array);
@interface GHHGridViewController : UIViewController

@property(nonatomic, strong)PHFetchResult *assetsFetchResults;
@property(nonatomic, copy)SelectPhotosBlock block;

@end
