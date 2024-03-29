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
