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

@implementation SGVideoEditController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) uploadVideo {
    
    MPMoviePlayerController *moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL: videoRef];
    //UIImage *thumbnail1 = [moviePlayer thumbnailImageAtTime:0.0 timeOption:MPMovieTimeOptionNearestKeyFrame];
    //UIImage *thumbnail2 = [moviePlayer thumbnailImageAtTime:1.0 timeOption:MPMovieTimeOptionNearestKeyFrame];
    
    NSURL *url = [NSURL URLWithString:@"http://tranzient.info:8080/upload"];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];

    // image-->nsdata
    //NSData *imageData1 = UIImageJPEGRepresentation(thumbnail1,0.2);
    //NSData *imageData2 = UIImageJPEGRepresentation(thumbnail2,0.2);
    
    double frametime = 0.1;//seconds per frame
    double vidtime = (double)(moviePlayer.duration); //in seconds (get from moviePlayer)
    int numFrames = (int)(vidtime/frametime);
    
    NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:@"/upload" parameters:nil constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
        //[formData appendPartWithFileData:imageData1 name:@"frames[]" fileName:@"1.jpg" mimeType:@"image/jpeg"];
        //[formData appendPartWithFileData:imageData2 name:@"frames[]" fileName:@"2.jpg" mimeType:@"image/jpeg"];
        
        double time = 0.0;
        for (int frame=0; frame<numFrames; frame++) {
            // get image snapshot
            UIImage *snapshot = [moviePlayer thumbnailImageAtTime:time timeOption:MPMovieTimeOptionNearestKeyFrame];
            // turn snapshot into NSdata
            NSData *imageData = UIImageJPEGRepresentation(snapshot,0.2);
            // turn frame # to string and add the file to the POST frames[] array
            NSString *frameAsText = [[NSNumber numberWithInt:frame] stringValue];
            [formData appendPartWithFileData:imageData name:@"frames[]" fileName:[frameAsText stringByAppendingString:@".jpg"] mimeType:@"image/jpeg"];
            // increment time in seconds
            time += frametime;
        }
        
        
    }];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        NSLog(@"Sent %lld of %lld bytes", totalBytesWritten, totalBytesExpectedToWrite);
    }];
    [httpClient enqueueHTTPRequestOperation:operation];
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
    }
    return self;
}

-(void)setURL:(NSURL *)theVideoRef {
    videoRef = theVideoRef;
}



@end
