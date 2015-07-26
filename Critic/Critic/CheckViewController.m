//
//  CheckViewController.m
//  Critic
//
//  Created by Tolga Beser on 7/25/15.
//  Copyright (c) 2015 Tolga Beser. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>


@interface CheckViewController : UIViewController <UIApplicationDelegate,CLLocationManagerDelegate,MKMapViewDelegate,UITextFieldDelegate> {
    CLLocationManager *locationManager;
    IBOutlet MKMapView *mapView;
    NSNumber *destinationLongitude;
    NSNumber *destinationLatitude;
}


@property (nonatomic,retain) IBOutlet MKMapView *mapView;

@end


@implementation CheckViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.mapView setShowsUserLocation:YES];
    self.mapView.delegate = self;
    destinationLongitude = [[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"];
    destinationLatitude = [[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"];
    [self setUpLocation];
    // Do any additional setup after loading the view.
    /*
    CLLocationCoordinate2D endingCoord = CLLocationCoordinate2DMake(40.446947, -102.047607);
    MKPlacemark *endLocation = [[MKPlacemark alloc] initWithCoordinate:endingCoord addressDictionary:nil];
    MKMapItem *endingItem = [[MKMapItem alloc] initWithPlacemark:endLocation];
    
    NSMutableDictionary *launchOptions = [[NSMutableDictionary alloc] init];
    [launchOptions setObject:MKLaunchOptionsDirectionsModeDriving forKey:MKLaunchOptionsDirectionsModeKey];
    
    [endingItem openInMapsWithLaunchOptions:launchOptions];
     */

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)mapView:(MKMapView *)mv didAddAnnotationViews:(NSArray *)views

{
    MKAnnotationView *annotationView = [views objectAtIndex:0];
    id<MKAnnotation> mp = [annotationView annotation];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance([mp coordinate] ,250,250);
    [mv setRegion:region animated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)setUpLocation {
    MKDirectionsRequest *directionsRequest = [MKDirectionsRequest new];
    MKMapItem *source = [MKMapItem mapItemForCurrentLocation];
    CLLocationCoordinate2D destinationCoords = CLLocationCoordinate2DMake([destinationLatitude doubleValue], [destinationLongitude doubleValue]);
    MKPointAnnotation*    annotation = [[MKPointAnnotation alloc] init];
    annotation.coordinate = destinationCoords;
    [self.mapView addAnnotation:annotation];
}

@end
