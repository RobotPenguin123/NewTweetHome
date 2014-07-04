//
//  NTWViewController.m
//  NewTweet
//
//  Created by Audrey M Tam on 3/06/2014.
//  Copyright (c) 2014 RMIT. All rights reserved.
//

#import "NTWViewController.h"

@interface NTWViewController () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *tweetButton;
@property (weak, nonatomic) IBOutlet UILabel *characterCountLabel;
@property (weak, nonatomic) IBOutlet UITextView *tweetTextView;

@end

@implementation NTWViewController

static int kNTWCharacterLimit = 140;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.characterCountLabel.text = [NSString stringWithFormat:@"%d", kNTWCharacterLimit];
    self.tweetTextView.delegate = self;
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
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Posting tweet"
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

@end
