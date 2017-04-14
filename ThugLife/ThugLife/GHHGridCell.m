//
//  GHHGridCell.m
//  ThugLife
//
//  Created by 高瑞浩 on 2017/3/13.
//  Copyright © 2017年 高瑞浩. All rights reserved.
//

#import "GHHGridCell.h"
#import "UIView+Addition.h"

@interface GHHGridCell()

@property(nonatomic, strong)UIButton *selectBox;

@end

@implementation GHHGridCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView.clipsToBounds = YES;
        [self.contentView addSubview:self.imageView];
        
        self.selectBox = [UIButton buttonWithType:UIButtonTypeCustom];
        self.selectBox.frame = CGRectMake(self.width - 50, 0, 50, 50);
        [self.selectBox setImage:[UIImage imageNamed:@"star_checkbox_unselected_white"] forState:UIControlStateNormal];
        [self.selectBox setImage:[UIImage imageNamed:@"star_checkbox_Selected"] forState:UIControlStateSelected];
        self.selectBox.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 10, 0);
        [self.contentView addSubview:self.selectBox];
        [self.selectBox addTarget:self action:@selector(selectBoxAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)selectBoxAction:(UIButton *)sender {
    [UIView animateKeyframesWithDuration:0.4 delay:0 options:UIViewKeyframeAnimationOptionAllowUserInteraction animations:^{
       [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.2 animations:^{
           sender.transform = CGAffineTransformMakeScale(0.7, 0.7);
       }];
        [UIView addKeyframeWithRelativeStartTime:0.2 relativeDuration:0.4 animations:^{
            sender.transform = CGAffineTransformIdentity;
        }];
    } completion:^(BOOL finished) {
        
    }];
    sender.selected = !sender.selected;
    if (self.btnActionBlock) {
        self.btnActionBlock(sender.isSelected);
    }
}

@end
