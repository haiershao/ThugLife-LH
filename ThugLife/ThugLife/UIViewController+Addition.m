//
//  UIViewController+Addition.m
//  videoDemo
//
//  Created by 高瑞浩 on 2017/3/8.
//  Copyright © 2017年 高瑞浩. All rights reserved.
//

#import "UIViewController+Addition.h"

@implementation UIViewController (Addition)

- (void)presentPhotoViewControllerWithMaxCount:(NSInteger)maxCount conpleteHandler:(void (^)(NSArray *))block {
    
}

- (BOOL)authorize {
    switch ([PHPhotoLibrary authorizationStatus]) {
        case PHAuthorizationStatusAuthorized: {
            return YES;
        }
        case PHAuthorizationStatusNotDetermined: {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self authorize];
                });
            }];
        }
        default:
            break;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"访问相册受限" message:@"点击“设置”，允许访问您的相册" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *settingAction = [UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }];
        
        [alertVC addAction:cancelAction];
        [alertVC addAction:settingAction];
        [self presentViewController:alertVC animated:YES completion:nil];
    });
    return NO;
}

@end
