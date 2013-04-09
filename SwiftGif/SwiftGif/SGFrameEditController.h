//
//  SGFrameEditController.h
//  SwiftGif
//
//  Created by Tingshen Chen on 4/8/13.
//  Copyright (c) 2013 Team SwiftGif. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SGFrameEditController : UIViewController
@property (nonatomic, copy) NSArray *info;
@property (nonatomic, copy) NSArray *frames;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end
