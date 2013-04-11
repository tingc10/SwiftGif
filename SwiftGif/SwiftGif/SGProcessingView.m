//
//  SGProcessingView.m
//  SwiftGif
//
//  Created by Tingshen Chen on 4/10/13.
//  Copyright (c) 2013 Team SwiftGif. All rights reserved.
//

#import "SGProcessingView.h"

@implementation SGProcessingView

- (id)initWithView:(UIImageView*)viewer type:(BOOL)isExtract overlay:(UIImageView *)status
{

    if (self) {
        NSArray *animationFrames = [NSArray arrayWithObjects:
                           [UIImage imageNamed:@"processing_1.png"],
                           [UIImage imageNamed:@"processing_2.png"],
                           [UIImage imageNamed:@"processing_3.png"],
                           [UIImage imageNamed:@"processing_4.png"],
                           [UIImage imageNamed:@"processing_5.png"],
                           [UIImage imageNamed:@"processing_6.png"],
                           [UIImage imageNamed:@"processing_7.png"],
                           [UIImage imageNamed:@"processing_8.png"],nil];
        process = status;
        if(isExtract){
            NSArray *processFrames = [NSArray arrayWithObjects:
                                        [UIImage imageNamed:@"extracting_1.png"],
                                        [UIImage imageNamed:@"extracting_2.png"],
                                        [UIImage imageNamed:@"extracting_3.png"],
                                        [UIImage imageNamed:@"extracting_4.png"], nil];
            process.animationImages = processFrames;
        }else{
            NSArray *processFrames = [NSArray arrayWithObjects:
                                      [UIImage imageNamed:@"uploading_1.png"],
                                      [UIImage imageNamed:@"uploading_2.png"],
                                      [UIImage imageNamed:@"uploading_3.png"],
                                      [UIImage imageNamed:@"uploading_4.png"], nil];
            process.animationImages = processFrames;
        }
        process.animationDuration = 1;
        animate = viewer;
        animate.animationImages =  animationFrames;
        animate.animationDuration = 1;

    }
    return self;
}

- (void) animate{
    [animate startAnimating];
    [process startAnimating];
}

- (void) stop{
    [animate stopAnimating];
    [process stopAnimating];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
