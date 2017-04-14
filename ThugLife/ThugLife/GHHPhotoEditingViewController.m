//
//  GHHPhotoEditingViewController.m
//  ThugLife
//
//  Created by 高瑞浩 on 2017/3/14.
//  Copyright © 2017年 高瑞浩. All rights reserved.
//

#import "GHHPhotoEditingViewController.h"
#import "UIView+Addition.h"
#import "GHHPhotoManager.h"
#import <MediaPlayer/MediaPlayer.h>
#import "GHHPhotoZoomViewController.h"

@interface GHHPhotoEditingViewController ()

@property(nonatomic, strong)PHAsset *asset;
@property(nonatomic, strong)GHHPhotoManager *manager;
@property(nonatomic, strong)AVURLAsset *avasset;
@property(nonatomic, strong)AVAssetImageGenerator *generator;

@property(nonatomic, strong)UIImageView *imageView;
@property(nonatomic, strong)MPMoviePlayerController *moviePlayer;
@property(nonatomic, strong)UISlider *slider;

@end

@implementation GHHPhotoEditingViewController

- (instancetype)initWithAsset:(PHAsset *)asset {
    self = [super init];
    if (self) {
        self.asset = asset;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    self.manager = [[GHHPhotoManager alloc] init];
    self.avasset = [self.manager requestVideoWithAsset:self.asset];
    self.moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:self.avasset.URL];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayerThumbnailImageRequestDidFinish:) name:MPMoviePlayerThumbnailImageRequestDidFinishNotification object:nil];
    
//    self.generator = [[AVAssetImageGenerator alloc] initWithAsset:self.avasset];
//    self.generator.appliesPreferredTrackTransform=TRUE;
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, self.view.width, self.view.height - 184)];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.imageView];
    
    self.slider = [[UISlider alloc] initWithFrame:CGRectMake(20, self.view.height - 164, self.view.width - 40, 100)];
    [self.slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    self.slider.maximumValue = self.asset.duration;
    self.slider.minimumValue = 0.0;
    [self.view addSubview:self.slider];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarItemAction:)];
    
}

#pragma mark - Norification
- (void)moviePlayerThumbnailImageRequestDidFinish:(NSNotification *)notify {
    NSDictionary *userinfo = [notify userInfo];
    NSError* value = [userinfo objectForKey:MPMoviePlayerThumbnailErrorKey];
    if (value != nil) {
        NSLog(@"Error creating video thumbnail image. Details: %@", [value debugDescription]);
    } else {
        self.imageView.image = [userinfo valueForKey:MPMoviePlayerThumbnailImageKey];
    }
}

#pragma mark - Action
- (void)rightBarItemAction:(UIBarButtonItem *)sender {
    GHHPhotoZoomViewController *zoomVC = [[GHHPhotoZoomViewController alloc] initWithAsset:self.avasset time:self.slider.value];
    [self.navigationController pushViewController:zoomVC animated:YES];
}

- (void)sliderValueChanged:(UISlider *)sender {
    [self.moviePlayer requestThumbnailImagesAtTimes:@[@(sender.value)] timeOption:MPMovieTimeOptionExact];
    
//    CMTime thumbTime = CMTimeMakeWithSeconds(sender.value,30);
//    NSLog(@"🐶🐶🐶 %f", sender.value);
//    
//    AVAssetImageGeneratorCompletionHandler handler =
//    ^(CMTime requestedTime, CGImageRef im, CMTime actualTime, AVAssetImageGeneratorResult result, NSError *error){
//        if (result != AVAssetImageGeneratorSucceeded) {       }//没成功
//        
//        UIImage *thumbImg = [UIImage imageWithCGImage:im];
//        
//        [self performSelectorOnMainThread:@selector(movieImage:) withObject:thumbImg waitUntilDone:YES];
//        
//    };
//    
//    [self.generator generateCGImagesAsynchronouslyForTimes:
//     [NSArray arrayWithObject:[NSValue valueWithCMTime:thumbTime]] completionHandler:handler];
}

- (UIImage *)thumbnailImageAtTime:(NSTimeInterval)playbackTime
{
    CGImageRef imageRef = [self.generator copyCGImageAtTime:CMTimeMakeWithSeconds(playbackTime, 600) actualTime:NULL error:nil];
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return image;
}

- (void)movieImage:(UIImage *)image {
    self.imageView.image = image;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
