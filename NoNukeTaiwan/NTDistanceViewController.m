//
//  NTFirstViewController.m
//  NoNukeTaiwan
//
//  Created by Boska Lee on 4/30/14.
//  Copyright (c) 2014 NoNukeTaiwan. All rights reserved.
//

#import "NTDistanceViewController.h"
#import <AKLocationManager.h>
#import <GMDirectionService.h>
@interface NTDistanceViewController ()
@property (nonatomic,weak) IBOutlet UILabel *distanceLabel;
@property (nonatomic,weak) IBOutlet UILabel *durationLabel;

@end

@implementation NTDistanceViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [AKLocationManager startLocatingWithUpdateBlock:^(CLLocation *location){
    // location acquired
    CLLocation *planetLocation = [[CLLocation alloc]initWithLatitude:NUKE4_COOR.latitude longitude:NUKE4_COOR.longitude];
   CLLocationDistance distance = [location distanceFromLocation:planetLocation];
    [self updateDuration:planetLocation.coordinate :location.coordinate];
    self.distanceLabel.text = [NSString stringWithFormat:@"%.1fkm",distance/1000];
  }failedBlock:^(NSError *error){
    // something is wrong
  }];

  
  // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}
- (void)updateDuration:(CLLocationCoordinate2D)origin :(CLLocationCoordinate2D)dest{

  NSString *originString = [NSString stringWithFormat:@"%f,%f",origin.latitude,origin.longitude];
   NSString *destString = [NSString stringWithFormat:@"%f,%f",dest.latitude,dest.longitude];
  [[GMDirectionService sharedInstance] getDirectionsFrom:originString to:destString succeeded:^(GMDirection *directionResponse) {
    if ([directionResponse statusOK]){
      self.durationLabel.text = [directionResponse durationHumanized];
    }
  } failed:^(NSError *error) {
    NSLog(@"Can't reach the server");
  }];
}
@end
