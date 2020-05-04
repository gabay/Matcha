// Copyright (c) 2020 Lightricks. All rights reserved.
// Created by Roi Gabay.

#import "CardView.h"

NS_ASSUME_NONNULL_BEGIN

@interface PlayingCardView : CardView

@property (nonatomic) NSUInteger rank;
@property (strong, nonatomic) NSString *suit;

@end

NS_ASSUME_NONNULL_END
