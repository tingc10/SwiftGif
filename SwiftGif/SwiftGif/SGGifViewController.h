//
//  SGGifViewController.h
//  SwiftGif
//
//  Created by Tingshen Chen on 4/1/13.
//  Copyright (c) 2013 Team SwiftGif. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMessageComposeViewController.h>
#import <MessageUI/MessageUI.h>

@interface SGGifViewController : UIViewController<MFMessageComposeViewControllerDelegate,UINavigationControllerDelegate>
{
    NSURL *gifURL;
    NSURL *downloadGif;
}
-(void) setURL:(NSURL*)theGifref downloadURL:(NSURL*)download;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *downloading;
@property (weak, nonatomic) IBOutlet UIWebView *gifDisplay;
@end
