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
#import "Grid.h"

@interface GameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UIView *cardsContainerView;
@property (strong, nonatomic) NSMutableArray *cardViews;
@property (strong, nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) Grid *grid;
@end

@implementation GameViewController

#define FLIP_DURATION 0.3

#pragma mark - Members

- (NSMutableArray *)cardViews {
    if (!_cardViews) {
        _cardViews = [NSMutableArray array];
    }
    return _cardViews;
}

- (CardMatchingGame *)game {
    if (!_game) {
        NSLog(@"Creating game with %ld cards", self.numberOfCardsInGame);
        _game = [[CardMatchingGame alloc] initWithCardCount:self.numberOfCardsInGame
                                                  usingDeck:[self makeDeck]
                                                  matchSize:[self getMatchSize]];
    }
    return _game;
}

- (Grid *)grid
{
    if (!_grid) {
        _grid = [[Grid alloc] init];
        _grid.size = self.cardsContainerView.bounds.size;
        _grid.cellAspectRatio = 0.7;
        _grid.minimumNumberOfCells = self.maxNumberOfCardsInGame;
        NSLog(@"%@", [_grid description]);
        if (!_grid.inputsAreValid) {
            _grid = nil;
        }
    }
    return _grid;
}

#pragma mark - Initialization

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"%@ loaded", self.class);
    [self updateUI];
}

#pragma mark - Gestures

- (IBAction)touchCard:(UITapGestureRecognizer *)sender
{
    UIView *view = sender.view;
    unsigned long index = [self.cardViews indexOfObject:view];
    NSLog(@"Touched card #%ld", index);
    
    [self.game chooseCardAtIndex:index];
    
    [self updateUI];
}

- (IBAction)touchRedeal:(UIButton *)sender
{
    NSLog(@"Touched Redeal button");
    // Redraw cards and reset score
    self.game = nil;
    [self.cardViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.cardViews = nil;
    [self updateUI];
}

- (IBAction)touchDeal3:(UIButton *)sender
{
    NSLog(@"Touched Draw3 button");
    //TODO: draw 3 cards
    [self.game drawCard];
    [self.game drawCard];
    [self.game drawCard];
    
    [self updateUI];
}

#pragma mark - UI update

- (void)updateUI
{
    if (self.removeMatchedCards) {
        [self removeViewsOfMatchedCards];
    }
    
    [self drawCards];
    while (self.cardViews.count < self.game.cardsCount) {
        [self addCardView];
    }
    
    for (CardView *cv in self.cardViews) {
        [self updateUIForCardView:cv];
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %ld", self.game.score];
}

- (void)removeViewsOfMatchedCards
{
    for (unsigned long index = 0; index < self.game.cardsCount; index++) {
        if ([self.game cardAtIndex:index].matched) {
            [self.game removeCardAtIndex:index];
            UIView *view = self.cardViews[index];
            [view removeFromSuperview];
            [self.cardViews removeObjectAtIndex:index];
        }
    }
}

- (void)drawCards
{
    while (self.game.cardsCount < self.numberOfCardsInGame) {
        if (![self.game drawCard]) {
            // out of cards :)
            break;
        };
    }
}

- (void)updateUIForCardView:(CardView *)cv
{
    unsigned long viewIndex = [self.cardViews indexOfObject:cv];
    Card *card = [self.game cardAtIndex:viewIndex];
    
    BOOL shouldFaceUp = (self.unchosenCardsAreFaceDown) ? card.chosen : YES;
    if (cv.faceUp != shouldFaceUp) {
        [self animateFlipCardView:cv toFaceUp:shouldFaceUp];
    }
    cv.active = !card.matched;
    [self updateUIForCardView:cv withCard:card];
}

- (void)addCardView
{
    // create card
    NSUInteger index = self.cardViews.count;
    CGRect frame;
    frame.origin = [self.grid originOfCellAtIndex:index];
    frame.size = self.grid.cellSize;
    CardView *cv = [self newCardViewInFrame:frame];
    [self.cardsContainerView addSubview:cv];
    [self.cardViews addObject:cv];
    
    // set gestures
    [cv addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                     action:@selector(touchCard:)]];
    
    // animate it in (TODO)

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

- (void)updateUIForCardView:(CardView *)view withCard:(Card *)card
{}

- (Deck *)makeDeck
{
    return nil;
}
                 
- (unsigned int)getMatchSize
{
    return 0;
}

- (CardView *)newCardViewInFrame:(CGRect)frame
{
    return nil;
}

@end
