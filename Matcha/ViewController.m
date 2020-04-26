//
//  ViewController.m
//  Matcha
//
//  Created by Roi Gabay on 21/04/2020.
//  Copyright © 2020 Roi Gabay. All rights reserved.
//

#import "ViewController.h"
#import "CardMatchingGame.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (strong, nonatomic) CardMatchingGame *game;
@end

@implementation ViewController

- (CardMatchingGame *)game {
    if (!_game) {
        NSLog(@"Creating game with %ld cards", [self.cardButtons count]);
        _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                   usingDeck:[self makeDeck]
                                                      matchSize:[self getMatchSize]];
    }
    return _game;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"%@ loaded", self.class);
    [self updateUI];
}

- (IBAction)touchCard:(UIButton *)sender
{
    unsigned long buttonIndex = [self.cardButtons indexOfObject:sender];
    [self.game chooseCardAtIndex:buttonIndex];
    [self updateUI];
}

- (IBAction)touchRedeal:(UIButton *)sender
{
    // Redraw cards and reset score
    self.game = nil;
    [self updateUI];
}

- (void)updateUI
{
    for (UIButton * button in self.cardButtons) {
        unsigned long buttonIndex = [self.cardButtons indexOfObject:button];
        Card *card = [self.game cardAtIndex:buttonIndex];
        [button setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
        [button setAttributedTitle:[self titleForCard:card] forState:UIControlStateNormal];
        button.enabled = !card.matched;
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %ld", self.game.score];
    [self updateStatus];
}

- (void)updateStatus
{
    NSMutableAttributedString *status = [[NSMutableAttributedString alloc] init];
    for (Card *card in self.game.cardsChanged) {
        [status appendAttributedString:[self titleForStatus:card]];
        [status appendAttributedString:[[NSAttributedString alloc] initWithString:@", "]];
    }
    if (self.game.scoreDiff > 0) {
        NSString *text = [NSString stringWithFormat:@"Matched! %ld points", self.game.scoreDiff];
        [status appendAttributedString:[[NSAttributedString alloc] initWithString:text]];
    } else if (self.game.scoreDiff < 0) {
        NSString *text = [NSString stringWithFormat:@"Don't match! %ld points", self.game.scoreDiff];
        [status appendAttributedString:[[NSAttributedString alloc] initWithString:text]];
    }
    [self.statusLabel setAttributedText:status];
}

- (Deck *)makeDeck
{
    return nil;
}
                 
- (unsigned int)getMatchSize
{
    return 0;
}

- (NSAttributedString *)titleForCard:(Card *)card
{
    return nil;
}

- (NSAttributedString *)titleForStatus:(Card *)card
{
    return nil;
}



- (UIImage *)backgroundImageForCard:(Card *)card
{
    return [UIImage imageNamed:card.chosen ? @"cardfront" : @"cardback"];
}



@end
