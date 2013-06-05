//
//  SGSecondViewController.h
//  SwiftGif
//
//  Created by Tingshen Chen on 3/13/13.
//  Copyright (c) 2013 Team SwiftGif. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SGSecondViewController : UIViewController<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *profile;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *actIndicator;
    
@end
