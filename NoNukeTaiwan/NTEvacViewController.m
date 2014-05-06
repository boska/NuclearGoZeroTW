//
//  NTSecondViewController.m
//  NoNukeTaiwan
//
//  Created by Boska Lee on 4/30/14.
//  Copyright (c) 2014 NoNukeTaiwan. All rights reserved.
//

#import "NTEvacViewController.h"

@interface NTEvacViewController ()
@property (nonatomic, weak) IBOutlet GMSMapView *mapView;
@property (nonatomic, strong) NSMutableArray *circles;
@property (nonatomic, weak) IBOutlet UISlider *slider;
@property (nonatomic, weak) IBOutlet UILabel *rangeIndicator;
@property (nonatomic, strong) GMSMarker *myMarker;
@end
@implementation NTEvacViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.circles = [NSMutableArray array];
  GMSCameraPosition *camera = [GMSCameraPosition
  cameraWithLatitude:25.0237359
           longitude:121.647358
                zoom:9];

  self.mapView.camera = camera;
  self.mapView.myLocationEnabled = YES;

  [self.mapView addObserver:self
                 forKeyPath:@"myLocation"
                    options:NSKeyValueObservingOptionNew
                    context:NULL];

  [self.circles addObject:[self circleByCoordinate:NUKE4_COOR]];
  [self.circles addObject:[self circleByCoordinate:NUKE1_COOR]];
  [self.circles addObject:[self circleByCoordinate:NUKE2_COOR]];
  [self.circles addObject:[self circleByCoordinate:NUKE3_COOR]];

  [self addMarker:NUKE4_COOR snippet:@"核四廠"];
  [self addMarker:NUKE1_COOR snippet:@"核一廠"];
  [self addMarker:NUKE2_COOR snippet:@"核二廠"];
  [self addMarker:NUKE3_COOR snippet:@"核三廠"];

  [self.view addSubview:self.slider];
}

- (void)addMarker:(CLLocationCoordinate2D)coor snippet:(NSString *)snippet {
  GMSMarker *marker = [[GMSMarker alloc] init];
  marker.position = coor;
  marker.snippet = snippet;
  marker.icon = [UIImage imageNamed:@"plant"];
  marker.groundAnchor = CGPointMake(0.5, 0.5);
  marker.map = self.mapView;
}

- (GMSCircle *)circleByCoordinate:(CLLocationCoordinate2D)coor {
  GMSCircle *circle = [[GMSCircle alloc] init];
  circle.position = coor;
  circle.radius = 30000;
  circle.fillColor = [YELLO colorWithAlphaComponent:0.3];
  circle.map = self.mapView;
  circle.strokeWidth = 0;
  return circle;
}

- (IBAction)slideDidChaged:(id)sender {
  UISlider *slide = (UISlider *)sender;
  NSLog(@"%f", slide.value);
  for (GMSCircle *circle in self.circles) {
    circle.radius = slide.value * 1000;
  }
  self.rangeIndicator.text = [NSString stringWithFormat:@"%.1fkm", slide.value];
  [self.rangeIndicator sizeToFit];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
  CLLocation *location = [change objectForKey:NSKeyValueChangeNewKey];

  if (self.myMarker == nil) {
    self.myMarker = [[GMSMarker alloc] init];
  }
  self.myMarker.position = location.coordinate;
  self.myMarker.snippet = @"目前位置";
  self.myMarker.icon = [UIImage imageNamed:@"scream"];
  self.myMarker.groundAnchor = CGPointMake(0.5, 0.5);
  self.myMarker.map = self.mapView;
}

@end
