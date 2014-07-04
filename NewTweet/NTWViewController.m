//
//  NTWViewController.m
//  NewTweet
//
//  Created by Audrey M Tam on 3/06/2014.
//  Copyright (c) 2014 RMIT. All rights reserved.
//

#import "NTWViewController.h"
@import Social;  // Import the Social Framework

@interface NTWViewController () <UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate>
{
    UIImage *tweetImage;
}
@property (weak, nonatomic) IBOutlet UIBarButtonItem *tweetButton;
@property (weak, nonatomic) IBOutlet UILabel *characterCountLabel;
@property (weak, nonatomic) IBOutlet UITextView *tweetTextView;
@property (weak, nonatomic) IBOutlet UIImageView *thumbImage;

@end

@implementation NTWViewController

static int kNTWCharacterLimit = 140;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.characterCountLabel.text = [NSString stringWithFormat:@"%d", kNTWCharacterLimit];
    self.tweetTextView.delegate = self;
}

- (IBAction)showPicker:(id)sender {
    if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {   // iOS Device Code
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"Tweet Image"
                                  delegate:self
                                  cancelButtonTitle:@"Cancel"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"Take new photo", @"Use existing", nil];
        [actionSheet showInView:self.view];
    } else {   // iOS Simulator Code
        UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
        pickerController.delegate = self;
        pickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        [self presentViewController:pickerController animated:YES completion:nil];
    }
}

// UIActionSheetDelegate method: set image picker source type, depending on user's choice
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
    pickerController.delegate = self;
    if (buttonIndex == actionSheet.firstOtherButtonIndex) {
        pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        pickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    }
    [self presentViewController:pickerController animated:YES completion:NULL];
}

// UIImagePickerControllerDelegate method: capture selected/camera image
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [self dismissViewControllerAnimated:YES completion:nil];
    tweetImage = self.thumbImage.image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
}

#pragma mark - text view version

- (void)textViewDidChange:(UITextView *)textView {
    int remainingCharCount = kNTWCharacterLimit - self.tweetTextView.text.length;
    // enable or disable tweetButton
    if ((remainingCharCount >= 0) && (remainingCharCount < kNTWCharacterLimit)) {
        self.tweetButton.enabled = YES;
    } else {
        self.tweetButton.enabled = NO;
    }
    
    // change label text color to red
    if (remainingCharCount <=0) {
        self.characterCountLabel.textColor = [UIColor redColor];
    }
    else {
        self.characterCountLabel.textColor = [UIColor blueColor];
    }
    self.characterCountLabel.text = [NSString stringWithFormat:@"%d", remainingCharCount];
}

#pragma mark - unwind seques

- (IBAction)cancel:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)sendTweet:(id)sender {
    [self.tweetTextView resignFirstResponder];
    
    NSString *message = self.tweetTextView.text;
    SLComposeViewController *composeViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    [composeViewController setInitialText:message];
    if (tweetImage) {
        [composeViewController addImage:tweetImage];
        tweetImage = nil;
        self.thumbImage.image = nil;
    }
    [self presentViewController:composeViewController animated:YES completion:nil];
    
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Posting tweet"
//                                                    message:message
//                                                   delegate:nil
//                                          cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    [alert show];
//    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

@end
