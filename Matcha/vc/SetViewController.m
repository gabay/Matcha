//
//  SetViewController.m
//  Matcha
//
//  Created by Roi Gabay on 23/04/2020.
//  Copyright © 2020 Roi Gabay. All rights reserved.
//

#import "SetViewController.h"
#import "SetDeck.h"
#import "SetCard.h"
#import "SetCardView.h"

@interface SetViewController ()

@end

@implementation SetViewController

#define CARDS_IN_SET_GAME 12

- (void)viewDidLoad {
    self.unchosenCardsAreFaceDown = NO;
    self.removeMatchedCards = YES;
    self.cardsInGame = CARDS_IN_SET_GAME;
    [super viewDidLoad];
}

- (Deck *)makeDeck
{
    return [[SetDeck alloc] init];
}
- (unsigned int)getMatchSize
{
    return 3;
}

- (void)updateUIForCardView:(CardView *)view withCard:(Card *)card
{
    SetCard *sc = (SetCard *)card;
    SetCardView *scv = (SetCardView *)view;
    scv.number = sc.number;
    scv.shape = sc.shape;
    scv.fill = sc.fill;
    scv.color = sc.color;
}

- (CardView *)newCardViewInFrame:(CGRect)frame
{
    return [[SetCardView alloc] initWithFrame:frame];
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
