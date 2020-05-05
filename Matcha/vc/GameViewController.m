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
#define MOVE_DURATION 0.5

#define CARD_ASPECT_RATIO 0.7

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
        _grid.cellAspectRatio = CARD_ASPECT_RATIO;
        _grid.minimumNumberOfCells = MAX(self.numberOfCardsInGame, self.cardViews.count);
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
    for (CardView *cardView in self.cardViews) {
        [self animateRemoveCardView:cardView];
    }
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
    
    [self drawNewCards];
    
    [self addCardViews];
    
    [self animateMoveCardViews];

    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %ld", self.game.score];
}

- (void)removeViewsOfMatchedCards
{
    NSMutableArray *viewsToRemove = [NSMutableArray array];
    for (unsigned long index = 0; index < self.game.cardsCount; index++) {
        if ([self.game cardAtIndex:index].matched) {
            [viewsToRemove addObject:self.cardViews[index]];
        }
    }
    for (CardView *cv in viewsToRemove) {
        unsigned long index = [self.cardViews indexOfObject:cv];
        [self.game removeCardAtIndex:index];
        [self.cardViews removeObject:cv];
        [self animateRemoveCardView:cv];
    }
}

- (void)drawNewCards
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

- (void)addCardViews
{
    while (self.cardViews.count < self.game.cardsCount) {
        // create card on bottom right
        CGRect frame = CGRectMake(0, self.view.bounds.size.height, 0, 0);
        CardView *cv = [self newCardViewInFrame:frame];
        [self.cardsContainerView addSubview:cv];
        [self.cardViews addObject:cv];
        
        // set gestures
        [cv addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                         action:@selector(touchCard:)]];
    }
}

#pragma mark - Animation

- (void)animateFlipCardView:(CardView *)cardView toFaceUp:(BOOL)faceUp {
    [UIView transitionWithView:cardView
                      duration:FLIP_DURATION
                       options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{cardView.faceUp = faceUp;}
                    completion:^(BOOL fin){}];
}

- (void)animateMoveCardViews {
    // Generate a new grid each time
    self.grid = nil;
    __weak GameViewController *weakSelf = self;
    [UIView animateWithDuration:MOVE_DURATION
                          delay: 0.0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
        for (CardView *cv in weakSelf.cardViews) {
            NSUInteger index = [weakSelf.cardViews indexOfObject:cv];
            CGRect newFrame = CGRectInset([weakSelf.grid FrameOfCellAtIndex:index], 3, 3);
            [cv setFrame:newFrame];
            [weakSelf updateUIForCardView:cv];
        }
    }
                     completion:nil];
}

- (void)animateRemoveCardView:(CardView *)cardView
{
    // move to bottom right, then remove
    CGFloat x = self.view.bounds.size.width;
    CGFloat y = self.view.bounds.size.height;
    [UIView transitionWithView:cardView
                      duration:MOVE_DURATION
                       options:UIViewAnimationOptionBeginFromCurrentState
                    animations:^{[cardView setFrame:CGRectMake(x, y, 0, 0)];}
                    completion:^(BOOL fin){[cardView removeFromSuperview];}];
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
