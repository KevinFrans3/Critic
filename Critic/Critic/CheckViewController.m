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


@interface CheckViewController : UIViewController <UIApplicationDelegate,CLLocationManagerDelegate,MKMapViewDelegate,UITextFieldDelegate, CLLocationManagerDelegate> {
    CLLocationManager *locationManager;
    IBOutlet MKMapView *mapView;
    NSNumber *destinationLongitude;
    NSNumber *destinationLatitude;
    NSString *longitude;
    NSString *latitude;
}
   

@property (nonatomic,retain) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;
@end

@implementation CheckViewController
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

- (void)viewDidLoad {
    [super viewDidLoad];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    
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
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:destinationCoords addressDictionary:nil];
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
    [request setSource:[MKMapItem mapItemForCurrentLocation]];
    [request setDestination:mapItem];
    [request setTransportType:MKDirectionsTransportTypeAny];
    [request setRequestsAlternateRoutes:YES];
    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        if (!error) {
            for (MKRoute *route in [response routes]) {
                [self.mapView addOverlay:[route polyline] level:MKOverlayLevelAboveRoads]; // Draws the
            }
        }
    }];
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
        [renderer setStrokeColor:[UIColor blueColor]];
        [renderer setLineWidth:5.0];
        return renderer;
    }
    return nil;
}
- (IBAction)checkInButtonPressed:(id)sender {

    CLLocation *destinationLocation = [[CLLocation alloc] initWithLatitude:[destinationLatitude doubleValue] longitude:[destinationLongitude doubleValue] ];
    CLLocation *currentLocation = [[CLLocation alloc] initWithLatitude:[latitude doubleValue] longitude:[longitude doubleValue]];
    CLLocationDistance distance = [currentLocation distanceFromLocation:destinationLocation];
    NSLog(@"Calculated Miles %@", [NSString stringWithFormat:@"%.1fmi",(distance/1609.344)]);
    double distanceInMiles = distance/1609.344;
    if (distanceInMiles < 0.3) {
        NSLog(@"they are there give them da points");
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    CLLocation * currentLocation = [locations objectAtIndex:0];
    
    float flatitude =currentLocation.coordinate.latitude;
    
    float flongitude =currentLocation.coordinate.longitude;
    
    
    if (latitude != NULL) {
        
    }
    else {
        latitude = [[NSString alloc]initWithFormat:@"%@",[[NSNumber numberWithFloat:flatitude] stringValue]];
        
        longitude = [[NSString alloc]initWithFormat:@"%@",[[NSNumber numberWithFloat:flongitude] stringValue]];
    }
    
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"Location manager error: %@", error.localizedDescription);
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    [self.locationManager startUpdatingLocation];
}

@end
