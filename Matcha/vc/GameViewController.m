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
@property (strong, nonatomic) IBOutletCollection(CardView) NSMutableArray *cardViews;
@property (strong, nonatomic) CardMatchingGame *game;
@end

@implementation GameViewController

#define FLIP_DURATION 0.3

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
    if (self.removeMatchedCards) {
        for (unsigned long index = 0; index < self.game.cardsCount; index++) {
            if ([self.game cardAtIndex:index].matched) {
                [self.game removeCardAtIndex:index];
                UIView *view = self.cardViews[index];
                [view removeFromSuperview];
                [self.cardViews removeObjectAtIndex:index];
            }
        }
    }
    
    for (CardView *cv in self.cardViews) {
        unsigned long viewIndex = [self.cardViews indexOfObject:cv];
        Card *card = [self.game cardAtIndex:viewIndex];
        BOOL shouldFaceUp = (self.unchosenCardsAreFaceDown) ? card.chosen : YES;
        if (cv.faceUp != shouldFaceUp) {
            [self animateFlipCardView:cv toFaceUp:shouldFaceUp];
        }
        cv.active = !card.matched;
        [self updateView:cv withCard:card];
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %ld", self.game.score];
}

#pragma mark - Animation

- (void)animateFlipCardView:(CardView *)cardView toFaceUp:(BOOL)faceUp {
    [UIView transitionWithView:cardView
                      duration:FLIP_DURATION
                       options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{cardView.faceUp = faceUp;}
                    completion:^(BOOL fin){}];
}

# pragma mark - Abstract Methods

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
