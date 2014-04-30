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
#import "GeoPointCompass.h"
@interface NTDistanceViewController ()
@property (nonatomic,weak) IBOutlet UILabel *distanceLabel;
@property (nonatomic,weak) IBOutlet UILabel *durationLabel;

@end

@implementation NTDistanceViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self.view setBackgroundColor:[UIColor blackColor]];
  UIImage *arrow = [UIImage imageNamed:@"arrow"];
  UIImage *tintArrow = [arrow imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
  self.compassImageView.image = tintArrow;
  GeoPointCompass *geoPointCompass = [[GeoPointCompass alloc] init];
  [geoPointCompass setArrowImageView:self.compassImageView];
  geoPointCompass.latitudeOfTargetedPoint = NUKE4_COOR.latitude;
  geoPointCompass.longitudeOfTargetedPoint = NUKE4_COOR.longitude;


  [AKLocationManager startLocatingWithUpdateBlock:^(CLLocation *location){
    [geoPointCompass updateLocationManually:location];
    // location acquired
    CLLocation *planetLocation = [[CLLocation alloc]initWithLatitude:NUKE4_COOR.latitude longitude:NUKE4_COOR.longitude];
   CLLocationDistance distance = [location distanceFromLocation:planetLocation];
    [self updateDuration:planetLocation.coordinate :location.coordinate];
    self.distanceLabel.text = [NSString stringWithFormat:@"%.1fkm",distance/1000];
  }failedBlock:^(NSError *error){
    // something is wrong
  }headingUpdateBlock:^(CLHeading *heading) {
    [geoPointCompass updateHeading:heading];
    NSLog(@"%@",heading.description);
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
