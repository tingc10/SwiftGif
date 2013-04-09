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
	// Do any additional setup after loading the view.
    NSString *myUserID = [[NSUserDefaults standardUserDefaults] stringForKey:@"myUserID"];
    if (myUserID != nil) {
        _uniqueID.text = myUserID;
    } else _uniqueID.text = @"You have yet to upload your first GIF!";
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)rateChange:(UISlider *)sender {
    
    
    _sliderLabel.text = [[NSString stringWithFormat:@"%.2f", sender.value] stringByAppendingString:@" seconds per frame"];
}


- (void)viewDidUnload {
    [self setSliderLabel:nil];
    [self setUniqueID:nil];
    [super viewDidUnload];
}
@end
