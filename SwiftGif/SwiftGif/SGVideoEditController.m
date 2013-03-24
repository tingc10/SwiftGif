//
//  SGVideoEditController.m
//  SwiftGif
//
//  Created by Tingshen Chen on 3/23/13.
//  Copyright (c) 2013 Team SwiftGif. All rights reserved.
//

#import "SGVideoEditController.h"
#import <MediaPlayer/MediaPlayer.h>

@implementation SGVideoEditController

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
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"This is SGVideoEdit"
                                                    message:@"yayy"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    
    [alert show];
    UIImageView *photo = [[UIImageView alloc] init];
    
    MPMoviePlayerController *moviePlayer = [[MPMoviePlayerController alloc]
                                       initWithContentURL: videoRef];
    UIImage *thumbnail = [moviePlayer thumbnailImageAtTime:0.0 timeOption:MPMovieTimeOptionNearestKeyFrame];
    
    photo.image = thumbnail;
    /*
    MPMoviePlayerController *movie = [[[MPMoviePlayerController alloc]
                                       initWithContentURL: videoRef]];
    NSNumber *time1 = [[NSNumber alloc] initWithInt:1];
    NSNumber *time2 = [[NSNumber alloc] initWithInt:2];
    NSNumber *time3 = [[NSNumber alloc] initWithInt:3];
    NSArray *times = [NSArray arrayWithObjects:time1,time2,time3,nil];
    [movie requestThumbnailImagesAtTimes:times timeOption:MPMovieTimeOptionExact];
    */
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(id)initWithURL:(NSURL *)thevideoRef
{
    if(self = [super init]){
        videoRef = thevideoRef;
    }
    return self;
}

-(void)setURL:(NSURL *)theVideoRef {
    videoRef = theVideoRef;
}

@end
