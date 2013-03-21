//
//  WebViewController.h
//  SwiftGif
//
//  Created by Nick Ruff on 3/18/13.
//  Copyright (c) 2013 Team SwiftGif. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController
{
IBOutlet UIWebView *webView;
}

@property (nonatomic, retain) UIWebView *webView;
@end
