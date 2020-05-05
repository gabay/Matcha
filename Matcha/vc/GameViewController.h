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

// Subclass should implement the following:

- (Deck *)makeDeck;

- (unsigned int)getMatchSize;

- (void)updateView:(CardView *)view withCard:(Card *)card;

@end

