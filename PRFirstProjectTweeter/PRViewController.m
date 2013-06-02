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
  //@property (nonatomic, strong) IBOutlet UIWebView *twitterWebView;
  -(void)handleTwitterData: (NSData *) data
                          urlResponse: (NSHTTPURLResponse *) urlResponse
                          error: (NSError *) error;



  @property (nonatomic, strong) IBOutlet UITextView *twitterTextView;
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
  NSURL *twitterAPIURL = [NSURL URLWithString:@"http://api.twitter.com/1/statuses/user_timeline.json"];
  NSDictionary *twitterParams = @{ @"screen_name": @"foodiememe",  };
  
  SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:twitterAPIURL parameters:twitterParams];
  
  [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
    [self handleTwitterData:responseData urlResponse:urlResponse error:error];
  }];

/*
  [self.twitterWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.twitter.com/foodiememe"]]];
*/
  NSLog(@"about to show my tweets");
}

-(void) handleTwitterData:(NSData *)data urlResponse:(NSHTTPURLResponse *)urlResponse error:(NSError *)error{
  NSError *jsonError = nil;
  NSJSONSerialization *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
  NSLog(@"jsonResponse: %@", jsonResponse);
  NSLog(@"here is your call back");
  if(!jsonError && [jsonResponse isKindOfClass:[NSArray class]]){
    dispatch_async(dispatch_get_main_queue(), ^{
      NSArray *tweets = (NSArray *) jsonResponse;
      for (NSDictionary *tweetDict in tweets){
        NSString *tweetText = [NSString stringWithFormat:@"%@ (%@)",
           [tweetDict valueForKey:@"text"],
           [tweetDict valueForKey:@"created_at"]
         ];
        self.twitterTextView.text = [NSString stringWithFormat:@"%@%@\n\n", self.twitterTextView.text, tweetText];
      }
    
    });
  
  }
}

@end
