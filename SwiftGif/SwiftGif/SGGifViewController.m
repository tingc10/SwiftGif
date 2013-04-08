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
    
    // Create HTML string from image URL
	// width 301 is size of current uiwebview
	NSString *htmlString = @"<html><body><img src='%@' width='301'></body></html>";
	NSString *imageHTML  = [[NSString alloc] initWithFormat:htmlString, gifURL];
    
	// Load image in UIWebView
	//imageWebView.scalesPageToFit = YES;
	[_gifDisplay loadHTMLString:imageHTML baseURL:nil];
    
    //NSURLRequest *requestObj = [NSURLRequest requestWithURL:gifURL];
    //[_gifDisplay loadRequest:requestObj];
    //_gifDisplay.delegate = self;
}

- (IBAction)downloadGif:(id)sender {
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    
    //must save gif as NSData to animate
    NSData *data = [NSData dataWithContentsOfURL:gifURL];
    
    //saves GIF to photolibrary
    [library writeImageDataToSavedPhotosAlbum:data metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {}];
    
    // copies GIF to clipboard
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setData:data forPasteboardType:@"com.compuserve.gif"];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Downloaded to Photo Library" message:@"...and copied to clipboard" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    /*
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
	if([MFMessageComposeViewController canSendText])
	{
		controller.body = @"Tap to paste";
		controller.recipients = nil;
		controller.messageComposeDelegate = self;
		[self presentModalViewController:controller animated:YES];
	}
    
    /*
    
*/
}


- (IBAction)backButton:(id)sender {
    // go back to first tab (Gif Creation Center)

    //[self.tabBarController setSelectedIndex:0];
    //[self.tabBarController viewDidAppear:YES];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    
    UITabBarController  *vc = [storyboard instantiateViewControllerWithIdentifier:@"MasterTabBar"];
    [vc reloadInputViews];
    [self presentViewController:vc animated:YES completion:nil];
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

/*
- (void)webViewDidFinishLoad:(UIWebView *)theWebView
{
    CGSize contentSize = theWebView.scrollView.contentSize;
    CGSize viewSize = self.view.bounds.size;
    
    float rw = viewSize.width / contentSize.width;
    
    theWebView.scrollView.minimumZoomScale = rw;
    theWebView.scrollView.maximumZoomScale = rw;
    theWebView.scrollView.zoomScale = rw;
}
*/


-(void)setURL:(NSURL *)theGifref
{
    gifURL = theGifref;
}

@end
