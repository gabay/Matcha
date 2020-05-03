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
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) IBOutletCollection(CardView) NSArray *cardViews;
@property (strong, nonatomic) CardMatchingGame *game;
@end

@implementation GameViewController

- (CardMatchingGame *)game {
    if (!_game) {
        NSLog(@"Creating game with %ld cards", [self.cardViews count]);
        _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardViews count]
                                                   usingDeck:[self makeDeck]
                                                      matchSize:[self getMatchSize]];
    }
    return _game;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"%@ loaded", self.class);
    for (CardView *cv in self.cardViews) {
        [cv addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:cv action:@selector(tap:)]];
    }
    [self updateUI];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showHistory"]) {
        if ([segue.destinationViewController isKindOfClass:[HistoryViewController class]]) {
            HistoryViewController *hvc = (HistoryViewController *)segue.destinationViewController;
            hvc.moves = [self formatMoves];
        }
    }
}

- (NSArray *)formatMoves
{
    NSMutableArray *moves = [[NSMutableArray alloc] init];
    for (NSArray *item in self.game.moves) {
        NSNumber *scoreDiff = item.firstObject;
        NSArray *cards = item.lastObject;
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] init];
        [text appendAttributedString:[self formatCards:cards]];
        if (scoreDiff.intValue > 0) {
            [text appendAttributedString:[[NSAttributedString alloc] initWithString:@" match"]];
        } else if (scoreDiff.intValue < 0) {
            [text appendAttributedString:[[NSAttributedString alloc] initWithString:@" don't match"]];
        }
        [moves addObject:@[scoreDiff, text]];
    }
    return moves;
}

- (IBAction)touchCard:(CardView *)sender
{
    //sender.faceUp = !sender.faceUp;
    //unsigned long buttonIndex = [self.cardViews indexOfObject:sender];
    //[self.game chooseCardAtIndex:buttonIndex];
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
    for (CardView *view in self.cardViews) {
        unsigned long viewIndex = [self.cardViews indexOfObject:view];
        Card *card = [self.game cardAtIndex:viewIndex];
        [self updateView:view withCard:card];
        // [button setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
        // [view setAttributedTitle:[self titleForCard:card] forState:UIControlStateNormal];
        // view.enabled = !card.matched;
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %ld", self.game.score];
    [self updateStatus];
}

- (void)updateView:(CardView *)view withCard:(Card *)card
{}

- (void)updateStatus
{
    NSMutableAttributedString *status = [[NSMutableAttributedString alloc] init];
    [status appendAttributedString:[self formatCards:self.game.cardsChanged]];
    if (self.game.scoreDiff > 0) {
        NSString *text = [NSString stringWithFormat:@"Matched! %ld points", self.game.scoreDiff];
        [status appendAttributedString:[[NSAttributedString alloc] initWithString:text]];
    } else if (self.game.scoreDiff < 0) {
        NSString *text = [NSString stringWithFormat:@"Don't match! %ld points", self.game.scoreDiff];
        [status appendAttributedString:[[NSAttributedString alloc] initWithString:text]];
    }
    self.statusLabel.attributedText = status;
}
- (NSAttributedString *)formatCards:(NSArray *)cards
{
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] init];
    for (Card *card in cards) {
        [text appendAttributedString:[self titleForStatus:card]];
        if (card != cards.lastObject)
            [text appendAttributedString:[[NSAttributedString alloc] initWithString:@", "]];
    }
    return text;
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
