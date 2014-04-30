//
//  UITabBarController+Autorotate.m
//  NoNukeTaiwan
//
//  Created by Boska Lee on 4/30/14.
//  Copyright (c) 2014 NoNukeTaiwan. All rights reserved.
//

#import "UITabBarController+Autorotate.h"

@implementation UITabBarController (Autorotate)

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  UIViewController *controller = self.selectedViewController;
  if ([controller isKindOfClass:[UINavigationController class]])
    controller = [(UINavigationController *)controller visibleViewController];
  return [controller shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}

@end
