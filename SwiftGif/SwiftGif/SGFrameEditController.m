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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect workingFrame = _scrollView.frame;
	workingFrame.origin.x = 0;
    
    
	
    for(UIImage *image in _frames){
        UIImageView *imageview = [[UIImageView alloc] initWithImage:image];
		[imageview setContentMode:UIViewContentModeScaleAspectFit];
		imageview.frame = workingFrame;
		
		[_scrollView addSubview:imageview];
        
		
		workingFrame.origin.x = workingFrame.origin.x + workingFrame.size.width;

    }
    
    
    //self.frames = images;
	
	[_scrollView setPagingEnabled:YES];
	[_scrollView setContentSize:CGSizeMake(workingFrame.origin.x, workingFrame.size.height)];
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
    [super viewDidUnload];
}

- (IBAction)rateChanged:(UISlider *)sender {
    _rateLabel.text = [[@"Play Rate: " stringByAppendingString:[NSString stringWithFormat:@"%.2f", sender.value]] stringByAppendingString:@" spf"];
}

- (IBAction)clickConvert:(id)sender {
    // dismiss view and open SGUploader
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    SGUploader *vc = [storyboard instantiateViewControllerWithIdentifier:@"SGUploader"];
    //[self dismissViewControllerAnimated:NO completion:nil];
    
    int sendRate = (int)(_playbackSlider.value*100.0);
    [vc setData:_frames andRate:sendRate andTags:@""];
    [self presentViewController:vc animated:YES completion:nil];
}




@end
