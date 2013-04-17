//
//  SGdeleteButton.m
//  SwiftGif
//
//  Created by Tingshen Chen on 4/16/13.
//  Copyright (c) 2013 Team SwiftGif. All rights reserved.
//

#import "SGdeleteButton.h"

@implementation SGdeleteButton
@synthesize index;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.frame = frame;
        self.contentMode = UIViewContentModeScaleAspectFit;
        
        self.reversesTitleShadowWhenHighlighted = YES;
        
         
        [self setBackgroundImage:[UIImage imageNamed:@"cancel.png"] forState:normal];

    }
    return self;
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
