//
//  SGThirdViewController.m
//  SwiftGif
//
//  Created by Nick Ruff on 3/18/13.
//  Copyright (c) 2013 Team SwiftGif. All rights reserved.
//

#import "SGThirdViewController.h"

#include "constants.h"

@interface SGThirdViewController ()

@end

@implementation SGThirdViewController

- (id)initWithCoder:(NSCoder*)aDecoder
{
    if(self = [super initWithCoder:aDecoder])
    {
        UITabBarItem* tabBarItem =  [[UITabBarItem alloc] initWithTitle:nil image:nil tag:0];
        [tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"globe_selected.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"globe.png"]];
        self.tabBarItem = tabBarItem;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"Background.png"]];

    _webViewNew.delegate = self;
    
    NSString *fullURL = [SG_BASE_URL stringByAppendingString:@"global"];

    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [_webViewNew loadRequest:requestObj];
    [[_webViewNew scrollView] setBounces: NO];
}

-(void)webViewDidStartLoad:(UIWebView *) portal {
    [_actIndicator startAnimating];
}

-(void)webViewDidFinishLoad:(UIWebView *) portal{
    [_actIndicator stopAnimating];
}

-(void)viewWillAppear:(BOOL)animated
{
    [_webViewNew reload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setActIndicator:nil];
    [super viewDidUnload];
}
@end
