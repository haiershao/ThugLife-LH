//
//  UIView+Addition.m
//  ThugLife
//
//  Created by 高瑞浩 on 2017/3/13.
//  Copyright © 2017年 高瑞浩. All rights reserved.
//

#import "UIView+Addition.h"

@implementation UIView (Addition)

- (CGFloat)width {
    return self.bounds.size.width;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.bounds;
    frame.size.width = width;
    self.bounds = frame;
}

- (CGFloat)height {
    return self.bounds.size.height;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.bounds;
    frame.size.height = height;
    self.bounds = frame;
}

- (CGFloat)originX {
    return self.bounds.origin.x;
}

- (void)setOriginX:(CGFloat)originX {
    CGRect frame = self.bounds;
    frame.origin.x = originX;
    self.bounds = frame;
}

- (CGFloat)originY {
    return self.bounds.origin.y;
}

- (void)setOriginY:(CGFloat)originY {
    CGRect frame = self.bounds;
    frame.origin.y = originY;
    self.bounds = frame;
}

@end
