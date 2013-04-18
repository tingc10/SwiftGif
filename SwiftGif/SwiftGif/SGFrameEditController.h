//
//  SGFrameEditController.h
//  SwiftGif
//
//  Created by Tingshen Chen on 4/8/13.
//  Copyright (c) 2013 Team SwiftGif. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SGFrameEditController : UIViewController


@property (nonatomic, assign) NSMutableArray *frames;

@property (nonatomic, assign) NSString *videoPath;

@property (nonatomic, copy) NSString *tags;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *rateLabel;
@property (weak, nonatomic) IBOutlet UISlider *playbackSlider;
@property (weak, nonatomic) IBOutlet UILabel *framesCount;
@property (weak, nonatomic) IBOutlet UIImageView *animateArray;
@property (weak, nonatomic) IBOutlet UIStepper *stepper;
@property (weak, nonatomic) IBOutlet UIButton *toggleButton;


@end
