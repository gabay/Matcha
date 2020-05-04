//
//  SetCard.h
//  Matcha
//
//  Created by Roi Gabay on 23/04/2020.
//  Copyright © 2020 Roi Gabay. All rights reserved.
//

#import "Card.h"

NS_ASSUME_NONNULL_BEGIN

@interface SetCard : Card

@property (nonatomic) NSUInteger number;
@property (nonatomic) NSUInteger shape;
@property (nonatomic) NSUInteger fill;
@property (nonatomic) NSUInteger color;

+ (unsigned int)maxNumber;
+ (unsigned int)maxShape;
+ (unsigned int)maxFill;
+ (unsigned int)maxColor;
+ (NSArray *)numbers;
+ (NSArray *)shapes;
+ (NSArray *)fills;
+ (NSArray *)colors;

@end

NS_ASSUME_NONNULL_END
