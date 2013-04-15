//
//  SGGifViewController.m
//  SwiftGif
//
//  Created by Tingshen Chen on 4/1/13.
//  Copyright (c) 2013 Team SwiftGif. All rights reserved.
//

#import "SGGifViewController.h"
#import "SGSecondViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MessageUI/MessageUI.h>


@interface SGGifViewController ()

@end
//kUTTypeGIF is type for GIF
@implementation SGGifViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"Background.png"]];
    
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:gifURL];
    [_gifDisplay loadRequest:requestObj];
    NSMutableString *html = [[NSMutableString alloc] initWithString:@"<html><head><style type='text/css'>body {background-color:transparent; margin:0; padding:0;} img { max-width: 100%; width: auto; height: auto; } a { color:white; }</style></head><body>"];
    [html appendFormat:@"<img src=\"%@\"></body></html>", downloadGif.relativeString];
    
    [_gifDisplay loadHTMLString:html baseURL:nil];
    
    //hide share options, show default options
    _shareView.hidden = YES;
    _defaultView.hidden = NO;
}

- (IBAction)downloadGif:(id)sender {

    [NSThread detachNewThreadSelector:@selector(downloadURL) toTarget:self withObject:nil];
    

     /*
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
	if([MFMessageComposeViewController canSendText])
	{
		controller.body = @"Tap to paste";
		controller.recipients = nil;
		controller.messageComposeDelegate = self;
		[self presentModalViewController:controller animated:YES];
	}
    */

      
}

- (IBAction)showShare:(id)sender {
    _shareView.hidden = NO;
    _defaultView.hidden = YES;
}

- (IBAction)backButton:(id)sender {
    // go back to first tab (Gif Creation Center)

    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)cancelShare:(id)sender {
    _shareView.hidden = YES;
    _defaultView.hidden = NO;
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
	switch (result) {
		case MessageComposeResultCancelled:
			NSLog(@"Cancelled");
			break;
		case MessageComposeResultFailed:
            NSLog(@"Failed");

			break;
		case MessageComposeResultSent:
            
			break;
		default:
			break;
	}
    
	[self dismissModalViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setURL:(NSURL *)theGifref downloadURL:(NSURL*)download
{
    gifURL = theGifref;
    downloadGif = download;
}

- (IBAction)copyURLButtonClicked:(id)sender {
    // copy GIF URL to clipboard:
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = [gifURL absoluteString];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"URL Copied!" message:@"You're welcome for the free hosting space! :)" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

-(void)downloadURL{
    if(![NSThread isMainThread])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            _downloading.hidden = NO;
            [_downloading startAnimating];
            [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        });
    }
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    //must save gif as NSData to animate
    NSData *data = [NSData dataWithContentsOfURL:downloadGif];
    
    //saves GIF to photolibrary
    [library writeImageDataToSavedPhotosAlbum:data metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {}];
    
    // copies GIF to clipboard
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setData:data forPasteboardType:@"com.compuserve.gif"];
    
    
    //exit detached thread
    if(![NSThread isMainThread])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            _downloading.hidden = YES;
            [_downloading stopAnimating];
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Downloaded to Photo Library" message:@"...and copied to clipboard" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            
        });
    }
    
    [NSThread exit];
    
}


- (void)viewDidUnload {
    [self setDownloading:nil];
    [self setShareView:nil];
    [self setDefaultView:nil];
    [super viewDidUnload];
}
@end
