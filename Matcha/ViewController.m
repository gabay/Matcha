//
//  ViewController.m
//  Matcha
//
//  Created by Roi Gabay on 21/04/2020.
//  Copyright © 2020 Roi Gabay. All rights reserved.
//

#import "ViewController.h"
#import "CardMatchingGame.h"
#import "PlayingCardDeck.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *gameModeSelector;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (strong, nonatomic) CardMatchingGame *game;
@end

@implementation ViewController

- (CardMatchingGame *)game {
    if (!_game)
        _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                   usingDeck:[self makeDeck]
                                                      match3:[self.gameModeSelector selectedSegmentIndex] == 0 ? NO : YES];
    return _game;
}

- (IBAction)touchCard:(UIButton *)sender
{
    unsigned long buttonIndex = [self.cardButtons indexOfObject:sender];
    [self.game chooseCardAtIndex:buttonIndex];
    self.gameModeSelector.enabled = NO;
    [self updateUI];
}

- (IBAction)touchRedeal:(UIButton *)sender
{
    // Redraw cards and reset score
    self.game = nil;
    self.gameModeSelector.enabled = YES;
    [self updateUI];
}
- (IBAction)touch23match:(UISegmentedControl *)sender
{
    self.game.match3 = [sender selectedSegmentIndex] == 0 ? NO : YES;
}

- (void)updateUI
{
    for (UIButton * button in self.cardButtons) {
        unsigned long buttonIndex = [self.cardButtons indexOfObject:button];
        Card *card = [self.game cardAtIndex:buttonIndex];
        [button setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
        [button setTitle:[self titleForCard:card] forState:UIControlStateNormal];
        button.enabled = !card.matched;
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %ld", self.game.score];
    if (self.game.scoreDiff == 0) {
        self.statusLabel.text = self.game.cardsChanged;
    } else if (self.game.scoreDiff > 0) {
        self.statusLabel.text = [NSString stringWithFormat:@"Matched %@ for %ld points", self.game.cardsChanged, self.game.scoreDiff];
    } else {
        self.statusLabel.text = [NSString stringWithFormat:@"%@ don't match! %ld points", self.game.cardsChanged, self.game.scoreDiff];
    }
}

- (Deck *)makeDeck
{
    return [[PlayingCardDeck alloc] init];
}

- (NSString *)titleForCard:(Card *)card
{
    return card.chosen? card.contents : @"";
}

- (UIImage *)backgroundImageForCard:(Card *)card
{
    return [UIImage imageNamed:card.chosen ? @"cardfront" : @"cardback"];
}


@end
