//
//  GameViewController.m
//  Matcha
//
//  Created by Roi Gabay on 21/04/2020.
//  Copyright © 2020 Roi Gabay. All rights reserved.
//

#import "GameViewController.h"
#import "HistoryViewController.h"
#import "CardMatchingGame.h"

@interface GameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) IBOutletCollection(CardView) NSArray *cardViews;
@property (strong, nonatomic) CardMatchingGame *game;
@end

@implementation GameViewController

#pragma mark - Members

- (CardMatchingGame *)game {
    if (!_game) {
        NSLog(@"Creating game with %ld cards", [self.cardViews count]);
        _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardViews count]
                                                   usingDeck:[self makeDeck]
                                                      matchSize:[self getMatchSize]];
    }
    return _game;
}

#pragma mark - Initialization

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // set tap gesture for all cards
    for (CardView *cv in self.cardViews) {
        [cv addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchCard:)]];
    }
    
    NSLog(@"%@ loaded", self.class);
    [self updateUI];
}

#pragma mark - Gestures

- (IBAction)touchCard:(UITapGestureRecognizer *)sender
{
    UIView *view = sender.view;
    
    unsigned long index = [self.cardViews indexOfObject:view];
    [self.game chooseCardAtIndex:index];
    
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
    for (CardView *cv in self.cardViews) {
        unsigned long viewIndex = [self.cardViews indexOfObject:cv];
        Card *card = [self.game cardAtIndex:viewIndex];
        cv.faceUp = (self.unchosenCardsAreFaceDown) ? card.chosen : YES;
        cv.active = !card.matched;
        [self updateView:cv withCard:card];
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %ld", self.game.score];
}

- (void)updateView:(CardView *)view withCard:(Card *)card
{}

- (Deck *)makeDeck
{
    return nil;
}
                 
- (unsigned int)getMatchSize
{
    return 0;
}

@end
