//
//  SGVideoFrameExtractor.h
//  SwiftGif

#import <UIKit/UIKit.h>
#import "SGProcessingView.h"

@interface SGVideoFrameExtractor : UIViewController
{
    NSURL *videoRef;


    __weak IBOutlet UILabel *extractRateLabel;
    NSArray *animationFrames;
    SGProcessingView *process;
}
@property (weak, nonatomic) IBOutlet UIImageView *processing;
@property (weak, nonatomic) IBOutlet UIImageView *extracting;
@property (weak, nonatomic) IBOutlet UIProgressView *progress;

-(id) initWithURL: (NSURL*) videoRef;
-(void)setURL:(NSURL *)theVideoRef;

@end
