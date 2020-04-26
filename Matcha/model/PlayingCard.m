//
//  PlaingCard.m
//  Match
//
//  Created by Roi Gabay on 21/04/2020.
//  Copyright © 2020 Roi Gabay. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

- (NSString *)contents
{
    NSArray *rankStrings = [PlayingCard rankStrings];
    return [rankStrings[self.rank] stringByAppendingString:self.suit];
}

@synthesize suit = _suit;
@synthesize rank = _rank;

+ (NSArray *)validSuits
{
    return @[@"♠︎", @"♣︎", @"♥︎", @"♦︎"];
}

+ (NSUInteger)maxRank
{
    return [[PlayingCard rankStrings] count] - 1;
}

- (void)setSuit:(NSString *)suit
{
    if ([[PlayingCard validSuits] containsObject:suit]) {
        _suit = suit;
    }
}

- (NSString *)suit
{
    return _suit ? _suit : @"?";
}

- (void)setRank:(NSUInteger)rank
{
    if (rank <= [PlayingCard maxRank]) {
        _rank = rank;
    }
}

- (NSUInteger)rank
{
    return _rank ? _rank : 0;
}

+ (NSArray *)rankStrings
{
    return @[@"?", @"A", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K"];
}

- (int)match:(NSArray *)otherCards
{
    int score = 0;
    if (otherCards.count) {
        score = [[otherCards firstObject]
                 match:[otherCards subarrayWithRange:NSMakeRange(1, otherCards.count - 1)]];
        for (PlayingCard *other in otherCards) {
            if (self.rank == other.rank)
                score += 16;
            else if (self.suit == other.suit)
                score += 4;
        }
    }
    return score;
}


@end
