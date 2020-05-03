// Copyright (c) 2020 Lightricks. All rights reserved.
// Created by Roi Gabay.

#import "CardView.h"

NS_ASSUME_NONNULL_BEGIN

@implementation CardView

static const double STANDARD_HEIGHT = 140.0;
static const double STANDARD_CORNER_RADIUS = 12;

- (CGFloat)scaleFactor { return self.bounds.size.height / STANDARD_HEIGHT; }
- (CGFloat)cornerRadius { return STANDARD_CORNER_RADIUS * [self scaleFactor]; }
- (CGFloat)cornerOffset { return [self cornerRadius] / 3.0; }

#pragma mark - Members
- (void)setFaceUp:(BOOL)faceUp
{
    _faceUp = faceUp;
    [self setNeedsDisplay];
}

#pragma mark - Gestures

- (void)tap:(UITapGestureRecognizer *)tap
{
    self.faceUp = !self.faceUp;
}

#pragma mark - Drawing

- (void)drawRect:(CGRect)rect
{
    // draw card area
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:[self cornerRadius]];
    [roundedRect addClip];
    
    [[UIColor whiteColor] setFill];
    UIRectFill(self.bounds);
    
    // draw card content
    if (self.faceUp) {
        [self drawCardContent];
    } else {
        [[UIImage imageNamed:@"cardback"] drawInRect:self.bounds];
    }
}

- (void)drawCardContent
{}

#pragma mark - Initialization

- (void)setup
{
    self.backgroundColor = nil;
    self.opaque = NO;
    self.contentMode = UIViewContentModeRedraw;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        // initialize
    }
    return self;
}


@end

NS_ASSUME_NONNULL_END
