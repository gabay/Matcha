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
@property (nonatomic, readwrite) NSArray *moves;
@property (nonatomic, strong) NSMutableArray *cards;
@property (nonatomic, strong) Deck *deck;
@end

@implementation CardMatchingGame

static const int MISMATCH_PENALTY = -2;

#pragma mark - Initialization

- (instancetype)initWithCardCount:(NSUInteger)count
                        usingDeck:(Deck *)deck
                        matchSize:(unsigned int)matchSize
{
    if (self = [super init]) {
        self.cards = [[NSMutableArray alloc] init];
        self.moves = [[NSMutableArray alloc] init];
        self.deck = deck;
        for (int i = 0; i < count; i++) {
            if (![self drawCard]) {
                self = nil;
                break;
            }
        }
        self.matchSize = matchSize;
    }
    return self;
}

#pragma mark - Members

- (NSUInteger)count
{
    return self.cards.count;
}

#pragma mark - Methods

- (void)chooseCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];
    if (!card.matched) {
        if (!card.chosen) {
            NSArray *previouslyChosenCards = [self getChosenCards];
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
    NSArray *cardsToMatch = [cards arrayByAddingObject:card];
    int scoreDiff = [card match:cards];
    if (scoreDiff) {
        [self setMatchedCards:cardsToMatch];
    } else {
        [self unchooseCards:cards];
        scoreDiff = MISMATCH_PENALTY;
    }
    self.score += scoreDiff;
    self.moves = [self.moves arrayByAddingObject:@[[NSNumber numberWithInteger:scoreDiff], cardsToMatch]];
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

- (Card *)cardAtIndex:(NSUInteger)index
{
    return index < [self.cards count] ? self.cards[index] : nil;
}

- (void)removeCardAtIndex:(NSUInteger)index
{
    [self.cards removeObjectAtIndex:index];
}

- (BOOL)drawCard
{
    Card *card = [self.deck drawRandomCard];
    if (!card) {
        return NO;
    }
    [self.cards addObject:card];
    return YES;
}

@end
