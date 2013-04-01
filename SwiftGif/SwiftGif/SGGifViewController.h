//
//  SGGifViewController.h
//  SwiftGif
//
//  Created by Tingshen Chen on 4/1/13.
//  Copyright (c) 2013 Team SwiftGif. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SGGifViewController : UIViewController
{
    NSURL *gifURL;
}
-(void) setURL:(NSURL*)theGifref;
@property (weak, nonatomic) IBOutlet UIWebView *gifDisplay;
@end
