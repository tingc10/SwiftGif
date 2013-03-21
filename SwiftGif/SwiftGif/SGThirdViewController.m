//
//  SGThirdViewController.m
//  SwiftGif
//
//  Created by Nick Ruff on 3/18/13.
//  Copyright (c) 2013 Team SwiftGif. All rights reserved.
//

#import "SGThirdViewController.h"

@interface SGThirdViewController ()

@end

@implementation SGThirdViewController

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
    
    NSString *fullURL = @"http://swiftgif.tranzient.info";
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [_webViewNew loadRequest:requestObj];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
