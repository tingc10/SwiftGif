//
//  SGThirdViewController.h
//  SwiftGif
//
//  Created by Nick Ruff on 3/18/13.
//  Copyright (c) 2013 Team SwiftGif. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SGThirdViewController : UIViewController<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webViewNew;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *actIndicator;

@end
