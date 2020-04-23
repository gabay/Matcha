//
//  CardMatchingGame.m
//  Matcha
//
//  Created by Roi Gabay on 21/04/2020.
//  Copyright © 2020 Roi Gabay. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()
@property (nonatomic, readwrite) NSInteger score;
@property (nonatomic, readwrite) NSInteger scoreDiff;
@property (nonatomic, readwrite) NSString *cardsChanged;
@property (nonatomic, strong) NSMutableArray *cards;
@end

@implementation CardMatchingGame

static const int MISMATCH_PENALTY = 2;
static const int MOVE_PENALTY = 1;

- (NSMutableArray *)cards
{
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (NSString *)cardsChanged
{
    if (!_cardsChanged) _cardsChanged = @"";
    return _cardsChanged;
}

- (instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck match3:(BOOL)match3
{
    if (self = [super init]) {
        for (int i = 0; i < count; i++) {
            Card *card = [deck drawRandomCard];
            if (card) {
                [self.cards addObject:card];
            } else {
                self = nil;
                break;
            }
        }
        self.match3 = match3;
    }
    return self;
}

- (void)chooseCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];
    self.scoreDiff = 0;
    if (!card.matched) {
        self.cardsChanged = [self stringifyCards:@[card]];
        if (card.chosen) {
            card.chosen = NO;
            self.cardsChanged = [self stringifyCards:@[]];
        } else {
            NSArray * chosenCards = [self getChosenCards];
            if ((self.match3 && chosenCards.count == 2) ||
                (!self.match3 && chosenCards.count == 1)) {
                NSArray * currentCards = [chosenCards arrayByAddingObject:card];
                self.cardsChanged = [self stringifyCards:currentCards];
                self.scoreDiff = [self getMatchScore:currentCards];
                if (self.scoreDiff) {
                    [self setMatchedCards:currentCards];
                } else {
                    [self unchooseCards:chosenCards];
                    self.scoreDiff = -MISMATCH_PENALTY;
                }
            }
            self.score += self.scoreDiff - MOVE_PENALTY;
            card.chosen = YES;
        }
    }
}

- (NSArray *)getChosenCards
{
    NSMutableArray * chosenCards = [[NSMutableArray alloc] init];
    for (Card *card in  self.cards) {
        if (card.chosen && !card.matched) {
            [chosenCards addObject:card];
        }
    }
    return chosenCards;
}

- (void)unchooseCards:(NSArray *)cards
{
    for (Card* card in cards) card.chosen = NO;
}

- (void)setMatchedCards:(NSArray *)cards
{
    for (Card* card in cards) card.matched = YES;
}

- (int)getMatchScore:(NSArray *)cards
{
    int score = 0;
    NSMutableArray * seenCards = [[NSMutableArray alloc] init];
    for (Card* card in cards) {
        score += [card match:seenCards];
        [seenCards addObject:card];
    }
    if (cards.count == 3)
        score = score / 2;
    return score;
}

- (NSString *)stringifyCards:(NSArray *)cards
{
    NSMutableString *s = [[NSMutableString alloc] init];
    for (Card *card in cards) {
        [s appendFormat:@"%@ ", card.contents];
    }
    return s;
}

- (Card *)cardAtIndex:(NSUInteger)index
{
    return index < [self.cards count] ? self.cards[index] : nil;
}

@end
