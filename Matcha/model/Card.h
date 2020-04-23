//
//  Card.h
//  Match
//
//  Created by Roi Gabay on 20/04/2020.
//  Copyright © 2020 Roi Gabay. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Card : NSObject

@property (strong, nonatomic) NSString *contents;
@property (nonatomic) BOOL matched;
@property (nonatomic) BOOL chosen;

- (int)match:(NSArray *)otherCards;

@end

NS_ASSUME_NONNULL_END

