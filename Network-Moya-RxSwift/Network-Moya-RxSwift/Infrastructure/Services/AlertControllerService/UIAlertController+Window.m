//
//  UIAlertController+Window.m
//  Network-Moya-RxSwift
//
//  Created by Ilya Gibadullin on 15.08.2019.
//  Copyright © 2020 Ilya Gibadullin. All rights reserved.
//

#import "UIAlertController+Window.h"
#import <objc/runtime.h>

// https://stackoverflow.com/questions/26554894/how-to-present-uialertcontroller-when-not-in-a-view-controller
// Если верить stack overflow, эппл говнокодит так же


@interface UIAlertController (Private)

@property (nonatomic, strong) UIWindow *alertWindow;

@end

@implementation UIAlertController (Private)

@dynamic alertWindow; // Оставил в ObjC из-за рантайма, в Swift эта часть станет нечитаемой

- (void)setAlertWindow:(UIWindow *)alertWindow {
    objc_setAssociatedObject(self, @selector(alertWindow), alertWindow, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIWindow *)alertWindow {
    return objc_getAssociatedObject(self, @selector(alertWindow));
}

@end

@implementation UIAlertController (Window)

- (void)show {
    [self showAnimated:YES];
}

- (void)showAnimated:(BOOL)animated {
    [self showForDuration:-1 animated:animated completion:nil];
}

- (void)showForDuration:(NSTimeInterval)duration
               animated:(BOOL)animated
             completion:(UIAlertControllerAutodismissCompletion)completion {

    self.alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.alertWindow.rootViewController = [[UIViewController alloc] init];
    
    id<UIApplicationDelegate> delegate = [UIApplication sharedApplication].delegate;
    // Applications that does not load with UIMainStoryboardFile might not have a window property:
    if ([delegate respondsToSelector:@selector(window)]) {
        // we inherit the main window's tintColor
        self.alertWindow.tintColor = delegate.window.tintColor;
    }
    
    // window level is above the top window (this makes the alert, if it's a sheet, show over the keyboard)
    UIWindow *topWindow = [UIApplication sharedApplication].windows.lastObject;
    self.alertWindow.windowLevel = topWindow.windowLevel + 1;
    
    [self.alertWindow makeKeyAndVisible];
    [self.alertWindow.rootViewController presentViewController:self animated:animated completion:^{
        if (duration > 0) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [self.alertWindow.rootViewController dismissViewControllerAnimated:animated completion:nil];
                if (completion != nil) {
                    completion();
                }
            });
        }
    }];
}

- (void)viewDidDisappear:(BOOL)animated { // работает пока у UIAlertController нет своего viewDidDisappear
    [super viewDidDisappear:animated];
    
    // precaution to ensure window gets destroyed
    self.alertWindow.hidden = YES;
    self.alertWindow = nil;
}

@end
