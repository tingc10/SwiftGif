//
//  SGFrameEditController.m
//  SwiftGif
//
//  Created by Tingshen Chen on 4/8/13.
//  Copyright (c) 2013 Team SwiftGif. All rights reserved.
//

#import "SGFrameEditController.h"
#import "SGUploader.h"
#import "SGdeleteButton.h"



@interface SGFrameEditController ()

@end

@implementation SGFrameEditController
@synthesize scrollView;
@synthesize frames;


- (IBAction)pressCancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad
{
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"Background.png"]];
    [super viewDidLoad];
    CGRect workingFrame = scrollView.frame;
	workingFrame.origin.x = 0;

    // set frames count label & slider/label to default x rate
    // change into viewDidAppear if it's not changing
    // after multiple go-thrus? Must test that.
    _framesCount.text = [NSString stringWithFormat: @"%d", frames.count];
    float frametime = [[NSUserDefaults standardUserDefaults] floatForKey:@"extractRate"];
    if (frametime <= 0.0) frametime = 0.1;
    _stepper.value = _playbackSlider.value = frametime;
    _rateLabel.text = [[NSString stringWithFormat:@"%.2f", frametime] stringByAppendingString:@"spf"];
    /////////////////
	


    
    _animateArray.animationImages = frames;
    _animateArray.animationDuration = frametime*frames.count;

    [_animateArray startAnimating];
    

    NSInteger count = 0;
    for(UIImage *image in frames){
        UIImageView *imageview = [[UIImageView alloc] initWithImage:image];
        //allocs for deletebuttons to touch
        imageview.userInteractionEnabled = YES;
        imageview.tag = count;
        SGdeleteButton *newDelete = [[SGdeleteButton alloc] initWithFrame:CGRectMake(scrollView.frame.size.width-46, 0, 44, 44)];
        [newDelete addTarget:self action:@selector(deleteImage:) forControlEvents:UIControlEventTouchUpInside];
        
        newDelete.index = count;
		[imageview setContentMode:UIViewContentModeScaleAspectFit];
		imageview.frame = workingFrame;
        [imageview addSubview:newDelete];
		

        //add image to scroller
        
		[scrollView addSubview:imageview];
		workingFrame.origin.x = workingFrame.origin.x + workingFrame.size.width;
        
        count++;

    }
    
	_animateArray.hidden = NO;
    scrollView.hidden = YES;
    
	[scrollView setPagingEnabled:YES];
	[scrollView setContentSize:CGSizeMake(workingFrame.origin.x, workingFrame.size.height)];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)deleteImage:(id)sender{
    SGdeleteButton *delete = (SGdeleteButton*) sender;

    UIView* image = (UIView*)[scrollView viewWithTag:delete.index];
    
    [frames removeObjectAtIndex:delete.index];
    
    //save current frame location and size
    CGRect frame = image.frame;
    CGFloat frameX = frame.origin.x;
    CGFloat frameY = frame.origin.y;
    CGFloat frameW = frame.size.width;
    //save deleted frame's size to delete from contentsize
    CGFloat deleteX = frameW;
    CGFloat frameH = frame.size.height;
    CGRect nextframe;
    [image removeFromSuperview];
    
    //reshift all frames
    //starts at next tag of subview
    for(int i = delete.index+1; i < frames.count+1; i++){
        //get next image
        image = (UIImageView*)[scrollView viewWithTag:i];
        //get deleteButton for subview
        SGdeleteButton *deletebutton = [image subviews][0];
        
        //save nextframe position
        nextframe = image.frame;
        //reset current frame
        image.frame = CGRectMake(frameX, frameY, frameW, frameH);
        //update delete button index
        deletebutton.index--;
        //update tag to match frame index
        image.tag--;
        
        frame = nextframe;
        frameX = frame.origin.x;
        frameY = frame.origin.y;
        frameW = frame.size.width;
        frameH = frame.size.height;
    }
    
    //resize contentSize of scrollview
    [scrollView setContentSize:CGSizeMake(scrollView.contentSize.width-deleteX, scrollView.contentSize.height)];
    //decrement frame count
    _framesCount.text = [NSString stringWithFormat: @"%d", frames.count];
    _animateArray.animationImages = frames;
    _animateArray.animationDuration = _stepper.value*frames.count;
    
}

- (void)viewDidUnload {
    for (UIView *v in [scrollView subviews]) {
        [v removeFromSuperview];
    }
    [self setScrollView:nil];
    [self setRateLabel:nil];
    [self setPlaybackSlider:nil];
    [self setFramesCount:nil];
    [self setAnimateArray:nil];
    [self setAnimateArray:nil];
    [self setStepper:nil];
    [super viewDidUnload];
}
- (IBAction)stepperChange:(UIStepper*)sender {
    
    [_animateArray stopAnimating];
    
    _playbackSlider.value = sender.value;
    _rateLabel.text = [[NSString stringWithFormat:@"%.2f", sender.value] stringByAppendingString:@"spf"];
    
    _animateArray.animationDuration = sender.value*frames.count;
    [_animateArray startAnimating];
}

- (IBAction)rateChanged:(UISlider *)sender {
    [_animateArray stopAnimating];
    _stepper.value = sender.value;
    
    _rateLabel.text = [[NSString stringWithFormat:@"%.2f", sender.value] stringByAppendingString:@"spf"];
    
    _animateArray.animationDuration = sender.value*frames.count;
    [_animateArray startAnimating];
}
- (IBAction)toggle:(id)sender {
    _animateArray.hidden = !_animateArray.hidden;
    scrollView.hidden = !scrollView.hidden;
    if(_animateArray.hidden){
        [_animateArray stopAnimating];
    }else{
        [_animateArray startAnimating];
    }
}

- (IBAction)clickConvert:(id)sender {
    // dismiss view and open SGUploader
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    SGUploader *vc = [storyboard instantiateViewControllerWithIdentifier:@"SGUploader"];
    //[self dismissViewControllerAnimated:NO completion:nil];
    
    int sendRate = (int)(_playbackSlider.value*100.0);
    [vc setData:frames andRate:sendRate andTags:@""];
    UIViewController *presentingView = self.presentingViewController;
    [self dismissViewControllerAnimated:NO completion:^{[presentingView presentViewController:vc animated:NO completion:nil];}];
}



@end
