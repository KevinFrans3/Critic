//
//  AdventureViewController.m
//  Critic
//
//  Created by Tolga Beser on 7/19/15.
//  Copyright (c) 2015 Tolga Beser. All rights reserved.
//

#import "AdventureViewController.h"
#import "OAuthConsumer.h"
#import "AppCommunicate.h"
#import <BFPaperButton.h>
@import CoreLocation;

@interface AdventureViewController () <CLLocationManagerDelegate>
@property (nonatomic, strong)AppCommunicate *communicate;
@property (strong, nonatomic) CLLocationManager *locationManager;
@end

@implementation AdventureViewController {
    __weak IBOutlet UILabel *titleLabel;
    __weak IBOutlet UIImageView *placeImage;
    __weak IBOutlet UILabel *quoteLabel;
    __weak IBOutlet UILabel *phoneNumberLabel;
    __weak IBOutlet UILabel *addressLabel;
    __weak IBOutlet UIImageView *starsImage;
    NSString *longitude;
    NSString *latitude;
    NSDictionary *result;
    NSNumber *longi;
    NSNumber *lati;
    
}
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
-(void)viewDidLoad {
    [super viewDidLoad];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    NSLog(@"hi");
    _communicate = [[AppCommunicate alloc] init];
    CGRect frame = CGRectMake(10, 400, 100, 100);
    BFPaperButton *noButton = [[BFPaperButton alloc] initWithFrame:CGRectMake(10, 480, 70, 70) raised:YES];
    [noButton setTitle:@"Nah!" forState:UIControlStateNormal];
    [noButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [noButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [noButton addTarget:self action:@selector(noButtonWasPressed) forControlEvents:UIControlEventTouchUpInside];
    noButton.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:1];
    noButton.tapCircleColor = [UIColor colorWithRed:1 green:0 blue:1 alpha:0.6];  // Setting this color overrides "Smart Color".
    noButton.cornerRadius = noButton.frame.size.width / 2;
    noButton.rippleFromTapLocation = NO;
    noButton.rippleBeyondBounds = YES;
    noButton.tapCircleDiameter = MAX(noButton.frame.size.width, noButton.frame.size.height) * 1.3;
    [self.view addSubview:noButton];
    BFPaperButton *yesButton = [[BFPaperButton alloc] initWithFrame:CGRectMake(230, 480, 70, 70) raised:YES];
    [yesButton setTitle:@"YUMMY" forState:UIControlStateNormal];
    [yesButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [yesButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [yesButton addTarget:self action:@selector(yesButtonWasPressed) forControlEvents:UIControlEventTouchUpInside];
    yesButton.backgroundColor = [UIColor colorWithRed:0 green:1 blue:0 alpha:1];
    yesButton.tapCircleColor = [UIColor colorWithRed:1 green:0 blue:1 alpha:0.6];  // Setting this color overrides "Smart Color".
    yesButton.cornerRadius = yesButton.frame.size.width / 2;
    yesButton.rippleFromTapLocation = NO;
    yesButton.rippleBeyondBounds = YES;
    yesButton.tapCircleDiameter = MAX(yesButton.frame.size.width, yesButton.frame.size.height) * 1.3;
    [self.view addSubview:yesButton];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)loadUpTheAdventure {
    
    if (result == NULL) {
    NSString *theUrl = [NSString stringWithFormat:@"http://api.yelp.com/v2/search/?term=restaurants&ll=%@,%@", latitude, longitude];
    result = [[NSDictionary alloc] init];
    result = [_communicate getFoodPlaces:theUrl];
     }
    NSLog(@"manual");
    if ([result objectForKeyedSubscript:@"businesses"] != NULL) {
        NSArray *places = [result objectForKeyedSubscript:@"businesses"];
        int numberOfPlaces = (places.count - 1);
        NSDictionary *thePlace = places[arc4random_uniform(numberOfPlaces)];
        if ([thePlace objectForKeyedSubscript:@"image_url"] != NULL) {
            NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:[thePlace objectForKeyedSubscript:@"image_url"]]];
            placeImage.image = [UIImage imageWithData: imageData];
        }
        if ([thePlace objectForKeyedSubscript:@"name"] != NULL) {
            titleLabel.text = [thePlace objectForKeyedSubscript:@"name"];
        }
        if ([thePlace objectForKeyedSubscript:@"display_phone"] !=NULL) {
            phoneNumberLabel.text = [thePlace objectForKeyedSubscript:@"display_phone"];
        }
        if ([thePlace objectForKeyedSubscript:@"snippet_text"] !=NULL) {
            quoteLabel.text = [NSString stringWithFormat:@"\"%@\"",[thePlace objectForKeyedSubscript:@"snippet_text"]];
        }
        if ([thePlace objectForKeyedSubscript:@"location"] != NULL) {
            NSDictionary *locationDic = [thePlace objectForKeyedSubscript:@"location"];
            NSArray *text = [locationDic objectForKeyedSubscript:@"address"];
            addressLabel.text = text[0];;
        }
        if ([thePlace objectForKeyedSubscript:@"rating_img_url"] != NULL) {
            NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:[thePlace objectForKeyedSubscript:@"rating_img_url"]]];
            starsImage.image = [UIImage imageWithData: imageData];
        }
        if ([thePlace objectForKey:@"location"] !=NULL) {
            NSDictionary *locationInfo = [thePlace objectForKeyedSubscript:@"location"];
            NSDictionary *cordDic = [locationInfo objectForKeyedSubscript:@"coordinate"];
            longi = [cordDic objectForKeyedSubscript:@"longitude"];
            lati = [cordDic objectForKeyedSubscript:@"latitude"];
            
        }
        
    }
    NSLog(@"manual breakpoint");
}
-(void)noButtonWasPressed {
    [self loadUpTheAdventure];
}
-(void)yesButtonWasPressed {
    NSLog(@"the yes button was pressed");
    [[NSUserDefaults standardUserDefaults] setObject:longi forKey:@"longitude"];
    [[NSUserDefaults standardUserDefaults] setObject:lati forKey:@"latitude"];
    [self performSegueWithIdentifier:@"goToCheckIn" sender:@"Self"];
}
#pragma mark - Location Manager delegates

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {

    CLLocation * currentLocation = [locations objectAtIndex:0];
    
    float flatitude =currentLocation.coordinate.latitude;
    
    float flongitude =currentLocation.coordinate.longitude;
    
    
    if (latitude != NULL) {
        
    }
    else {
    latitude = [[NSString alloc]initWithFormat:@"%@",[[NSNumber numberWithFloat:flatitude] stringValue]];
    
    longitude = [[NSString alloc]initWithFormat:@"%@",[[NSNumber numberWithFloat:flongitude] stringValue]];
    [self loadUpTheAdventure];
    }
    
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"Location manager error: %@", error.localizedDescription);
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    [self.locationManager startUpdatingLocation];
}



@end
