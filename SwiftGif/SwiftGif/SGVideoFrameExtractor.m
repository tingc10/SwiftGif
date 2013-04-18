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

-(void) trimVideo{
    int startMilliseconds = ([start doubleValue] * 1000);
    int endMilliseconds = ([end doubleValue] * 1000);
    
    //defines the documents directory of app
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    //creates a output directory in the documents directory
    outputURL = [documentsDirectory stringByAppendingPathComponent:@"output"] ;
    //creates output directory if nonexistent
    [manager createDirectoryAtPath:outputURL withIntermediateDirectories:YES attributes:nil error:nil];
    
    outputURL = [outputURL stringByAppendingPathComponent:@"output.mp4"];
    // Remove Existing File
    [manager removeItemAtPath:outputURL error:nil];

    //[self loadAssetFromFile:videoURL];
    
    //[self.recorder dismissModalViewControllerAnimated:YES];
    
    AVURLAsset *videoAsset = [AVURLAsset URLAssetWithURL:videoRef options:nil];
    
    
    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:videoAsset presetName:AVAssetExportPresetHighestQuality];
    exportSession.outputURL = [NSURL fileURLWithPath:outputURL];
    exportSession.outputFileType = AVFileTypeQuickTimeMovie;
    CMTimeRange timeRange = CMTimeRangeMake(CMTimeMake(startMilliseconds, 1000), CMTimeMake(endMilliseconds - startMilliseconds, 1000));
    exportSession.timeRange = timeRange;

    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        switch (exportSession.status) {
            case AVAssetExportSessionStatusCompleted:
            {
                //reset videoRef URL
                videoRef = exportSession.outputURL;
                [NSThread detachNewThreadSelector:@selector(extractFrames) toTarget:self withObject:nil];
                break;
            }
            case AVAssetExportSessionStatusFailed:
                //
                NSLog(@"Failed:%@",exportSession.error);
                break;
            case AVAssetExportSessionStatusCancelled:
                //
                NSLog(@"Canceled:%@",exportSession.error);
                break;
            default:
                break;
        }
    }];
    
    
    
    //NSData *videoData = [NSData dataWithContentsOfURL:videoURL];
    //NSString *videoStoragePath;//Set your video storage path to this variable
    //[videoData writeToFile:videoStoragePath atomically:YES];
    //You can store the path of the saved video file in sqlite/coredata here.
}

-(void) extractFrames {
    MPMoviePlayerController *moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL: videoRef];
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:videoRef];
    CMTime duration = playerItem.duration;
    float seconds = CMTimeGetSeconds(duration);
    
    
    float frametime = [[NSUserDefaults standardUserDefaults] floatForKey:@"extractRate"];
    if (frametime < 0.01) frametime = 0.1;
    dispatch_async(dispatch_get_main_queue(), ^{
        extractRateLabel.text = [[NSString stringWithFormat:@"@%.2f", frametime] stringByAppendingString:@" sec/frame"];
    });

    
    
    
    int numFrames = (int)(seconds/frametime);
    
    
    int maxFrames;
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"maxframes"]){
        maxFrames = 100;
    }else{
        maxFrames = 30;
    }
    
    //check if numFrames over max constrained frames
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
    [self trimVideo];
    
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

-(void)setURL:(NSURL *)theVideoRef setStart:(NSNumber*)thestart setEnd:(NSNumber*)theend{
    videoRef = theVideoRef;
    start = thestart;
    end = theend;
    
}


-(void)showResponse:(NSMutableArray*)imageArray{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    
    SGFrameEditController *vc = [storyboard instantiateViewControllerWithIdentifier:@"FrameEditController"];
    
    
    vc.frames = imageArray;
    vc.videoPath = outputURL;
    UIViewController *presentingView = self.presentingViewController;
    [self dismissViewControllerAnimated:NO completion:^{[presentingView presentViewController:vc animated:YES completion:nil];}];
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [process stop];
        
    });
    //must close detached thread
    [NSThread exit];
    
    
    
}



- (void)viewDidUnload {

    extractRateLabel = nil;
    [self setProcessing:nil];
    [self setExtracting:nil];
    [self setProgress:nil];
    [super viewDidUnload];
}
@end
