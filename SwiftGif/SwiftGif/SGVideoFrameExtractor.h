//
//  SGVideoFrameExtractor.h
//  SwiftGif

#import <UIKit/UIKit.h>

@interface SGVideoFrameExtractor : UIViewController
{
    NSURL *videoRef;
    __weak IBOutlet UIProgressView *progress;
}
-(id) initWithURL: (NSURL*) videoRef;
-(void)setURL:(NSURL *)theVideoRef;

@end
