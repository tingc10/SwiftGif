//
//  SGFourthViewController.m
//  SwiftGif
//
//  Created by Tingshen Chen on 4/5/13.
//  Copyright (c) 2013 Team SwiftGif. All rights reserved.
//

#import "SGFourthViewController.h"

@interface SGFourthViewController ()

@end

@implementation SGFourthViewController

- (id)initWithCoder:(NSCoder*)aDecoder
{
    if(self = [super initWithCoder:aDecoder])
    {
        UITabBarItem* tabBarItem =  [[UITabBarItem alloc] initWithTitle:nil image:nil tag:0];
        [tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"settings_selected.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"settings.png"]];
        self.tabBarItem = tabBarItem;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"Background.png"]];
	// set slider to correct value
    float frametime = [[NSUserDefaults standardUserDefaults] floatForKey:@"extractRate"];
    if (frametime < 0.01) frametime = 0.1;
    
    //set current slider and stepper values
    _stepper.value = _slider.value = frametime;
    _sliderLabel.text = [NSString stringWithFormat:@"%.2f", frametime];
    
    // fill user ID field
    NSString *myUserID = [[NSUserDefaults standardUserDefaults] stringForKey:@"myUserID"];
    //check username
    if (myUserID != nil) {
        _registerView.hidden = YES;
        _welcomeView.hidden = NO;
        
    } else {
        _registerView.hidden = NO;
        _welcomeView.hidden = YES;
        
    }
    
    //initialize maxframes selection
    BOOL maxframes = [[NSUserDefaults standardUserDefaults] boolForKey:@"maxframes"];
    if(!maxframes){
        //30 frames selected by default
        _thirtybutton.selected = YES;
        _hundredbutton.selected = NO;
        _framewarning.hidden = YES;
    }else{
        //100 frames selected
        _thirtybutton.selected = NO;
        _hundredbutton.selected = YES;
        _framewarning.hidden = NO;
    }
    
}
- (IBAction)selectThirty:(id)sender {
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"maxframes"]){
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"maxframes"];
        _thirtybutton.selected = YES;
        _hundredbutton.selected = NO;
        _framewarning.hidden = YES;
    }
}
- (IBAction)selectHundred:(id)sender {
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"maxframes"]){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"maxframes"];
        _thirtybutton.selected = NO;
        _hundredbutton.selected = YES;
        _framewarning.hidden = NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)rateChange:(UISlider *)sender {
    
    _stepper.value = sender.value;
    // set the slider tracker label
    _sliderLabel.text = [NSString stringWithFormat:@"%.2f", sender.value];
    
    // and set the internal data for framerate
    [[NSUserDefaults standardUserDefaults] setFloat:sender.value forKey:@"extractRate"];
    
}

- (IBAction)finesetting:(UIStepper*)sender{
    //set slider value
    _slider.value = sender.value;
    // set the slider tracker label
    _sliderLabel.text = [NSString stringWithFormat:@"%.2f", sender.value];
    
    // and set the internal data for framerate
    [[NSUserDefaults standardUserDefaults] setFloat:sender.value forKey:@"extractRate"];
}


- (void)viewDidUnload {
    [self setSliderLabel:nil];

    [self setSlider:nil];
 
    [self setStepper:nil];
    [self setRegisterView:nil];
    [self setWelcomeView:nil];
    [self setUsername:nil];
    [self setFramewarning:nil];
    [self setThirtybutton:nil];
    [self setHundredbutton:nil];
    [super viewDidUnload];
}
@end
