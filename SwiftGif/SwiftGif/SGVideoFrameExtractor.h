//
//  SGVideoFrameExtractor.h
//  SwiftGif

#import <UIKit/UIKit.h>
#import "SGProcessingView.h"

@interface SGVideoFrameExtractor : UIViewController
{
    NSURL *videoRef;
    NSNumber* start;
    NSNumber* end;

    __weak IBOutlet UILabel *extractRateLabel;
    NSArray *animationFrames;
    SGProcessingView *process;
}
@property (weak, nonatomic) IBOutlet UIImageView *processing;
@property (weak, nonatomic) IBOutlet UIImageView *extracting;
@property (weak, nonatomic) IBOutlet UIProgressView *progress;

-(id) initWithURL: (NSURL*) videoRef;
-(void)setURL:(NSURL *)theVideoRef setStart:(NSNumber*)thestart setEnd:(NSNumber*)theend;

@end
