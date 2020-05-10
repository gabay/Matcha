//
//  HistoryViewController.m
//  Matcha
//
//  Created by Roi Gabay on 26/04/2020.
//  Copyright © 2020 Roi Gabay. All rights reserved.
//

#import "HistoryViewController.h"

@interface HistoryViewController()
@property (weak, nonatomic) IBOutlet UITextView *textarea;
@property (weak, nonatomic) IBOutlet UILabel *totalScoreLabel;
@end

@implementation HistoryViewController

static const double FONT_SIZE = 20;

- (void)viewDidLoad
{
    if (!self.moves) {
        NSLog(@"HistoryViewController: Filling with test data");
        self.moves = @[
            @[@4,[[NSAttributedString alloc] initWithString:@"item 1"]],
            @[@-2, [[NSAttributedString alloc] initWithString:@"item 2" attributes:@{NSForegroundColorAttributeName: [UIColor redColor]}]],
        ];
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    [self updateUI];
}

- (void)updateUI
{
    long totalScore = 0;
    NSMutableAttributedString * text = [[NSMutableAttributedString alloc] init];
    for (NSArray *item in self.moves) {
        NSNumber *score = item.firstObject;
        NSAttributedString *description = item.lastObject;
        totalScore += score.longLongValue;
        [text appendAttributedString:[[NSAttributedString alloc] initWithString:score.stringValue]];
        [text appendAttributedString:[[NSAttributedString alloc] initWithString:@"\t\t|\t"]];
        [text appendAttributedString:description];
        [text appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
    }
    self.textarea.attributedText = text;
    [self.textarea setFont:[UIFont systemFontOfSize:FONT_SIZE]];
    
    [self.totalScoreLabel setText:[NSString stringWithFormat:@"Total Score: %ld", totalScore]];
}

@end
