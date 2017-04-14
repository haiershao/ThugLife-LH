//
//  UIViewController+Addition.h
//  videoDemo
//
//  Created by 高瑞浩 on 2017/3/8.
//  Copyright © 2017年 高瑞浩. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Addition)

- (void)presentPhotoViewControllerWithMaxCount:(NSInteger)maxCount conpleteHandler:(void (^)(NSArray *))block;

@end
