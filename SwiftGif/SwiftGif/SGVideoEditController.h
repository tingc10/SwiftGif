//
//  SGVideoEditController.h
//  SwiftGif
//
//  Created by Tingshen Chen on 3/23/13.
//  Copyright (c) 2013 Team SwiftGif. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SGVideoEditController : UIViewController
{
    NSURL *videoRef;
}
-(id) initWithURL: (NSURL*) videoRef;
-(void)setURL:(NSURL *)theVideoRef;
@end
