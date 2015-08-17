//
//  SendAYakVC.m
//  Pinging
//
//  Created by Brexton Pham on 7/28/15.
//  Copyright (c) 2015 Brexton Pham. All rights reserved.
//

#import "SendAYakVC.h"
#import <MobileCoreServices/UTCoreTypes.h>


@interface SendAYakVC () 

@end

AVCaptureSession *session;
AVCaptureStillImageOutput *stillImageOutput;

@implementation SendAYakVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.allUsersObjectIds = [[NSMutableArray alloc] init];
    
    self.navBarView.layer.borderColor = [UIColor colorWithRed:187.0/255.0 green:187.0/255.0 blue:187.0/255.0 alpha:1].CGColor;
    self.navBarView.layer.borderWidth = 0.8f;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    PFQuery *query = [PFUser query]; //queries all users by default
    [query orderByAscending:@"username"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        else {
            self.allUsers = objects; //obtains all users and adds it to allUsers array
            NSLog(@"%@", self.allUsers);
            for (PFUser *user in self.allUsers) { //obtains all objectIds and puts it in separate array
                [self.allUsersObjectIds addObject:user.objectId];
            }
        }
    }];
    
    self.currentUser = [PFUser currentUser];
    
    
    
    ////////
    
    session = [[AVCaptureSession alloc] init];
    [session setSessionPreset:AVCaptureSessionPresetPhoto];
    
    AVCaptureDevice *inputDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error;
    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:inputDevice error:&error];
    
    if ([session canAddInput:deviceInput]) {
        [session addInput:deviceInput];
    }
    
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
    [self.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    CALayer *rootLayer = [[self view] layer];
    [rootLayer setMasksToBounds:YES];
    CGRect frame = frameForCapture.frame;
    
    [self.previewLayer setFrame:frame];
    
    [rootLayer insertSublayer:self.previewLayer atIndex:0];
    
    stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG, AVVideoCodecKey, nil];
    [stillImageOutput setOutputSettings:outputSettings];
    
    [session addOutput:stillImageOutput];
    
    [session startRunning];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

}

- (IBAction)cancelButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)send:(id)sender {
    [self uploadYak];
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)takePhoto:(id)sender {
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in stillImageOutput.connections) {
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo]) {
                videoConnection = connection;
                break;
            }
        }
    }
    [stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if (imageDataSampleBuffer != NULL) {
            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
            UIImage *image = [UIImage imageWithData:imageData];
            
            CGRect outputRect = [self.previewLayer metadataOutputRectOfInterestForRect:self.previewLayer.bounds];
            CGImageRef takenCGImage = image.CGImage;
            size_t width = CGImageGetWidth(takenCGImage);
            size_t height = CGImageGetHeight(takenCGImage);
            CGRect cropRect = CGRectMake(outputRect.origin.x * width, outputRect.origin.y * height, outputRect.size.width * width, outputRect.size.height * height);
            
            CGImageRef cropCGImage = CGImageCreateWithImageInRect(takenCGImage, cropRect);
            image = [UIImage imageWithCGImage:cropCGImage scale:1 orientation:image.imageOrientation];
            CGImageRelease(cropCGImage);
            
            imageView.image = image;
            
            self.messageField.editable = YES;
            [self.messageField becomeFirstResponder];
        }
    }];
}

/* Method used to upload yak to back end and save it in Parse*/
- (void)uploadYak {
    NSData *fileData;
    NSString *fileName;
    NSString *fileType;
    NSString *yak = [self.messageField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    //obtain data if yak actually exists
    if ([yak length] != 0) {
        fileData = [yak dataUsingEncoding:NSUTF8StringEncoding];
        fileName = @"yak";
        fileType = @"string";
    }
    
    PFFile *file = [PFFile fileWithName:fileName data:fileData];
    
    [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) { //Alerts if yak doesn't save properly in Parse
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"An error occurred!" message:@"Please try sending your message again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        } else {
            PFObject *message = [PFObject objectWithClassName:@"Messages"];
            [message setObject:file forKey:@"file"]; //Creating classes to save message to in parse
            [message setObject:yak forKey:@"fileContents"];
            [message setObject:fileType forKey:@"fileType"];
            [message setObject:self.allUsersObjectIds forKey:@"recipientIds"];
            [message setObject:[[PFUser currentUser] objectId] forKey:@"senderId"];
            [message setObject:[[PFUser currentUser] username] forKey:@"senderName"];
            [message saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (error) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"An error occurred!" message:@"Please try sending your message again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alertView show];
                } else {
                    //IT WORKED.
                }
            }];
        }
    }];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    textView.editable = NO;
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    [session stopRunning];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    [session startRunning];
}

@end
