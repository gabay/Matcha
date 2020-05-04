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

#pragma mark - Initialization

- (void)viewDidLoad {
    self.unchosenCardsAreFaceDown = YES;
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

- (void)updateView:(CardView *)view withCard:(Card *)card
{
    PlayingCard *pc = (PlayingCard *)card;
    PlayingCardView *pcv = (PlayingCardView *)view;
    pcv.rank = pc.rank;
    pcv.suit = pc.suit;
}

- (NSAttributedString *)titleForCard:(Card *)card
{
    if (card.chosen)
        return [self titleForStatus:card];
    else
        return [[NSAttributedString alloc] init];
}

- (NSAttributedString *)titleForStatus:(Card *)card
{
    return [[NSAttributedString alloc]
            initWithString:card.contents
            attributes:@{
                NSForegroundColorAttributeName: [UIColor blackColor]}];
}

- (UIImage *)backgroundImageForCard:(Card *)card
{
    return [UIImage imageNamed:card.chosen ? @"cardfront" : @"cardback"];
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
