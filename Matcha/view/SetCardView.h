// Copyright (c) 2020 Lightricks. All rights reserved.
// Created by Roi Gabay.

#import "CardView.h"

NS_ASSUME_NONNULL_BEGIN

@interface SetCardView : CardView

@property (nonatomic) NSUInteger number;
@property (strong, nonatomic) NSString* shape;
@property (strong, nonatomic) NSString* fill;
@property (strong, nonatomic) NSString* color;

@end

NS_ASSUME_NONNULL_END
