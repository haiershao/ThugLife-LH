//
//  ViewController.m
//  ThugLife
//
//  Created by 高瑞浩 on 2017/3/13.
//  Copyright © 2017年 高瑞浩. All rights reserved.
//

#import "ViewController.h"
#import "GHHPhotoViewController.h"
#import "GHHPhotoEditingViewController.h"

@interface ViewController ()

@property(nonatomic, strong)NSMutableArray *selectedArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Thug Life";
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishPickeMediaNotification:) name:@"kDidFinishPickeMedia" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didFinishPickeMediaNotification:(NSNotification *)notify {
    
}

- (IBAction)selectAlbumAction:(UIButton *)sender {
    __block typeof(self) weakSelf = self;
    GHHPhotoViewController *photoVC = [[GHHPhotoViewController alloc] initWithMaxCount:9 type:sender.tag == 1000 ? GHHMediaTypePhoto : GHHMediaTypeVideo completedHandler:^(NSArray *array) {
        weakSelf.selectedArray = [NSMutableArray arrayWithArray:array];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            GHHPhotoEditingViewController *photoEditorVC = [[GHHPhotoEditingViewController alloc] initWithAsset:self.selectedArray.firstObject];
            NSLog(@"self.selectedArray%@",self.selectedArray[0]);
            [self.navigationController pushViewController:photoEditorVC animated:YES];
            
        });
    }];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:photoVC];
    [self presentViewController:navi animated:YES completion:nil];
}

@end
