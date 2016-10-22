//
//  UIViewController+ProgressHUD.m
//
//  Created by Chris Miles on 26/07/11.
//  Copyright 2011 Chris Miles. All rights reserved.
//
// This code is distributed under the terms and conditions of the MIT license.

// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <objc/runtime.h>
#import "UIViewController+ProgressHUD.h"
#import "MBProgressHUD.h"

#import "UIImage+animatedGIF.h"

static char progresshud_key;	// unique address for associative object key
static char progress_blocker;

@implementation UIViewController ( ProgressHUD )

#pragma mark - Progress HUD management

- (MBProgressHUD *)currentProgressHUD
{
    MBProgressHUD *progressHUD = objc_getAssociatedObject(self, &progresshud_key);
    return progressHUD;
}

- (UIView *)currentProgressBlocker
{
    UIView *progressHUD = objc_getAssociatedObject(self, &progress_blocker);
    return progressHUD;
}




- (void)showSpinnerInWindowUnopstructed
{
    if ([self currentProgressHUD]) {
        [self dismissHUDAnimated:YES];
    }
    if ([self currentProgressBlocker]) {
        [[self currentProgressBlocker] removeFromSuperview];
    }
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    
	
    UIView *darkSpinnerBG=[[UIView alloc] initWithFrame:CGRectMake(window.bounds.size.width/2-62, window.bounds.size.height/2-62, 124, 124)];
        [darkSpinnerBG setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin];
    UIImageView *spinerImageBG=[[UIImageView alloc] init];//WithImage:[UIImage imageNamed:@"preloader-bg-1"]];
    spinerImageBG.frame=CGRectMake(0, 0, 124, 124);
    [darkSpinnerBG addSubview:spinerImageBG];
     UIImageView *largeSpinner=[[UIImageView alloc] init];
    largeSpinner.frame=CGRectMake(39,39, 46, 46);
	
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"balls" withExtension:@"gif"];
    largeSpinner.image = [UIImage animatedImageWithAnimatedGIFData:[NSData dataWithContentsOfURL:url]];

    
    [largeSpinner startAnimating];
    [darkSpinnerBG addSubview:largeSpinner];
    
    [[[UIApplication sharedApplication] keyWindow] addSubview:darkSpinnerBG];
    [[[UIApplication sharedApplication] keyWindow] bringSubviewToFront:darkSpinnerBG];
    
    objc_setAssociatedObject(self, &progress_blocker, darkSpinnerBG, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

- (void)showSpinnerInWindow
{
    if ([self currentProgressHUD]) {
        [self dismissHUDAnimated:YES];
    }
    if ([self currentProgressBlocker]) {
        [[self currentProgressBlocker] removeFromSuperview];
    }
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    
    UIView *blockerWithSpinner=[[UIView alloc] initWithFrame:window.bounds];
    UIButton *blockerButton = [[UIButton alloc] initWithFrame:blockerWithSpinner.frame];
    [blockerWithSpinner addSubview:blockerButton];
    
    UIView *darkSpinnerBG=[[UIView alloc] initWithFrame:CGRectMake(blockerWithSpinner.frame.size.width/2-62, blockerWithSpinner.frame.size.height/2-62, 124, 124)];
       [darkSpinnerBG setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin];
    UIImageView *spinerImageBG=[[UIImageView alloc] init];//UIImageView *spinerImageBG=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"preloader-bg-1"]];
    spinerImageBG.frame=CGRectMake(0, 0, 124, 124);
    [darkSpinnerBG addSubview:spinerImageBG];
    [blockerWithSpinner addSubview:darkSpinnerBG];
	
    UIImageView *largeSpinner=[[UIImageView alloc] init];
    largeSpinner.frame=CGRectMake(39,39, 46, 46);
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"balls" withExtension:@"gif"];
    largeSpinner.image = [UIImage animatedImageWithAnimatedGIFData:[NSData dataWithContentsOfURL:url]];

    
    [largeSpinner startAnimating];
    [darkSpinnerBG addSubview:largeSpinner];
    
    [[[UIApplication sharedApplication] keyWindow] addSubview:blockerWithSpinner];
    [[[UIApplication sharedApplication] keyWindow] bringSubviewToFront:blockerWithSpinner];
    
    objc_setAssociatedObject(self, &progress_blocker, blockerWithSpinner, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

- (void)dismissHUDAnimated:(BOOL)animated
{
	
    if ([self currentProgressBlocker]) {
        [[self currentProgressBlocker] removeFromSuperview];
        objc_setAssociatedObject(self, &progress_blocker, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

@end
