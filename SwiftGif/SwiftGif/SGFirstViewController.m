//
//  SGFirstViewController.m
//  SwiftGif
//
//  Created by Tingshen Chen on 3/13/13.
//  Copyright (c) 2013 Team SwiftGif. All rights reserved.
//

#import "SGFirstViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "SGVIdeoFrameExtractor.h"
#import "SGFrameEditController.h"
#import "ELCImagePickerController.h"
#import "ELCAlbumPickerController.h"


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

- (void) uploadImages
{
    ELCAlbumPickerController *albumController = [[ELCAlbumPickerController alloc] initWithNibName:@"ELCAlbumPickerController" bundle:[NSBundle mainBundle]];
	ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initWithRootViewController:albumController];
    [albumController setParent:elcPicker];
	[elcPicker setDelegate:self];

    if ([self respondsToSelector:@selector(presentViewController:animated:completion:)]){
        [self presentViewController:elcPicker animated:YES completion:nil];
    } else {
        [self presentModalViewController:elcPicker animated:YES];
    }

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
    if(isLive){
        cameraView.showsCameraControls = YES;
    }
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
    
    [self dismissViewControllerAnimated:NO completion:nil];
    [picker.view removeFromSuperview];
    [(UITextView *)[self.view viewWithTag:2] setText:@""];
    
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    SGVideoFrameExtractor *extractor = [storyboard instantiateViewControllerWithIdentifier:@"VideoFrameExtractor"];
    [extractor setURL:[info objectForKey:UIImagePickerControllerMediaURL]];
    [extractor setModalPresentationStyle:UIModalPresentationFullScreen];
    
    [self presentViewController:extractor animated:YES completion:nil];
    
    
    
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController*)picker{
    [self dismissViewControllerAnimated:NO completion:nil];
    [picker.view removeFromSuperview];
    
    
    
    //[self.tabBarController setSelectedIndex:1];
    
}

- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    SGFrameEditController *vc = [storyboard instantiateViewControllerWithIdentifier:@"FrameEditController"];
    [self dismissViewControllerAnimated:NO completion:nil];
    /*
    if ([self respondsToSelector:@selector(dismissViewControllerAnimated:completion:)]){
        [self dismissViewControllerAnimated:NO completion:nil];
    } else {
        [self dismissModalViewControllerAnimated:YES];
    }
	*/
    vc.info = info;
    [self presentViewController:vc animated:YES completion:nil];
	
}
- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker
{

    [self dismissViewControllerAnimated:NO completion:nil];
    [picker.view removeFromSuperview];
}

@end
