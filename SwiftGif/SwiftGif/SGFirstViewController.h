//
//  SGFirstViewController.h
//  SwiftGif
//
//  Created by Tingshen Chen on 3/13/13.
//  Copyright (c) 2013 Team SwiftGif. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SGFirstViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    UIPopoverController *popoverController;
    UIBarButtonItem *doneButton;
    int IMAGE_COUNTER;
}



@end
