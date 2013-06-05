//
//  SGFourthViewController.m
//  SwiftGif
//
//  Created by Tingshen Chen on 4/5/13.
//  Copyright (c) 2013 Team SwiftGif. All rights reserved.
//

#import "SGFourthViewController.h"
#define SG_BASE_URL @"http://swiftgif.com/"

@interface SGFourthViewController ()

@end

@implementation SGFourthViewController

@synthesize usernameField;

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
    
    usernameField.delegate = self;
    
    //save view for shift
    originalCenter = self.view.center;
    
    // fill user ID field
    NSString *myUsername = [[NSUserDefaults standardUserDefaults] stringForKey:@"username"];
    NSString *myUserid = [[NSUserDefaults standardUserDefaults] stringForKey:@"myUserID"];
    //check username
    
    if (myUsername != nil) {
        _username.text = myUsername;
        _registerView.hidden = YES;
        _welcomeView.hidden = NO;
        
    } else {
        _registerView.hidden = NO;
        _welcomeView.hidden = YES;
        
    }
    
    _isUnique.text = [NSString stringWithFormat:@"Choose Username Between\n5 to 15 Characters"];
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



- (IBAction)checkUnique:(id)sender {
    
    if(usernameField.text.length >= 5 && usernameField.text.length <= 15)
    {
        NSString *requestURL = [[SG_BASE_URL stringByAppendingString:@"check_username/"]  stringByAppendingString: usernameField.text];
        NSLog(@"Loading User URL: %@\n", requestURL);
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:requestURL]];
        [NSURLConnection connectionWithRequest:request delegate:self];
    }else{
        _isUnique.text = [NSString stringWithFormat:@"Choose Username Between\n5 to 15 Characters"];
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


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    //Convert to string and append received data
    NSString *result = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];

    if([result isEqual:@"yes"]){
        _isUnique.text = @"Username AVAILABLE";
    }else{
        _isUnique.text = @"Username TAKEN";
    }
}
/*
-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [responseData appendData:data];
}
*/
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
    _isUnique.text = @"Cannot check username, check your internet connection";
    return;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == usernameField) {
        self.view.center = CGPointMake(originalCenter.x, originalCenter.y - 44);
        [textField resignFirstResponder];
    }
    return NO;
}

- (IBAction)submitUsername:(id)sender {
    if(usernameField.text.length >= 5 && usernameField.text.length <= 15){
        NSString *myUserid = [[NSUserDefaults standardUserDefaults] stringForKey:@"myUserID"];
        
        NSError *requestError;
        NSHTTPURLResponse *urlResponse = nil;
        //set username
        NSString *bodyData = [NSString stringWithFormat: @"username=%@&user_id=%@", usernameField.text, [[NSUserDefaults standardUserDefaults] stringForKey:@"myUserID"]];
        NSLog(bodyData);
        NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://www.swiftgif.com/set_username"]];
        
        // Set the request's content type to application/x-www-form-urlencoded
        [postRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        
        // Designate the request a POST request and specify its body data
        [postRequest setHTTPMethod:@"POST"];
        [postRequest setHTTPBody:[NSData dataWithBytes:[bodyData UTF8String] length:[bodyData length]]];
        NSData *response2 = [NSURLConnection sendSynchronousRequest:postRequest returningResponse:&urlResponse error:&requestError];
        if(urlResponse.statusCode == 200){
            NSString *result = [[NSString alloc] initWithData:response2 encoding:NSASCIIStringEncoding];
            NSLog(result);
            if([result isEqual:@"yes"]){
                //set username
                [[NSUserDefaults standardUserDefaults] setValue:usernameField.text forKey:@"username"];
                //close keyboard and reset view
                self.view.center = CGPointMake(originalCenter.x, originalCenter.y - 44);
                [usernameField resignFirstResponder];
                
                //prepare user label and hide register view
                _username.text = usernameField.text;
                _registerView.hidden = YES;
                _welcomeView.hidden = NO;
            }else{
                _isUnique.text = @"This username is already taken!";
            }
        }else{
            _isUnique.text = @"Cannot set username, check your internet connection";
        }
    }else{
        _isUnique.text = [NSString stringWithFormat:@"Choose Username Between\n5 to 15 Characters"];
    }
    
}

- (IBAction)viewShift:(id)sender {
        self.view.center = CGPointMake(originalCenter.x, originalCenter.y -200);
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
    [self setIsUnique:nil];
    [self setUsernameField:nil];
    [super viewDidUnload];
}
@end
