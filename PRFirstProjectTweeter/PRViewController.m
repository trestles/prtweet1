//
//  PRViewController.m
//  PRFirstProjectTweeter
//
//  Created by Jonathan Twaddell on 6/2/13.
//  Copyright (c) 2013 Jonathan Twaddell. All rights reserved.
//

#import "PRViewController.h"
#import <Social/Social.h>

@interface PRViewController ()
  -(void)reloadTweets;
  @property (nonatomic, strong) IBOutlet UIWebView *twitterWebView;
@end

@implementation PRViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)handleTweedHappend:(id)sender{
  NSLog(@"You clicked the tweet");
  if([SLComposeViewController isAvailableForServiceType: SLServiceTypeTwitter]){
    SLComposeViewController *tweetVC=[SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    [tweetVC setInitialText:@"I just want to finished this first step"];
    tweetVC.completionHandler = ^(SLComposeViewControllerResult result){
      if(result == SLComposeViewControllerResultDone){
        [self dismissViewControllerAnimated:YES completion:NULL];
        [self reloadTweets];
      }
    };
    [self presentViewController:tweetVC animated:YES completion:NULL];
    NSLog(@"could compose tweet");
  }else{
    NSLog(@"could not compose tweet");
  }
}

-(IBAction) handleShowMyTweetsTapped:(id)sender{
  [self reloadTweets];
}

-(void)reloadTweets{
  [self.twitterWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.twitter.com/foodiememe"]]];
  NSLog(@"about to show my tweets");
}

@end
