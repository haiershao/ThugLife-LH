//
//  GHHPhotoZoomViewController.m
//  ThugLife
//
//  Created by 高瑞浩 on 2017/3/15.
//  Copyright © 2017年 高瑞浩. All rights reserved.
//

#import "GHHPhotoZoomViewController.h"
#import "GHHPhotoManager.h"
#import "UIView+Addition.h"
#import "GHHAddTicketViewController.h"

@interface GHHPhotoZoomViewController ()<UIScrollViewDelegate>

@property(nonatomic, strong)AVURLAsset *avAsset;
@property(nonatomic)CGFloat chosedTime;
@property(nonatomic, strong)GHHPhotoManager *manager;
@property(nonatomic, strong)AVAssetImageGenerator *generator;

@property(nonatomic, strong)UIImageView *imageView;
@property(nonatomic, strong)UIScrollView *scrollView;

@end

@implementation GHHPhotoZoomViewController

- (instancetype)initWithAsset:(AVURLAsset *)asset time:(NSTimeInterval)chosedTime {
    self = [super init];
    if (self) {
        self.avAsset = asset;
        self.chosedTime = chosedTime;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = @"选择缩放点";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarItem:)];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(4, 4, self.view.width - 8, self.view.height - 72)];
    self.scrollView.delegate = self;
    self.scrollView.maximumZoomScale = 3.0;
    self.scrollView.minimumZoomScale = 1.0;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.width, self.scrollView.height)];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.scrollView addSubview:self.imageView];
    self.generator = [[AVAssetImageGenerator alloc] initWithAsset:self.avAsset];
//    self.generator.appliesPreferredTrackTransform = TRUE;
    self.generator.requestedTimeToleranceBefore = kCMTimeZero;
    self.generator.requestedTimeToleranceAfter = kCMTimeZero;
    CGImageRef imageRef = [self.generator copyCGImageAtTime:CMTimeMake(self.chosedTime * 600, 600) actualTime:nil error:nil];
    [self.generator generateCGImagesAsynchronouslyForTimes:@[@(self.chosedTime)] completionHandler:^(CMTime requestedTime, CGImageRef  _Nullable imageRef, CMTime actualTime, AVAssetImageGeneratorResult result, NSError * _Nullable error) {
        UIImage *image = [UIImage imageWithCGImage:imageRef];
        self.imageView.image = [self grayscale:image type:1];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)rightBarItem:(UIBarButtonItem *)sender {
//    CGPoint center = CGPointMake(self.scrollView.contentOffset.x + self.scrollView.width / 2, self.scrollView.contentOffset.y + self.scrollView.height / 2);
    GHHAddTicketViewController *addVC = [[GHHAddTicketViewController alloc] initWithPoint:self.scrollView.contentOffset image:self.imageView.image zoomScale:self.scrollView.zoomScale];
    addVC.avAsset = self.avAsset;
    addVC.choosedTime = self.chosedTime;
    [self.navigationController pushViewController:addVC animated:YES];
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

#pragma mark - privateMethod
- (UIImage*)grayscale:(UIImage*)anImage type:(int)type {
    CGImageRef imageRef = anImage.CGImage;
    size_t width  = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    
    size_t bitsPerComponent = CGImageGetBitsPerComponent(imageRef);
    size_t bitsPerPixel = CGImageGetBitsPerPixel(imageRef);
    
    size_t bytesPerRow = CGImageGetBytesPerRow(imageRef);
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(imageRef);
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
    bool shouldInterpolate = CGImageGetShouldInterpolate(imageRef);
    CGColorRenderingIntent intent = CGImageGetRenderingIntent(imageRef);
    CGDataProviderRef dataProvider = CGImageGetDataProvider(imageRef);
    CFDataRef data = CGDataProviderCopyData(dataProvider);
    UInt8 *buffer = (UInt8*)CFDataGetBytePtr(data);
    NSUInteger x, y;
    for (y = 0; y < height; y++) {
        for (x = 0; x < width; x++) {
            UInt8 *tmp;
            tmp = buffer + y * bytesPerRow + x * 4;
            UInt8 red,green,blue;
            red = *(tmp + 0);
            green = *(tmp + 1);
            blue = *(tmp + 2);
            UInt8 brightness;
            switch (type) {
                case 1:
                    brightness = (77 * red + 28 * green + 151 * blue) / 256;
                    *(tmp + 0) = brightness;
                    *(tmp + 1) = brightness;
                    *(tmp + 2) = brightness; break; case 2:
                    *(tmp + 0) = red;
                    *(tmp + 1) = green * 0.7;
                    *(tmp + 2) = blue * 0.4; break; case 3:
                    *(tmp + 0) = 255 - red;
                    *(tmp + 1) = 255 - green;
                    *(tmp + 2) = 255 - blue; break; default:
                    *(tmp + 0) = red;
                    *(tmp + 1) = green;
                    *(tmp + 2) = blue; break;
            }
        }
    }
    CFDataRef effectedData = CFDataCreate(NULL, buffer, CFDataGetLength(data));
    CGDataProviderRef effectedDataProvider = CGDataProviderCreateWithCFData(effectedData);
    CGImageRef effectedCgImage = CGImageCreate(width, height, bitsPerComponent, bitsPerPixel, bytesPerRow,colorSpace, bitmapInfo, effectedDataProvider, NULL, shouldInterpolate, intent);
    UIImage *effectedImage = [[UIImage alloc] initWithCGImage:effectedCgImage];
    CGImageRelease(effectedCgImage);
    CFRelease(effectedDataProvider);
    CFRelease(effectedData);
    CFRelease(data);
    return effectedImage;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
