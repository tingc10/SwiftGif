//
//  SGFirstViewController.h
//  SwiftGif
//
//  Created by Tingshen Chen on 3/13/13.
//  Copyright (c) 2013 Team SwiftGif. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ELCImagePickerController.h"
#import <AVFoundation/AVFoundation.h>

@interface SGFirstViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate,ELCImagePickerControllerDelegate, AVAssetResourceLoaderDelegate>
{
    
}
- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info;
- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker;
@end
