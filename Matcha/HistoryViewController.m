//
//  HistoryViewController.m
//  Matcha
//
//  Created by Roi Gabay on 26/04/2020.
//  Copyright © 2020 Roi Gabay. All rights reserved.
//

#import "HistoryViewController.h"

@implementation HistoryViewController

- (void)viewDidLoad
{
    self.moves = @[
    [[NSAttributedString alloc] initWithString:@"item 1"],
    [[NSAttributedString alloc] initWithString:@"item 2" attributes:@{NSForegroundColorAttributeName: [UIColor redColor]}],
    ];
}
- (void)viewWillAppear:(BOOL)animated
{
    [self updateUI];
}

- (void)updateUI
{
    for (NSAttributedString *item in self.moves) {
        
    }
}

@end
