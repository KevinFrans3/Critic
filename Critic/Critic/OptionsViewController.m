//
//  OptionsViewController.m
//  Critic
//
//  Created by Tolga Beser on 7/19/15.
//  Copyright (c) 2015 Tolga Beser. All rights reserved.
//

#import "OptionsViewController.h"

@interface OptionsViewController ()

@end

@implementation OptionsViewController {
    
    __weak IBOutlet UIStepper *numberSwitch;
    __weak IBOutlet UILabel *numberCountLabel;
    int originalValue;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    numberSwitch.value = 1;
    originalValue = 0;
    numberCountLabel.text = @"5 Miles";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)valueChanged:(UIStepper *)sender {
    double value = [sender value];
    if (value < 0) {
        numberCountLabel.text = @"5 Miles";
    }
    if (value > originalValue) {
        if (originalValue == 0) {
            originalValue = value;
            numberCountLabel.text = [NSString stringWithFormat:@"%i Miles", (originalValue * 5)];
        }
        else {
        originalValue = value;
        numberCountLabel.text = [NSString stringWithFormat:@"%i Miles", (originalValue * 5)];
        }
    }
    if (value < originalValue) {
        originalValue = value;
        numberCountLabel.text = [NSString stringWithFormat:@"%i Miles", (originalValue * 5)];
    }
  
}

@end
