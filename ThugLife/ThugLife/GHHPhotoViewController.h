//
//  GHHPhotoViewController.h
//  videoDemo
//
//  Created by 高瑞浩 on 2017/3/9.
//  Copyright © 2017年 高瑞浩. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    GHHMediaTypePhoto,
    GHHMediaTypeVideo,
} GHHMediaType;

typedef void(^SelectPhotosBlock)(NSArray *array);

@interface GHHPhotoViewController : UIViewController

- (instancetype)initWithMaxCount:(NSInteger)maxCount type:(GHHMediaType)type completedHandler:(SelectPhotosBlock)completeHandler;

@end
