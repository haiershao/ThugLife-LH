//
//  GHHGridViewController.m
//  ThugLife
//
//  Created by 高瑞浩 on 2017/3/13.
//  Copyright © 2017年 高瑞浩. All rights reserved.
//

#import "GHHGridViewController.h"
#import "UIView+Addition.h"
#import "GHHGridCell.h"
#import "GHHPhotoManager.h"

@interface GHHGridViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property(nonatomic, strong)UICollectionView *collectionView;
@property(nonatomic) CGSize itemSize;

@property(nonatomic, strong)GHHPhotoManager *photoManager;
@property(nonatomic, strong)NSMutableArray *selectArray;

@end

static NSString *cellID = @"collectionCell";

@implementation GHHGridViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.photoManager = [[GHHPhotoManager alloc] init];
    self.selectArray = [NSMutableArray array];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarItem:)];
    
    CGFloat width = (self.view.width - 2) / 3.0;
    UICollectionViewFlowLayout *viewLayout = [[UICollectionViewFlowLayout alloc] init];
    self.itemSize = CGSizeMake(width, width);
    viewLayout.itemSize = self.itemSize;
    viewLayout.minimumLineSpacing = 1.0;
    viewLayout.minimumInteritemSpacing = 1.0;
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:viewLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[GHHGridCell class] forCellWithReuseIdentifier:cellID];
    [self.view addSubview:self.collectionView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)rightBarItem:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    if (self.block) {
        self.block(self.selectArray);
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kDidFinishPickeMedia" object:nil];
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.assetsFetchResults.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GHHGridCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    PHAsset *asset = self.assetsFetchResults[indexPath.item];
    [self.photoManager getImageFromAsset:asset targetSize:self.itemSize completeHandler:^void (UIImage *image) {
        cell.imageView.image = image;
    }];
    __weak typeof(self) weakSelf = self;
    cell.btnActionBlock = ^(BOOL isSelected) {
        [weakSelf updateSelectedArrayWithAsset:asset isSelected:isSelected];
    };
    return cell;
}

#pragma mark - private method
- (void)updateSelectedArrayWithAsset:(PHAsset *)asset isSelected:(BOOL)isSelected {
    if (isSelected) {
        if (![self.selectArray containsObject:asset]) {
            [self.selectArray addObject:asset];
        }
    } else {
        if ([self.selectArray containsObject:asset]) {
            [self.selectArray removeObject:asset];
        }
    }
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
