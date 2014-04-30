//
//  NTProtestViewController.m
//  NoNukeTaiwan
//
//  Created by Boska Lee on 4/30/14.
//  Copyright (c) 2014 NoNukeTaiwan. All rights reserved.
//

#import "NTProtestViewController.h"
#define IS_IPHONE (!IS_IPAD)
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPhone)
@interface NTProtestViewController ()
@property (nonatomic, strong) MarqueeLabel *marquee;
@property (nonatomic, strong)IBOutlet UITextField *sloganField;
@property (nonatomic, strong)IBOutlet UILabel *helpLabel;

@end

@implementation NTProtestViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor blackColor];
  self.helpLabel.textColor = [UIColor yellowColor];
  self.sloganField.textColor = [UIColor yellowColor];
  self.sloganField.layer.borderWidth = 1;
  self.sloganField.layer.borderColor = [UIColor yellowColor].CGColor;
  // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [MarqueeLabel controllerViewWillAppear:self];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [self orientationRefresh];

  // Optionally could use viewDidAppear bulk method

  // However, comment out the controllerViewWillAppear: method above, and uncomment the below method
  // to see the text jump when the modal view is finally fully dismissed. This is because viewDidAppear:
  // is not called until the view has fully appeared (animations complete, etc) so the text is not reset
  // to the home position until that point, and then the automatic scrolling begins again.

  [MarqueeLabel controllerViewDidAppear:self];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
  [self orientationRefresh];
}

- (void)orientationRefresh {
  [self.sloganField resignFirstResponder];
  if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
    self.sloganField.hidden = YES;
    self.helpLabel.hidden = YES;

    if (self.marquee == nil) {
      self.marquee = [[MarqueeLabel alloc] initWithFrame:self.view.frame rate:700 andFadeLength:10.0f];
      self.marquee.textColor = [UIColor yellowColor];
    }
    self.marquee.text = self.sloganField.text;
    self.marquee.numberOfLines = 1;
    self.marquee.enabled = YES;

    if (IS_IPHONE) {
      self.marquee.font = [UIFont fontWithName:@"MStiffHeiHK" size:300];
      self.marquee.rate = 500;
    }
    if (IS_IPAD) {
  self.marquee.font = [UIFont fontWithName:@"MStiffHeiHK" size:300];
      self.marquee.rate = 700;
    }
    self.marquee.marqueeType = MLContinuous;
    self.marquee.x = 0;
    self.marquee.y = 0;
    [self.view addSubview:self.marquee];

    self.marquee.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
  }
  if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
    self.sloganField.hidden = NO;
    self.helpLabel.hidden = NO;
    self.marquee.hidden = YES;
    self.tabBarController.tabBar.hidden = NO;
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
  }
}

/*
 * #pragma mark - Navigation
 *
 * // In a storyboard-based application, you will often want to do a little preparation before navigation
 * - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 * {
 *  // Get the new view controller using [segue destinationViewController].
 *  // Pass the selected object to the new view controller.
 * }
 */

@end
