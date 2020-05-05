//
//  MatchViewController.m
//  Matcha
//
//  Created by Roi Gabay on 23/04/2020.
//  Copyright © 2020 Roi Gabay. All rights reserved.
//

#import "MatchViewController.h"
#import "PlayingCard.h"
#import "PlayingCardDeck.h"
#import "PlayingCardView.h"

@interface MatchViewController ()

@end

@implementation MatchViewController

#define CARDS_IN_MATCH_GAME 12

#pragma mark - Initialization

- (void)viewDidLoad {
    self.unchosenCardsAreFaceDown = YES;
    self.removeMatchedCards = NO;
    self.cardsInGame = CARDS_IN_MATCH_GAME;
    [super viewDidLoad];
}

- (Deck *)makeDeck
{
    return [[PlayingCardDeck alloc] init];
}
- (unsigned int)getMatchSize
{
    return 2;
}

- (void)updateUIForCardView:(CardView *)view withCard:(Card *)card
{
    PlayingCard *pc = (PlayingCard *)card;
    PlayingCardView *pcv = (PlayingCardView *)view;
    pcv.rank = pc.rank;
    pcv.suit = pc.suit;
}

- (CardView *)newCardViewInFrame:(CGRect)frame
{
    return [[PlayingCardView alloc] initWithFrame:frame];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
