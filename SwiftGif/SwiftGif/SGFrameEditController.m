//
//  SGFrameEditController.m
//  SwiftGif
//
//  Created by Tingshen Chen on 4/8/13.
//  Copyright (c) 2013 Team SwiftGif. All rights reserved.
//

#import "SGFrameEditController.h"
#import "SGUploader.h"


@interface SGFrameEditController ()

@end

@implementation SGFrameEditController


- (IBAction)pressCancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad
{
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"Background.png"]];
    [super viewDidLoad];
    CGRect workingFrame = _scrollView.frame;
	workingFrame.origin.x = 0;
    
    // set frames count label & slider/label to default x rate
    // change into viewDidAppear if it's not changing
    // after multiple go-thrus? Must test that.
    _framesCount.text = [NSString stringWithFormat: @"%d", _frames.count];
    float frametime = [[NSUserDefaults standardUserDefaults] floatForKey:@"extractRate"];
    if (frametime <= 0.0) frametime = 0.1;
    _playbackSlider.value = frametime;
    _rateLabel.text = [[NSString stringWithFormat:@"%.2f", frametime] stringByAppendingString:@"spf"];
    /////////////////
	
    _animateArray.animationImages = _frames;
    _animateArray.animationDuration = frametime*_frames.count;

    [_animateArray startAnimating];
    /*
    for(UIImage *image in _frames){
        UIImageView *imageview = [[UIImageView alloc] initWithImage:image];
		[imageview setContentMode:UIViewContentModeScaleAspectFit];
		imageview.frame = workingFrame;
		
		[_scrollView addSubview:imageview];
        
		
		workingFrame.origin.x = workingFrame.origin.x + workingFrame.size.width;

    }
    
	
	[_scrollView setPagingEnabled:YES];
	[_scrollView setContentSize:CGSizeMake(workingFrame.origin.x, workingFrame.size.height)];
     */
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidUnload {
    for (UIView *v in [_scrollView subviews]) {
        [v removeFromSuperview];
    }
    [self setScrollView:nil];
    [self setRateLabel:nil];
    [self setPlaybackSlider:nil];
    [self setFramesCount:nil];
    [self setAnimateArray:nil];
    [self setAnimateArray:nil];
    [super viewDidUnload];
}

- (IBAction)rateChanged:(UISlider *)sender {
    [_animateArray stopAnimating];
    _rateLabel.text = [[@"Play Rate: " stringByAppendingString:[NSString stringWithFormat:@"%.2f", sender.value]] stringByAppendingString:@" spf"];
    
    _animateArray.animationDuration = sender.value*_frames.count;
    [_animateArray startAnimating];
}

- (IBAction)clickConvert:(id)sender {
    // dismiss view and open SGUploader
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    SGUploader *vc = [storyboard instantiateViewControllerWithIdentifier:@"SGUploader"];
    //[self dismissViewControllerAnimated:NO completion:nil];
    
    int sendRate = (int)(_playbackSlider.value*100.0);
    [vc setData:_frames andRate:sendRate andTags:@""];
    UIViewController *presentingView = self.presentingViewController;
    [self dismissViewControllerAnimated:NO completion:^{[presentingView presentViewController:vc animated:NO completion:nil];}];
}




@end
