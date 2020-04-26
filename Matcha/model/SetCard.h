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
@property (strong, nonatomic) NSString *shape;
@property (strong, nonatomic) NSString *fill;
@property (strong, nonatomic) NSString *color;

+ (unsigned int)maxNumber;
+ (NSArray *)numbers;
+ (NSArray *)shapes;
+ (NSArray *)fills;
+ (NSArray *)colors;

@end

NS_ASSUME_NONNULL_END
