//
//  SGFourthViewController.h
//  SwiftGif
//
//  Created by Tingshen Chen on 4/5/13.
//  Copyright (c) 2013 Team SwiftGif. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SGFourthViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *sliderLabel;

@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UIStepper *stepper;
@property (weak, nonatomic) IBOutlet UIView *registerView;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *framewarning;
@property (weak, nonatomic) IBOutlet UIButton *thirtybutton;
@property (weak, nonatomic) IBOutlet UIButton *hundredbutton;

@property (weak, nonatomic) IBOutlet UIView *welcomeView;
@end
