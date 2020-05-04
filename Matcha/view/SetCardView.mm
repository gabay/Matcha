// Copyright (c) 2020 Lightricks. All rights reserved.
// Created by Roi Gabay.

#import "SetCardView.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SetCardView

#pragma mark - Members

- (void)setNumber:(NSUInteger)number
{
    _number = number;
    [self setNeedsDisplay];
}

- (void)setShape:(NSString *)shape
{
    _shape = shape;
    [self setNeedsDisplay];
}

- (void)setFill:(NSString *)fill
{
    _fill = fill;
    [self setNeedsDisplay];
}

- (void)setColor:(NSString *)color
{
    _color = color;
    [self setNeedsDisplay];
}

#pragma mark - Drawing

- (void)drawCardContent
{
    
}

@end

NS_ASSUME_NONNULL_END
