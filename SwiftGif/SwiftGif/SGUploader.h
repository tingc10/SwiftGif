//
//  SGUploader.h
//  SwiftGif
//
//  Created by Nick Ruff on 4/8/13.
//  Copyright (c) 2013 Team SwiftGif. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SGUploader : UIViewController{
    NSArray *images;
    int playbackRateHundred;
    NSString *tags;
}

@property (weak, nonatomic) IBOutlet UIProgressView *upProgress;

-(void)setData:(NSArray*)images_in andRate:(int)playbackRateHundred_in andTags:(NSString*)tags_in;

@end
