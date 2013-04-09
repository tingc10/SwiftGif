//
//  SGUploader.m
//  SwiftGif
//
//  Created by Nick Ruff on 4/8/13.
//  Copyright (c) 2013 Team SwiftGif. All rights reserved.
//

#import "SGUploader.h"
#import <MediaPlayer/MediaPlayer.h>
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import <AVFoundation/AVFoundation.h>
#import <AVFoundation/AVAsset.h>
#import "SGGifViewController.h"

@implementation SGUploader

- (void)viewDidUnload {
    [self setUpProgress:nil];
    [super viewDidUnload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self uploadFrames];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)setData:(NSArray*)images_in andRate:(int)playbackRateHundred_in andTags:(NSString*)tags_in {
    
    images = images_in;
    playbackRateHundred = playbackRateHundred_in;
    tags = tags_in;
}


- (void)uploadFrames{
    
    NSURL *url = [NSURL URLWithString:@"http://tranzient.info:8080/upload"];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    
    NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:@"/upload" parameters:nil constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
        
        // frame rate N, there will be N*(1/100) seconds per frame
        NSData *rateData = [NSData dataWithBytes: &playbackRateHundred length: sizeof(playbackRateHundred)];
        [formData appendPartWithFormData:rateData name:@"rate"];
        
        // send user ID
        NSString *myUserID = [[NSUserDefaults standardUserDefaults] stringForKey:@"myUserID"];
        if (myUserID != nil) {
            NSData *idData = [myUserID dataUsingEncoding:NSUTF8StringEncoding];
            [formData appendPartWithFormData:idData name:@"user_id"];
            NSLog(@"sending user_id to server %@", myUserID);
        } else NSLog(@"no user ID, not sending to server (which means we are requesting a user ID from the server)");
        
        float time = 0.0;
        for (int frame=0; frame<images.count; frame++) {
            
            // get image snapshot
            UIImage *snapshot = [images objectAtIndex:frame];
            if (snapshot == nil) continue;
            
            NSLog(@"frame#%d at time %f", frame, time);
            
            // turn snapshot into NSdata
            NSData *imageData = UIImageJPEGRepresentation(snapshot,0.2);
            
            // turn frame # to string and add the file to the POST frames[] array
            NSString *frameAsText = [[NSNumber numberWithInt:frame] stringValue];
            [formData appendPartWithFileData:imageData name:@"frames[]" fileName:[frameAsText stringByAppendingString:@".jpg"] mimeType:@"image/jpeg"];
            
            // increment time in seconds
            time += (playbackRateHundred)/100.0;
            
            // incrememnt progress bar
            //[_upProgress setProgress:(startProgress + frame*extractProgressStep) animated:YES];
        }
        NSLog(@"Done appending form data");
    }];
    
    NSLog(@"Done creating mutable URL request");
    // upload to server
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        NSLog(@"Sent %lld of %lld bytes", totalBytesWritten, totalBytesExpectedToWrite);
        [_upProgress setProgress:(totalBytesWritten / (1.0 * totalBytesExpectedToWrite))
                     animated:YES];
    }];
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        NSLog(@"Received %lld of %lld bytes", totalBytesRead, totalBytesExpectedToRead);
        if (totalBytesRead >= totalBytesExpectedToRead) NSLog(@"FINISHED GETTING RESPONSE");
    }];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"success: %@", operation.responseString);
        
        // save User ID
        NSError *e = nil;
        NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:&e];
        NSString *uid = [JSON objectForKey:@"user_id"];
        
        if (uid != nil) {
            [[NSUserDefaults standardUserDefaults] setObject:uid forKey:@"myUserID"];
            NSLog(@"set local user_id as %@", uid);
        }
        
        // now process the return URL (download the GIF)
        [self showResponse:[JSON objectForKey:@"url"]];
    }
                                     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         //alert cannot connect to internet return to 2nd view
                                         NSLog(@"error: %@",  operation.responseString);
                                     }
     ];
    
    
    [httpClient enqueueHTTPRequestOperation:operation];

}


-(void)showResponse:(NSString*)gifurl{
    NSURL *url = [NSURL URLWithString:gifurl];
    
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    SGGifViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"ViewGifController"];
    [vc setURL:url];
    [self presentViewController:vc animated:YES completion:nil];
    
    
}

@end
