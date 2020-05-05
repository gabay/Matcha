//
//  GameViewController.h
//  Matcha
//
//  Created by Roi Gabay on 21/04/2020.
//  Copyright © 2020 Roi Gabay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "deck.h"
#import "CardView.h"

@interface GameViewController : UIViewController

@property (nonatomic) BOOL unchosenCardsAreFaceDown;
@property (nonatomic) BOOL removeMatchedCards;
@property (nonatomic) NSUInteger cardsInGame;

// Subclass should implement the following:

- (Deck *)makeDeck;

- (unsigned int)getMatchSize;

- (void)updateUIForCardView:(CardView *)view withCard:(Card *)card;

- (CardView *)newCardViewInFrame:(CGRect)frame;

@end

static const CGSize DEFUALT_CARD_SIZE = {80, 140};
