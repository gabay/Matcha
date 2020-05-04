//
//  HistoryViewController.h
//  Matcha
//
//  Created by Roi Gabay on 26/04/2020.
//  Copyright © 2020 Roi Gabay. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HistoryViewController : UIViewController

@property (strong, nonatomic) NSArray *moves; // of [NSNumber, NSAttributedString]

@end

NS_ASSUME_NONNULL_END
