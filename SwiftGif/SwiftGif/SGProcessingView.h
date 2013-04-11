//
//  SGProcessingView.h
//  SwiftGif
//
//  Created by Tingshen Chen on 4/10/13.
//  Copyright (c) 2013 Team SwiftGif. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SGProcessingView : UIView
{
    UIImageView *animate;
    UIImageView *process;
}

-(id)initWithView:(UIImageView*)viewer type:(BOOL)isExtract overlay:(UIImageView*)status;
-(void) animate;
-(void) stop;
@end
