//
//  UIAlertController+Window.h
//  Network-Moya-RxSwift
//
//  Created by Ilya Gibadullin on 15.08.2019.
//  Copyright © 2020 Ilya Gibadullin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^UIAlertControllerAutodismissCompletion)(void);


@interface UIAlertController (Window)

- (void)show;
- (void)showAnimated:(BOOL)animated;
- (void)showForDuration:(NSTimeInterval)duration
               animated:(BOOL)animated
             completion:(nullable UIAlertControllerAutodismissCompletion)completion;

@end

NS_ASSUME_NONNULL_END
