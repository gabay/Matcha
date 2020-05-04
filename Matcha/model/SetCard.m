//
//  SetCard.m
//  Matcha
//
//  Created by Roi Gabay on 23/04/2020.
//  Copyright © 2020 Roi Gabay. All rights reserved.
//

#import "SetCard.h"

@implementation SetCard

+ (unsigned int)maxNumber { return 3; }
+ (unsigned int)maxShape { return 3; }
+ (unsigned int)maxFill { return 3; }
+ (unsigned int)maxColor { return 3; }

+ (NSArray *)numbers
{
    return @[@1, @2, @3];
}

+ (NSArray *)shapes
{
    return @[@"●", @"▲", @"■"];
}

+ (NSArray *)fills
{
    return @[@"clear", @"striped", @"solid"];
}

+ (NSArray *)colors
{
    return @[@"red", @"green", @"purple"];
}

- (int)match:(NSArray *)otherCards
{
    // for each parameter (number, shape, fill, color)
    // check that all cards either agree or disagree
    int score = 0;
    if ([otherCards count] == 2) {
        SetCard *a = [otherCards firstObject];
        SetCard *b = [otherCards lastObject];
        NSLog(@"number: %d shape: %d fill: %d color: %d",
              [self matchNumberWith:a and:b], [self matchShapeWith:a and:b], [self matchFillWith:a and:b], [self matchColorWith:a and:b]);
        if ([self matchNumberWith:a and:b] &&
            [self matchShapeWith:a and:b] &&
            [self matchFillWith:a and:b] &&
            [self matchColorWith:a and:b])
            score = 1;
    }
    return score;
}

- (BOOL)matchNumberWith:(SetCard*)a and:(SetCard *)b
{
    return ((self.number == a.number && self.number == b.number) ||
            (self.number != a.number && self.number != b.number && a.number != b.number)
            );
}

- (BOOL)matchShapeWith:(SetCard*)a and:(SetCard *)b
{
    return ((self.shape == a.shape && self.shape == b.shape) ||
            (self.shape != a.shape && self.shape != b.shape && a.shape != b.shape)
            );
}

- (BOOL)matchFillWith:(SetCard*)a and:(SetCard *)b
{
    return ((self.fill == a.fill && self.fill == b.fill) ||
            (self.fill != a.fill && self.fill != b.fill && a.fill != b.fill)
            );
}

- (BOOL)matchColorWith:(SetCard*)a and:(SetCard *)b
{
    return ((self.color == a.color && self.color == b.color) ||
            (self.color != a.color && self.color != b.color && a.color != b.color)
            );
}


@end
