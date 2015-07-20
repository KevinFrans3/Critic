//
//  ViewController.m
//  Critic
//
//  Created by Tolga Beser on 7/19/15.
//  Copyright (c) 2015 Tolga Beser. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController {
    
    __weak IBOutlet UIButton *adventureButton;
    __weak IBOutlet UIButton *historyButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)startAdventureButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"goToOptions" sender:@"Self"];
}
- (IBAction)viewHistoryButtonPressed:(id)sender {
    NSLog(@"view history pressed");
}

@end
