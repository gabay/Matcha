//
//  Card.m
//  Match
//
//  Created by Roi Gabay on 20/04/2020.
//  Copyright © 2020 Roi Gabay. All rights reserved.
//

#import "Card.h"

@implementation Card

- (int)match:(NSArray *)otherCards
{
    int score = 0;
    
    for (Card *other in otherCards) {
        if ([self.contents isEqualToString:other.contents]) {
            score = 1;
        }
    }
    
    return score;
}
@end
