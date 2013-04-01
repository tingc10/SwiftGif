//
//  SGVideoEditController.m
//  SwiftGif
//
//  Created by Tingshen Chen on 3/23/13.
//  Copyright (c) 2013 Team SwiftGif. All rights reserved.
//


//note: this is called SGVideoEditController
// but it's really more like "upload video controller"
// except maybe for features we will add on the storyboard, for adding
// description and/or tags onto a gif you just took before you upload it.
// and perhaps on that screen there would be options to share to social networks ~nick

#import "SGVideoEditController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import <AVFoundation/AVFoundation.h>
#import <AVFoundation/AVAsset.h>

@implementation SGVideoEditController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

/*
- (void) playerThumbnailImageRequestDidFinish:(NSNotification*)notification {
    NSLog(@"trigger");
	NSDictionary *userInfo = [notification userInfo];
	NSNumber *timecode = [userInfo objectForKey: @"MPMoviePlayerThumbnailTimeKey"];
	UIImage *image = [userInfo objectForKey: @"MPMoviePlayerThumbnailImageKey"];
    
    // see which one
    NSLog(@"at timecode %f", timecode);
    
    snapCount++;
    NSLog(@"snap %d of %d", snapCount, totalSnaps);
 
}*/


-(void) uploadVideo {
    
    MPMoviePlayerController *moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL: videoRef];
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:videoRef];
    CMTime duration = playerItem.duration;
    float seconds = CMTimeGetSeconds(duration);
    int frametimehundred = 20;//seconds per frame times 100 so 20 means .2 seconds per frame
    double frametime = 0.2; // double version for looping (frametimehundred/100)
    int numFrames = (int)(seconds/frametime);
    
    /*[[NSNotificationCenter defaultCenter]
	 addObserver:self
	 selector:@selector(playerThumbnailImageRequestDidFinish:)
	 name:MPMoviePlayerThumbnailImageRequestDidFinishNotification
	 object:nil];
    
    NSLog(@"Duration is %f", seconds);
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (float time=0.0; time < seconds; time += frametime)
        [array addObject:[NSNumber numberWithFloat:time]];
    [moviePlayer requestThumbnailImagesAtTimes:array timeOption:MPMovieTimeOptionNearestKeyFrame];
    */
    
    
    
    
    
    
    NSURL *url = [NSURL URLWithString:@"http://tranzient.info:8080/upload"];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];

    NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:@"/upload" parameters:nil constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
        
        // frame rate N, there will be N*(1/100) seconds per frame
        NSData *rateData = [NSData dataWithBytes: &frametimehundred length: sizeof(frametimehundred)];
        [formData appendPartWithFormData:rateData name:@"rate"];
        
        float time = 0.0;
        for (int frame=0; frame<numFrames; frame++) {
            // get image snapshot
            UIImage *snapshot = [moviePlayer thumbnailImageAtTime:time timeOption:MPMovieTimeOptionNearestKeyFrame];
            if (snapshot == nil) break;
            NSLog(@"frame#%d at time %f", frame, time);
            // turn snapshot into NSdata
            NSData *imageData = UIImageJPEGRepresentation(snapshot,0.2);
            // turn frame # to string and add the file to the POST frames[] array
            NSString *frameAsText = [[NSNumber numberWithInt:frame] stringValue];
            [formData appendPartWithFileData:imageData name:@"frames[]" fileName:[frameAsText stringByAppendingString:@".jpg"] mimeType:@"image/jpeg"];
            // increment time in seconds
            time += frametime;
        }
        NSLog(@"Done appending form data");
    }];
    
    NSLog(@"Done creating mutable URL request");
    // upload to server
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        NSLog(@"Sent %lld of %lld bytes", totalBytesWritten, totalBytesExpectedToWrite);
    }];
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        NSLog(@"Received %lld of %lld bytes", totalBytesRead, totalBytesExpectedToRead);
        if (totalBytesRead >= totalBytesExpectedToRead) NSLog(@"FINISHED GETTING RESPONSE");
    }];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"success: %@", operation.responseString);
            [self showResponse:operation.responseString];
        }
        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error: %@",  operation.responseString);
        }
     ];
    
    
    [httpClient enqueueHTTPRequestOperation:operation];
   
    NSLog(@"Done with Converting");
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // send frames to server
    [self uploadVideo];
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
        //snaps = [[NSArray init] alloc];
        //snapCount = 0;
    }
    return self;
}

-(void)setURL:(NSURL *)theVideoRef {
    videoRef = theVideoRef;
    //snaps = [[NSArray init] alloc];
    //snapCount = 0;
}


-(void)showResponse:(NSString*)gifurl{
    NSURL *url = [NSURL URLWithString:gifurl];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    UIWebView *webView = [[UIWebView alloc] init];
    [webView loadRequest:requestObj];
    
    [self.view addSubview:webView];
    
}



@end
