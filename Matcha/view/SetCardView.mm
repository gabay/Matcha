// Copyright (c) 2020 Lightricks. All rights reserved.
// Created by Roi Gabay.

#import "SetCardView.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SetCardView

#pragma mark - Members

- (void)setNumber:(NSUInteger)number
{
    _number = number;
    [self setNeedsDisplay];
}

- (void)setShape:(NSUInteger)shape
{
    _shape = shape;
    [self setNeedsDisplay];
}

- (void)setFill:(NSUInteger)fill
{
    _fill = fill;
    [self setNeedsDisplay];
}

- (void)setColor:(NSUInteger)color
{
    _color = color;
    [self setNeedsDisplay];
}

#pragma mark - Drawing

#define SYMBOL_LINE_WIDTH 0.05
#define SHAPE_WIDTH 0.2
#define SHAPE_HEIGHT 0.25
#define STRIPE_DISTANCE 0.1

- (void)drawCardContent
{
    [self setColorForDrawing];
    [self drawShapes];
}

- (void)setColorForDrawing
{
    UIColor *color = (self.color == 1)? [UIColor redColor] :
                     (self.color == 2)? [UIColor greenColor] :
                     (self.color == 3)? [UIColor purpleColor] : nil;
    if (color == nil) {
        NSLog(@"ERROR: invalid color %ld", self.color);
    }
    [color setStroke];
    [color setFill];
}

- (void)drawShapes
{
    unsigned int shapeWidth = self.bounds.size.width * SHAPE_WIDTH;
    unsigned int separationWidth = shapeWidth * 0.5;
    unsigned int dx = (shapeWidth + separationWidth) / 2;
    unsigned int x = self.bounds.size.width / 2;
    unsigned int y = self.bounds.size.height / 2;
    switch (self.number) {
        case 1:
            [self drawShapeAtPoint:CGPointMake(x, y)];
            break;
        case 2:
            [self drawShapeAtPoint:CGPointMake(x - dx, y)];
            [self drawShapeAtPoint:CGPointMake(x + dx, y)];
            break;
        case 3:
            [self drawShapeAtPoint:CGPointMake(x - (2*dx), y)];
            [self drawShapeAtPoint:CGPointMake(x, y)];
            [self drawShapeAtPoint:CGPointMake(x + (2*dx), y)];
            break;
        default:
            NSLog(@"ERROR: invalid number %ld", self.number);
    }
}

- (void)drawShapeAtPoint:(CGPoint)point
{
    UIBezierPath *path = (self.shape == 1) ? [self getDiamondAtPoint:point] :
                         (self.shape == 2) ? [self getOvalAtPoint:point] :
                         (self.shape == 3) ? [self getSquiggleAtPoint:point] : nil;
    if (path == nil) {
        NSLog(@"ERROR: invalid shape %ld", self.shape);
    }
    [self setColorForDrawing];
    [self fillPath:path];
    [path stroke];
}

- (void)fillPath:(UIBezierPath *)path {
    switch (self.fill) {
        case 1:     // clear fill
            break;
        case 2:     // solid fill
            [path fill];
            break;
        case 3:     // striped fill
            [self drawStripsInsidePath:path];
            break;
        default:
            NSLog(@"ERROR: invalid fill %ld", self.fill);
            
    }
}

- (void)drawStripsInsidePath:(UIBezierPath *)path
{
    CGContextSaveGState(UIGraphicsGetCurrentContext());
    [path addClip];
    for (int y = path.bounds.origin.y; y < path.bounds.origin.y + path.bounds.size.height; y += path.bounds.size.height * STRIPE_DISTANCE) {
        UIBezierPath *line = [UIBezierPath bezierPath];
        [line moveToPoint:CGPointMake(path.bounds.origin.x, y)];
        [line addLineToPoint:CGPointMake(path.bounds.origin.x + path.bounds.size.width, y)];
        [line stroke];
    }
    CGContextRestoreGState(UIGraphicsGetCurrentContext());
}

- (UIBezierPath *)getDiamondAtPoint:(CGPoint)point {
    CGFloat dx = self.bounds.size.width * SHAPE_WIDTH / 2.0;
    CGFloat dy = self.bounds.size.height * SHAPE_HEIGHT / 2.0;
    
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:CGPointMake(point.x - dx, point.y)];
    [path addLineToPoint:CGPointMake(point.x, point.y - dy)];
    [path addLineToPoint:CGPointMake(point.x + dx, point.y)];
    [path addLineToPoint:CGPointMake(point.x, point.y + dy)];
    [path closePath];
    path.lineWidth = self.bounds.size.width * SYMBOL_LINE_WIDTH;
    return path;
}

- (UIBezierPath *)getOvalAtPoint:(CGPoint)point {
    CGFloat dx = self.bounds.size.width * SHAPE_WIDTH / 2.0;
    CGFloat dy = self.bounds.size.height * SHAPE_HEIGHT / 2.0;
    CGRect rect;
    rect.origin.x = point.x - dx;
    rect.origin.y = point.y - dy;
    rect.size.width = dx * 2;
    rect.size.height = dy * 2;
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:rect];
    path.lineWidth = self.bounds.size.width * SYMBOL_LINE_WIDTH;
    return path;
}

#pragma mark - Drawing squiggle
#define SQUIGGLE_FACTOR 0.8
 
- (UIBezierPath *)getSquiggleAtPoint:(CGPoint)point {
  CGFloat dx = self.bounds.size.width * SHAPE_WIDTH / 2.0;
  CGFloat dy = self.bounds.size.height * SHAPE_HEIGHT / 2.0;
  CGFloat dsqx = dx * SQUIGGLE_FACTOR;
  CGFloat dsqy = dy * SQUIGGLE_FACTOR;
  
  UIBezierPath *path = [[UIBezierPath alloc] init];
  [path moveToPoint:CGPointMake(point.x - dx, point.y - dy)];
  [path addQuadCurveToPoint:CGPointMake(point.x + dx, point.y - dy)
               controlPoint:CGPointMake(point.x - dsqx, point.y - dy - dsqy)];
  [path addCurveToPoint:CGPointMake(point.x + dx, point.y + dy)
          controlPoint1:CGPointMake(point.x + dx + dsqx, point.y - dy + dsqy)
          controlPoint2:CGPointMake(point.x + dx - dsqx, point.y + dy - dsqy)];
  [path addQuadCurveToPoint:CGPointMake(point.x - dx, point.y + dy)
               controlPoint:CGPointMake(point.x + dsqx, point.y + dy + dsqy)];
  [path addCurveToPoint:CGPointMake(point.x - dx, point.y - dy)
          controlPoint1:CGPointMake(point.x - dx - dsqx, point.y + dy - dsqy)
          controlPoint2:CGPointMake(point.x - dx + dsqx, point.y - dy + dsqy)];
  return path;
}

@end

NS_ASSUME_NONNULL_END
