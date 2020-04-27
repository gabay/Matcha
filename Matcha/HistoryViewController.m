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
@end

@implementation HistoryViewController

- (void)viewDidLoad
{
    if (!self.moves) {
        NSLog(@"HistoryViewController: Filling with test data");
        self.moves = @[
            @[[NSNumber numberWithInt:4],[[NSAttributedString alloc] initWithString:@"item 1"]],
            @[[NSNumber numberWithInt:-2], [[NSAttributedString alloc] initWithString:@"item 2" attributes:@{NSForegroundColorAttributeName: [UIColor redColor]}]],
        ];
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    [self updateUI];
}

- (void)updateUI
{
    NSMutableAttributedString * text = [[NSMutableAttributedString alloc] init];
    for (NSArray *item in self.moves) {
        NSNumber *score = item.firstObject;
        NSAttributedString *description = item.lastObject;
        [text appendAttributedString:[[NSAttributedString alloc] initWithString:score.stringValue]];
        [text appendAttributedString:[[NSAttributedString alloc] initWithString:@"\t"]];
        [text appendAttributedString:description];
        [text appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
    }
    self.textarea.attributedText = text;
}

@end
