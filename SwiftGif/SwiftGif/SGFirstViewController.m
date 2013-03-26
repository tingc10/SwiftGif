//
//  SGFirstViewController.m
//  SwiftGif
//
//  Created by Tingshen Chen on 3/13/13.
//  Copyright (c) 2013 Team SwiftGif. All rights reserved.
//

#import "SGFirstViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "SGVideoEditController.h"


@implementation SGFirstViewController

BOOL shouldOpen = true;

- (IBAction)gifClick:(id)sender {
    [self doCamera: YES];
}


- (IBAction)uploadVid:(id)sender {
    [self doCamera:NO];
}

- (IBAction)uploadPics:(id)sender {
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    shouldOpen = true;
    
    
}

- (void) doCamera: (BOOL)isLive {
    UIImagePickerController *cameraView = [[UIImagePickerController alloc] init];
    if (isLive){
        if([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
        cameraView.sourceType = UIImagePickerControllerSourceTypeCamera;
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Camera Not Found" message:nil delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
    }else{
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
            cameraView.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Camera Roll Not Found" message:nil delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
    }
    
    //cameraView.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType: UIImagePickerControllerSourceTypeCamera];
    
    cameraView.mediaTypes =
    [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
    if(isLive)
        cameraView.showsCameraControls = YES;
    
    cameraView.allowsEditing = YES;
    
    cameraView.delegate = self;
    
    [self.view addSubview:cameraView.view];
    [cameraView viewWillAppear:YES];
    [cameraView viewDidAppear:YES];
    
    [self presentViewController:cameraView animated:NO completion:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:YES];
    
    if (shouldOpen) {
    
        [self doCamera:YES];
        //[(UITextView *)[self.view viewWithTag:2] setText:@"OPENING CAMERA NOW"];
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)imagePickerController:(UIImagePickerController*)picker
didFinishPickingMediaWithInfo:(NSDictionary*)info{
    
    //[picker UISaveVideoAtPathToSavedPhotosAlbum];
    shouldOpen = false;
    [self dismissViewControllerAnimated:NO completion:nil];
    [picker.view removeFromSuperview];
    [(UITextView *)[self.view viewWithTag:2] setText:@""];
    
    //[self processVideo:[info objectForKey:UIImagePickerControllerMediaURL]];
    //[self.tabBarController setSelectedIndex:1];
    // instead of above, take to "Uploading Video" view called SGVideoEditController
    // because it was originally going to be a video editor mode but that was actually
    // handled in the built-in UI video camera and we never bothered to change the name
    // of SGVideoEditController ;)
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    SGVideoEditController *vc = [storyboard instantiateViewControllerWithIdentifier:@"VideoEditController"];
    [vc setURL:[info objectForKey:UIImagePickerControllerMediaURL]];
    [vc setModalPresentationStyle:UIModalPresentationFullScreen];
    
    [self presentViewController:vc animated:YES completion:nil];
    
    
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController*)picker{
    shouldOpen = false;
    [self dismissViewControllerAnimated:NO completion:nil];
    [picker.view removeFromSuperview];
    
    [(UITextView *)[self.view viewWithTag:2] setText:@""];
    
    //[self.tabBarController setSelectedIndex:1];
    
}



- (void)processVideo:(NSURL*)vid{
    
}

@end
