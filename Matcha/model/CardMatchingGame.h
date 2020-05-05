//
//  CardMatchingGame.h
//  Matcha
//
//  Created by Roi Gabay on 21/04/2020.
//  Copyright © 2020 Roi Gabay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"
#import "Card.h"

NS_ASSUME_NONNULL_BEGIN

@interface CardMatchingGame : NSObject

// designated initializer
- (instancetype)initWithCardCount:(NSUInteger)count
                        usingDeck:(Deck *)deck
                        matchSize:(unsigned int)matchSize;
- (void)chooseCardAtIndex:(NSUInteger)index;
- (Card *)cardAtIndex:(NSUInteger)index;

- (void)removeCardAtIndex:(NSUInteger)index;
- (BOOL)drawCard;

@property (nonatomic, readonly) NSInteger score;
@property (nonatomic, readonly) NSArray * moves;
@property (nonatomic, readonly) NSUInteger count;
@property (nonatomic) unsigned int matchSize;
@end

NS_ASSUME_NONNULL_END
