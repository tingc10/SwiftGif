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


-(void) uploadImage
{
    
    MPMoviePlayerController *moviePlayer = [[MPMoviePlayerController alloc]
                                            initWithContentURL: videoRef];
    
    
    
        NSString * filenames = [NSString stringWithFormat:@"frames[]"];
        NSLog(@"%@", filenames);
        
        NSString *urlString = @"http://swiftgif.tranzient.info:8080/upload";
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init] ;
        [request setURL:[NSURL URLWithString:urlString]];
        [request setHTTPMethod:@"POST"];
        
        NSString *boundary = @"---------------------------14737809831466499882746641449";
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
        [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
        
        NSMutableData *body = [NSMutableData data];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"filenames\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[filenames dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    ////////////////////////////////////
    UIImage *thumbnail = [moviePlayer thumbnailImageAtTime:0.1 timeOption:MPMovieTimeOptionNearestKeyFrame];
    
    NSData *imageData = UIImageJPEGRepresentation(thumbnail,0.2);     //change Image to NSData
    
    if (imageData != nil)
        
    {
        /////////////////
        [body appendData:[@"Content-Disposition: form-data; name=\"frames[]\"; filename=\"1.jpg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[NSData dataWithData:imageData]];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        ///////////////////////
    }
    
    /////////////////////////////////////
        
        [request setHTTPBody:body];
        NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        NSLog(@"Response : %@",returnString);
        
        if([returnString isEqualToString:@"Success ! The file has been uploaded"])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"GIF Uploaded Successfully" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            
            [alert show];
        }
        NSLog(@"Finish");

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // send frames to server
    //MPMoviePlayerController *moviePlayer = [[MPMoviePlayerController alloc]
     //                                       initWithContentURL: videoRef];
    //UIImage *thumbnail = [moviePlayer thumbnailImageAtTime:0.0 timeOption:MPMovieTimeOptionNearestKeyFrame];
    [self uploadImage];
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    /*
     // for debugging:
    MPMoviePlayerController *moviePlayer = [[MPMoviePlayerController alloc]
                                            initWithContentURL: videoRef];
    UIImage *thumbnail = [moviePlayer thumbnailImageAtTime:0.1 timeOption:MPMovieTimeOptionNearestKeyFrame];
    
    UIImageView *photo = [[UIImageView alloc] initWithImage:thumbnail];
    [self.view addSubview:photo];
     */
    
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
