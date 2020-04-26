//
//  ViewController.h
//  Matcha
//
//  Created by Roi Gabay on 21/04/2020.
//  Copyright © 2020 Roi Gabay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "deck.h"

@interface ViewController : UIViewController

// Subclass should implement the following:

- (Deck *)makeDeck;

- (unsigned int)getMatchSize;

- (NSAttributedString *)titleForCard:(Card *)card;

- (NSAttributedString *)titleForStatus:(Card *)card;

- (UIImage *)backgroundImageForCard:(Card *)card;

@end

