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
@property (strong, nonatomic) NSMutableArray *stackOfCardViews;
@property (strong, nonatomic) UIView *stackView;

// Dynamic animation
@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) UISnapBehavior *attachment;
@end

@implementation GameViewController

#define FLIP_DURATION 0.3
#define MOVE_DURATION 0.5

#define CARD_ASPECT_RATIO 0.7
#define STACK_PORTION_OF_VIEW 0.3

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

- (NSMutableArray *)stackOfCardViews
{
    if (!_stackOfCardViews) {
        _stackOfCardViews = [[NSMutableArray alloc] init];
    }
    return _stackOfCardViews;
}

- (UIView *)stackView
{
    if (!_stackView) {
        CGFloat width = self.view.bounds.size.width * STACK_PORTION_OF_VIEW;
        CGFloat height = width / CARD_ASPECT_RATIO;
        CGFloat x = self.view.center.x - width / 2;
        CGFloat y = self.view.center.y - height / 2;
        _stackView = [[UIView alloc] initWithFrame:CGRectMake(x, y, width, height)];
        _stackView.backgroundColor = nil;
        _stackView.opaque = NO;
        [self.view addSubview:_stackView];
    }
    return _stackView;
}

- (UIDynamicAnimator *)animator
{
    if (!_animator) {
        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    }
    return _animator;
}

#pragma mark - Initialization

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"%@ loaded", self.class);
}

- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"%@ appeared", self.class);
    [self updateUI];
}

#pragma mark - Gestures

- (IBAction)touchCard:(UITapGestureRecognizer *)sender
{
    UIView *view = sender.view;
    unsigned long index = [self.cardViews indexOfObject:view];
    NSLog(@"Touch card #%ld", index);
    
    if ([self.stackOfCardViews containsObject:view]) {
        [self dismissStackOfCards];
    } else {
        [self.game chooseCardAtIndex:index];
    }
    
    [self updateUI];
}

- (IBAction)touchRedeal:(UIButton *)sender
{
    NSLog(@"Touch Redeal button");
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
    NSLog(@"Touch Draw3 button");
    [self.game drawCard];
    [self.game drawCard];
    [self.game drawCard];
    
    [self updateUI];
}

- (IBAction)pinchCard:(UIPinchGestureRecognizer *)sender
{
    NSLog(@"Pinch card");
    if (sender.state == UIGestureRecognizerStateBegan) {
        CardView *cardView = (CardView *)sender.view;
        [self stackCardView:cardView];
    }
}

- (IBAction)panStackOfCards:(UIPanGestureRecognizer *)sender
{
    if ([self.stackOfCardViews containsObject:sender.view]) {
        NSLog(@"Pan stack");
        CGPoint gesturePoint = [sender locationInView:self.view];
        if (sender.state == UIGestureRecognizerStateBegan) {
            [self attachStackToPoint:gesturePoint];
        } else if (sender.state == UIGestureRecognizerStateChanged) {
            self.attachment.snapPoint = gesturePoint;
        } else if (sender.state == UIGestureRecognizerStateEnded) {
            [self.animator removeBehavior:self.attachment];
            self.attachment = nil;
        }
    }
}

#pragma mark - cards stack

- (void)stackCardView:(CardView *)cardView
{
    if (![self.stackOfCardViews containsObject:cardView]) {
        [self.stackOfCardViews addObject:cardView];
        
        [self.cardsContainerView bringSubviewToFront:cardView];
        [self moveCardView:cardView toSuperview:self.stackView];
        [self animateMoveCardView:cardView toFrame:self.stackView.bounds];
    }
}

- (void)attachStackToPoint:(CGPoint)point
{
    self.attachment = [[UISnapBehavior alloc] initWithItem:self.stackView snapToPoint:point];
    [self.animator addBehavior:self.attachment];
}

- (void)dismissStackOfCards
{
    NSLog(@"Dismissing Stack");
    for (CardView *cardView in self.stackOfCardViews) {
        [self moveCardView:cardView toSuperview:self.cardsContainerView];
        [self.cardsContainerView addSubview:cardView];
    }
    self.stackOfCardViews = nil;
    [self.stackView removeFromSuperview];
    self.stackView = nil;
    [self updateUI];
}

- (void)moveCardView:(CardView *)cardView toSuperview:(UIView *)superview
{
    UIView *previousSuperview = cardView.superview;
    [superview addSubview:cardView];
    CGRect originalFrame = cardView.frame;
    originalFrame.origin.x += previousSuperview.frame.origin.x - superview.frame.origin.x;
    originalFrame.origin.y += previousSuperview.frame.origin.y - superview.frame.origin.y;

    [cardView setFrame:originalFrame];
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
        [cv addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchCard:)]];
        [cv addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchCard:)]];
        [cv addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panStackOfCards:)]];
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
    Grid *grid = [[Grid alloc] init];
    grid.size = self.cardsContainerView.bounds.size;
    grid.cellAspectRatio = CARD_ASPECT_RATIO;
    grid.minimumNumberOfCells = MAX(self.numberOfCardsInGame, self.cardViews.count);
    NSLog(@"%@", [grid description]);
    
    for (CardView *cardView in self.cardViews) {
        if (![self.stackOfCardViews containsObject:cardView]) {
            NSUInteger index = [self.cardViews indexOfObject:cardView];
            CGRect frame = CGRectInset([grid FrameOfCellAtIndex:index], 3, 3);
            [self animateMoveCardView:cardView toFrame:frame];
        }
    }
}

- (void)animateMoveCardView:(CardView *)cardView toFrame:(CGRect)frame
{
    __weak GameViewController *weakSelf = self;
    [UIView animateWithDuration:MOVE_DURATION
                          delay: 0.0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
            [cardView setFrame:frame];
            [weakSelf updateUIForCardView:cardView];
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
