// Copyright (c) 2020 Lightricks. All rights reserved.
// Created by Roi Gabay.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CardView : UIView

@property (nonatomic) BOOL faceUp;
@property (nonatomic) BOOL active;
@property (nonatomic) BOOL chosen;

- (CGFloat)scaleFactor;
- (CGFloat)cornerRadius;
- (CGFloat)cornerOffset;

- (void)drawCardContent;

@end

NS_ASSUME_NONNULL_END
