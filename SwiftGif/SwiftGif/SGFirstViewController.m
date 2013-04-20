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
    
    if(isLive){
        [self presentViewController:cameraView animated:NO completion:nil];
    }else{
        [self presentViewController:cameraView animated:YES completion:nil];
    }
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
    
    /////////////////////////////////////////
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:(NSString *)kUTTypeVideo] ||
        [type isEqualToString:(NSString *)kUTTypeMovie]) { // movie != video
        
        NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
        //define start and end of video
        NSNumber *start = [info objectForKey:@"_UIImagePickerControllerVideoEditingStart"];
        NSNumber *end = [info objectForKey:@"_UIImagePickerControllerVideoEditingEnd"];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        SGVideoFrameExtractor *extractor = [storyboard instantiateViewControllerWithIdentifier:@"VideoFrameExtractor"];
        [extractor setURL:videoURL setStart:start setEnd:end];
        [extractor setModalPresentationStyle:UIModalPresentationFullScreen];
        [self presentViewController:extractor animated:NO completion:nil];
        
        
        
    }
    /////////////////////////////////////////
    /*
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    SGVideoFrameExtractor *extractor = [storyboard instantiateViewControllerWithIdentifier:@"VideoFrameExtractor"];
    [extractor setURL:[info objectForKey:UIImagePickerControllerMediaURL]];
    [extractor setModalPresentationStyle:UIModalPresentationFullScreen];
    [self presentViewController:extractor animated:NO completion:nil];
    
    */
    
}



- (void)imagePickerControllerDidCancel:(UIImagePickerController*)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
    [picker.view removeFromSuperview];
    
    
    
    //[self.tabBarController setSelectedIndex:1];
    
}

- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info
{
    if(info.count == 0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please select one or more images" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    SGFrameEditController *vc = [storyboard instantiateViewControllerWithIdentifier:@"FrameEditController"];
    //NSMutableArray *images = [NSMutableArray arrayWithCapacity:[info count]];
    NSMutableArray *images = [NSMutableArray array];
	for(NSDictionary *dict in info) {
        
        UIImage *image = (UIImage*)[dict objectForKey:UIImagePickerControllerOriginalImage];
        
        //performs check of valid jpeg file
        if(![self contentTypeForImageData:UIImageJPEGRepresentation(image, .1)]){
            continue;
        }
        
        [images addObject:image];
        
	}
    //UIViewController *modalView = self;
    vc.frames = images;
    UIViewController *presentingView = self;
    [self dismissViewControllerAnimated:NO completion:^{[presentingView presentViewController:vc animated:NO completion:nil];}];
    
    
    //[self presentViewController:vc animated:NO completion:nil];
	
}
- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker
{

    [self dismissViewControllerAnimated:YES completion:nil];
    [picker.view removeFromSuperview];
}

- (BOOL)contentTypeForImageData:(NSData *)data {
    uint8_t c;
    [data getBytes:&c length:1];
    if(c == 0xFF){
        return YES;
    }else{
        return NO;
    }
    /*
    switch (c) {
        case 0xFF:
            return @"image/jpeg";
        case 0x89:
            return @"image/png";
        case 0x47:
            return @"image/gif";
        case 0x49:
        case 0x4D:
            return @"image/tiff";
    }
    return nil;
     */
}

@end
