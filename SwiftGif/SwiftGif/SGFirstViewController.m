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



- (IBAction)gifClick:(id)sender {
    [self doCamera: YES];
}


- (IBAction)uploadVid:(id)sender {
    [self doCamera:NO];
}

- (IBAction)uploadPics:(id)sender {
    [self uploadImages];
}

//initWithCoder is the init function with Storyboard
- (id)initWithCoder:(NSCoder*)aDecoder
{
    if(self = [super initWithCoder:aDecoder])
    {
        UITabBarItem* tabBarItem =  [[UITabBarItem alloc] initWithTitle:nil image:nil tag:0];
        [tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"video_selected.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"video.png"]];
        self.tabBarItem = tabBarItem;

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"Background.png"]];
    
    
}

- (void) uploadImages{
    UIImagePickerController *photoLib = [[UIImagePickerController alloc] init];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
        photoLib.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Camera Roll Not Found" message:nil delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }

    
    //cameraView.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType: UIImagePickerControllerSourceTypeCamera];
    
    photoLib.mediaTypes =
    [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];

    
    //cameraView.allowsEditing = YES;
    
    photoLib.delegate = self;
    
    [self.view addSubview:photoLib.view];
    [photoLib viewWillAppear:YES];
    [photoLib viewDidAppear:YES];
    
    [self presentViewController:photoLib animated:NO completion:nil];
    
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
    BOOL shouldOpen = [[NSUserDefaults standardUserDefaults]boolForKey:@"openApp"];
    if (!shouldOpen)
    {
        NSLog(@"FirstLaunch");
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"openApp"];
        [self doCamera:YES];
        ///Do first run view initializaton here////
    }
    /*
    if (shouldOpen) {
        shouldOpen = false;
        [self doCamera:YES];
        
    }
     */
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)imagePickerController:(UIImagePickerController*)picker
didFinishPickingMediaWithInfo:(NSDictionary*)info{
    
    //[picker UISaveVideoAtPathToSavedPhotosAlbum];
    //shouldOpen = false;
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
    [self dismissViewControllerAnimated:NO completion:nil];
    [picker.view removeFromSuperview];
    
    
    
    //[self.tabBarController setSelectedIndex:1];
    
}

-(IBAction)selectExitingPicture
{
    //Specially for fing iPAD
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeImage];
    /*
    popoverController = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
    [popoverController presentPopoverFromRect:CGRectMake(0.0, 0.0, 400.0, 300.0)
                                       inView:self.view
                     permittedArrowDirections:UIPopoverArrowDirectionAny
                                     animated:YES];
     */
}

//Done button on top
- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated
{
    //NSLog(@"Inside navigationController ...");
    
    
    if (!doneButton)
    {
        doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                      style:UIBarButtonItemStyleDone
                                                     target:self action:@selector(saveImagesDone:)];
    }
    
    viewController.navigationItem.rightBarButtonItem = doneButton;
}

- (IBAction)saveImagesDone:(id)sender
{
    //NSLog(@"saveImagesDone ...");
    
    [popoverController dismissPopoverAnimated:YES];
}


-(void)imagePickerController:(UIImagePickerController *)picker
      didFinishPickingImage : (UIImage *)image
                 editingInfo:(NSDictionary *)editingInfo
{
    
    
    //DONT DISMISS
    //[picker dismissModalViewControllerAnimated:YES];
    //[popoverController dismissPopoverAnimated:YES];
    
    IMAGE_COUNTER = IMAGE_COUNTER + 1;
    
   // imageView.image = image;
    
    // Get the data for the image
    NSData* imageData = UIImageJPEGRepresentation(image, 1.0);
    
    
    // Give a name to the file
    NSString* incrementedImgStr = [NSString stringWithFormat: @"UserCustomPotraitPic%d.jpg", IMAGE_COUNTER];
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    
    // Now we get the full path to the file
    NSString* fullPathToFile2 = [documentsDirectory stringByAppendingPathComponent:incrementedImgStr];
    
    // and then we write it out
    [imageData writeToFile:fullPathToFile2 atomically:NO];
    
}

@end
