//
//  SetDeck.m
//  Matcha
//
//  Created by Roi Gabay on 23/04/2020.
//  Copyright © 2020 Roi Gabay. All rights reserved.
//

#import "SetDeck.h"
#import "SetCard.h"

@implementation SetDeck
- (instancetype)init
{
    if (self = [super init]) {
        for (unsigned long number = 1; number <= [SetCard maxNumber]; number++) {
            for (unsigned long shape = 1; shape <= [SetCard maxShape]; shape++) {
                for (unsigned long fill = 1; fill <= [SetCard maxFill]; fill++) {
                    for (unsigned long color = 1; color <= [SetCard maxColor]; color++) {
                        SetCard * card = [[SetCard alloc] init];
                        card.number = number;
                        card.shape = shape;
                        card.fill = fill;
                        card.color = color;
                        [self addCard:card];
                    }
                }
            }
        }
    }
    return self;
}
@end
