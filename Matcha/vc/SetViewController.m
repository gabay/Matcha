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

@interface SetViewController ()

@end

@implementation SetViewController

- (void)viewDidLoad {
    self.unchosenCardsAreFaceDown = NO;
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

- (NSAttributedString *)titleForCard:(Card *)card
{
    return [self titleForStatus:card];
}

- (NSAttributedString *)titleForStatus:(Card *)card
{
    SetCard * setCard = (SetCard *)card;
    NSString *titleString = [setCard.shape stringByPaddingToLength:setCard.number
                                                    withString:setCard.shape
                                                startingAtIndex:0];
    return [[NSMutableAttributedString alloc]
            initWithString:titleString
            attributes:@{
                NSForegroundColorAttributeName: [self fillColorForCard:setCard],
                NSStrokeWidthAttributeName: @-5,
                NSStrokeColorAttributeName: [self strokeColorForCard:setCard]
            }];
}

- (UIColor *)colorForCard:(SetCard *)setCard
{
    if ([setCard.color isEqualToString:@"red"])
            return [UIColor redColor];
    if ([setCard.color isEqualToString:@"green"])
            return [UIColor greenColor];
    if ([setCard.color isEqualToString:@"purple"])
            return [UIColor purpleColor];
            
    NSLog(@"Unknown color %@", setCard.color);
    return [UIColor blackColor];
}

- (UIColor *)fillColorForCard:(SetCard *)setCard
{
    UIColor *color = [self colorForCard:setCard];
    if ([setCard.fill isEqualToString:@"clear"])
        return [UIColor clearColor];
    if ([setCard.fill isEqualToString:@"striped"])
        return [color colorWithAlphaComponent:0.1];
    if ([setCard.fill isEqualToString:@"solid"])
        return color;
    
    NSLog(@"Unknown fill %@", setCard.fill);
    return color;
}

- (UIColor *)strokeColorForCard:(SetCard *)setCard
{
    UIColor *color = [self colorForCard:setCard];
    /*if ([setCard.fill isEqualToString:@"clear"])
        return color;
    if ([setCard.fill isEqualToString:@"striped"])
        return [color colorWithAlphaComponent:0.5];
    if ([setCard.fill isEqualToString:@"solid"])
        return [UIColor clearColor];
    
    NSLog(@"Unknown fill %@", setCard.fill);
    */return color;
}

- (UIImage *)backgroundImageForCard:(Card *)card
{
    return [UIImage imageNamed:card.chosen ? @"cardchosen" : @"cardfront"];
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
