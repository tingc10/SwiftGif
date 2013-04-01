//
//  SGGifViewController.m
//  SwiftGif
//
//  Created by Tingshen Chen on 4/1/13.
//  Copyright (c) 2013 Team SwiftGif. All rights reserved.
//

#import "SGGifViewController.h"
#import "SGSecondViewController.h"

@interface SGGifViewController ()

@end

@implementation SGGifViewController

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
	// Do any additional setup after loading the view.
    
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:gifURL];
    [_gifDisplay loadRequest:requestObj];
    
    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc]
                                            initWithTarget:self
                                            action:@selector(handleSwipeUp)];

    swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    swipeUp.delegate = self;
    [_gifDisplay addGestureRecognizer:swipeUp];

    
}

- (void)handleSwipeUp{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    SGSecondViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"SGSecondViewController"];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setURL:(NSURL *)theGifref
{
    gifURL = theGifref;
}

@end
