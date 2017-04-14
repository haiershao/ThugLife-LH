//
//  GHHPhotoViewController.m
//  videoDemo
//
//  Created by 高瑞浩 on 2017/3/9.
//  Copyright © 2017年 高瑞浩. All rights reserved.
//

#import "GHHPhotoViewController.h"
#import "GHHPhotoManager.h"
#import "GHHImageItem.h"
#import "GHHGridViewController.h"

@interface GHHPhotoViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) NSInteger maxCount;
@property (nonatomic) BOOL isFirstLoad;
@property (nonatomic) GHHMediaType mediaType;
@property (nonatomic, copy)SelectPhotosBlock block;
@property (nonatomic, strong)GHHPhotoManager *photoManager;
@property (nonatomic, strong)NSMutableArray *albumsArray;

@property (nonatomic, strong)UITableView *tableView;

@end

@implementation GHHPhotoViewController

- (instancetype)initWithMaxCount:(NSInteger)maxCount type:(GHHMediaType)type completedHandler:(SelectPhotosBlock)completeHandler {
    self = [super init];
    if (self) {
        self.maxCount = maxCount;
        self.mediaType = type;
        self.block = completeHandler;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.photoManager = [[GHHPhotoManager alloc] init];
    self.albumsArray = self.mediaType == GHHMediaTypePhoto ? [NSMutableArray arrayWithArray:[self.photoManager getAlbums]] : [NSMutableArray arrayWithArray:[self.photoManager getVideos]];
    self.isFirstLoad = YES;
    
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarItem:)];
    self.navigationItem.rightBarButtonItem = cancelItem;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.isFirstLoad && self.albumsArray.count > 0) {
        GHHImageItem *result = self.albumsArray[0];
        GHHGridViewController *gridVC = [[GHHGridViewController alloc] init];
        gridVC.assetsFetchResults = result.fetchResult;
        gridVC.block = self.block;
        [self.navigationController pushViewController:gridVC animated:NO];
        self.isFirstLoad = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)rightBarItem:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.albumsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *idenifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idenifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:idenifier];
    }
    GHHImageItem *result = self.albumsArray[indexPath.row];
    cell.textLabel.text = result.title;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)result.fetchResult.count];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GHHImageItem *result = self.albumsArray[indexPath.row];
    GHHGridViewController *gridVC = [[GHHGridViewController alloc] init];
    gridVC.assetsFetchResults = result.fetchResult;
    gridVC.block = self.block;
    [self.navigationController pushViewController:gridVC animated:YES];
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
