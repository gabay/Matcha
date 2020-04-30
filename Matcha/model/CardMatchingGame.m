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
@property (nonatomic, readwrite) NSArray *cardsChanged;
@property (nonatomic, readwrite) NSArray *moves;
@property (nonatomic, strong) NSMutableArray *cards;
@end

@implementation CardMatchingGame

static const int MISMATCH_PENALTY = -2;

- (NSMutableArray *)cards
{
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (NSArray *)cardsChanged
{
    if (!_cardsChanged) _cardsChanged = @[];
    return _cardsChanged;
}

- (NSArray *)moves
{
    if (!_moves) _moves = [[NSMutableArray alloc] init];
    return _moves;
}

- (instancetype)initWithCardCount:(NSUInteger)count
                        usingDeck:(Deck *)deck
                        matchSize:(unsigned int)matchSize
{
    if (self = [super init]) {
        for (int i = 0; i < count; i++) {
            Card *card = [deck drawRandomCard];
            if (!card) {
                self = nil;
                break;
            }
            [self.cards addObject:card];
        }
        self.matchSize = matchSize;
    }
    return self;
}

- (void)chooseCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];
    self.scoreDiff = 0;
    self.cardsChanged = @[];
    if (!card.matched) {
        if (!card.chosen) {
            NSArray *previouslyChosenCards = [self getChosenCards];
            self.cardsChanged = @[card];
            if (self.matchSize == previouslyChosenCards.count + 1) {
                [self matchCard:card
                      withCards:previouslyChosenCards];
            }
        }
        card.chosen = !card.chosen;
    }
}

- (void)matchCard:(Card *)card withCards:(NSArray *)cards
{
    self.cardsChanged = [cards arrayByAddingObject:card];
    self.scoreDiff = [card match:cards];
    if (self.scoreDiff) {
        [self setMatchedCards:self.cardsChanged];
    } else {
        [self unchooseCards:cards];
        self.scoreDiff = MISMATCH_PENALTY;
    }
    self.score += self.scoreDiff;
    self.moves = [self.moves arrayByAddingObject:@[[NSNumber numberWithInteger:self.scoreDiff], self.cardsChanged]];
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

- (Card *)cardAtIndex:(NSUInteger)index
{
    return index < [self.cards count] ? self.cards[index] : nil;
}

@end
