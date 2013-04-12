//
//  SGSecondViewController.m
//  SwiftGif
//
//  Created by Tingshen Chen on 3/13/13.
//  Copyright (c) 2013 Team SwiftGif. All rights reserved.
//

#import "SGSecondViewController.h"

@interface SGSecondViewController ()

@end

@implementation SGSecondViewController

- (id)initWithCoder:(NSCoder*)aDecoder
{
    if(self = [super initWithCoder:aDecoder])
    {
        UITabBarItem* tabBarItem =  [[UITabBarItem alloc] initWithTitle:nil image:nil tag:0];
        [tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"folder_selected.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"folder.png"]];
        self.tabBarItem = tabBarItem;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"Background.png"]];


    NSString *myUserID = [[NSUserDefaults standardUserDefaults] stringForKey:@"myUserID"];
    NSString *fullURL = [@"http://swiftgif.tranzient.info/users/" stringByAppendingString: myUserID];
    NSLog(@"Loading User URL: %@\n", fullURL);

    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [_profile loadRequest:requestObj];
    [[_profile scrollView] setBounces: NO];
}

-(void)viewWillAppear:(BOOL)animated
{
    [_profile reload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setProfile:nil];
    [super viewDidUnload];
}
@end
