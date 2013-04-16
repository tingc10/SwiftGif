// SGVideoFrameExtractor.m

#import "SGVideoFrameExtractor.h"
#import <MediaPlayer/MediaPlayer.h>
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import <AVFoundation/AVFoundation.h>
#import <AVFoundation/AVAsset.h>
#import "SGGifViewController.h"
#import "SGFrameEditController.h"

@implementation SGVideoFrameExtractor



-(void) extractFrames {
    
    MPMoviePlayerController *moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL: videoRef];
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:videoRef];
    CMTime duration = playerItem.duration;
    float seconds = CMTimeGetSeconds(duration);
    
    
    float frametime = [[NSUserDefaults standardUserDefaults] floatForKey:@"extractRate"];
    if (frametime < 0.01) frametime = 0.1;
    extractRateLabel.text = [[NSString stringWithFormat:@"@%.2f", frametime] stringByAppendingString:@" sec/frame"];
    
    int numFrames = (int)(seconds/frametime);
    
    //check if numFrames over max constrained frames
    int maxFrames = 60;
    if (numFrames > maxFrames) {
        numFrames = maxFrames;
        frametime = seconds / numFrames;
    }
    
    
    // start progress bar at 0
    float progPercent = 0.0;
    _progress.progress = 0.0;
    float extractProgressStep =  1.0/ numFrames;
    
    NSMutableArray *imageArray = [NSMutableArray array];
    
    float time = 0.0;
    for (int frame=0; frame<numFrames; frame++) {
        
        // get image snapshot
        UIImage *snapshot = [moviePlayer thumbnailImageAtTime:time timeOption:MPMovieTimeOptionExact];
        [imageArray addObject:snapshot];
        
        // increment time in seconds
        time += frametime;
        
        // increment progress bar
        NSLog(@"%.2f",extractProgressStep);
        
        progPercent += extractProgressStep;
        [self performSelectorOnMainThread:@selector(updateProgress:) withObject:[NSNumber numberWithFloat:progPercent] waitUntilDone:NO];

        
    }

    // dismiss view and open frame edit
    [self showResponse:imageArray];
}

-(void) updateProgress:(NSNumber*)progress{
    [_progress setProgress:[progress floatValue] animated:YES];

}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"Background.png"]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    process = [[SGProcessingView alloc] initWithView:_processing type: YES overlay:_extracting];
    
    [process animate];
    [NSThread detachNewThreadSelector:@selector(extractFrames) toTarget:self withObject:nil];
    //[self extractFrames];
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


-(void)showResponse:(NSArray*)imageArray{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    SGFrameEditController *vc = [storyboard instantiateViewControllerWithIdentifier:@"FrameEditController"];
    
    
    vc.frames = imageArray;
    
    UIViewController *presentingView = self.presentingViewController;
    [self dismissViewControllerAnimated:NO completion:^{[presentingView presentViewController:vc animated:YES completion:nil];}];
    //must close detached thread
    [NSThread exit];
    [process stop];
    
    
}



- (void)viewDidUnload {

    extractRateLabel = nil;
    [self setProcessing:nil];
    [self setExtracting:nil];
    [self setProgress:nil];
    [super viewDidUnload];
}
@end














/*
// SGVideoFrameExtractor.m

#import "SGVideoFrameExtractor.h"
#import <MediaPlayer/MediaPlayer.h>
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import <AVFoundation/AVFoundation.h>
#import <AVFoundation/AVAsset.h>
#import "SGGifViewController.h"

@implementation SGVideoFrameExtractor

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void) extractFrames {
    
    MPMoviePlayerController *moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL: videoRef];
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:videoRef];
    CMTime duration = playerItem.duration;
    float seconds = CMTimeGetSeconds(duration);

    
    float frametime = [[NSUserDefaults standardUserDefaults] floatForKey:@"extractRate"];
    if (frametime < 0.01) frametime = 0.1;
    extractRateLabel.text = [[@"Extracting at " stringByAppendingString:[NSString stringWithFormat:@"%.2f", frametime]] stringByAppendingString:@" sec/frame"];

    
    int frametimehundred = (int)(frametime*100);
    
    int numFrames = (int)(seconds/frametime);
    
    
    // start progress bar at 0
    float startProgress = 0.1,
    midProgress = 0.4;
    progress.progress = 0.1;
    float extractProgressStep =  (midProgress - startProgress) / numFrames;
    
    
    NSURL *url = [NSURL URLWithString:@"http://tranzient.info:8080/upload"];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];

    NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:@"/upload" parameters:nil constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
        
        // frame rate N, there will be N*(1/100) seconds per frame
        NSData *rateData = [NSData dataWithBytes: &frametimehundred length: sizeof(frametimehundred)];
        [formData appendPartWithFormData:rateData name:@"rate"];
        
        // send user ID
        NSString *myUserID = [[NSUserDefaults standardUserDefaults] stringForKey:@"myUserID"];
        if (myUserID != nil) {
            NSData *idData = [myUserID dataUsingEncoding:NSUTF8StringEncoding];
            [formData appendPartWithFormData:idData name:@"user_id"];
            NSLog(@"sending user_id to server %@", myUserID);
        } else NSLog(@"no user ID, not sending to server (which means we are requesting a user ID from the server)");
        
        float time = 0.0;
        for (int frame=0; frame<numFrames; frame++) {
            
            // get image snapshot
            UIImage *snapshot = [moviePlayer thumbnailImageAtTime:time timeOption:MPMovieTimeOptionExact];
            if (snapshot == nil) break;
            
            NSLog(@"frame#%d at time %f", frame, time);
            
            // turn snapshot into NSdata
            NSData *imageData = UIImageJPEGRepresentation(snapshot,0.2);
            
            // turn frame # to string and add the file to the POST frames[] array
            NSString *frameAsText = [[NSNumber numberWithInt:frame] stringValue];
            [formData appendPartWithFileData:imageData name:@"frames[]" fileName:[frameAsText stringByAppendingString:@".jpg"] mimeType:@"image/jpeg"];
            
            // increment time in seconds
            time += frametime;
            
            // incrememnt progress bar
            [progress setProgress:(startProgress + frame*extractProgressStep) animated:YES];
        }
        NSLog(@"Done appending form data");
    }];
    
    NSLog(@"Done creating mutable URL request");
    // upload to server
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        NSLog(@"Sent %lld of %lld bytes", totalBytesWritten, totalBytesExpectedToWrite);
        [progress setProgress:(midProgress + (1.0-midProgress)*(totalBytesWritten / (1.0 * totalBytesExpectedToWrite)))
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
   
    NSLog(@"Done with Converting");
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self extractFrames];
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


-(void)showResponse:(NSString*)gifurl{
    NSURL *url = [NSURL URLWithString:gifurl];

    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    SGGifViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"ViewGifController"];
    
    [vc setURL:url];
    [self presentViewController:vc animated:YES completion:nil];
    
    
}


- (void)viewDidUnload {
    
    [super viewDidUnload];
    progress = nil;
    extractRateLabel = nil;

}
@end
*/
