//
//  SGVideoFrameExtractor.h
//  SwiftGif

#import <UIKit/UIKit.h>

@interface SGVideoFrameExtractor : UIViewController
{
    NSURL *videoRef;
    __weak IBOutlet UIProgressView *progress;

    __weak IBOutlet UILabel *extractRateLabel;

}
-(id) initWithURL: (NSURL*) videoRef;
-(void)setURL:(NSURL *)theVideoRef;

@end
