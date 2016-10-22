//
//  MovieCell.m
//  OMDB_Client
//
//  Created by Tomislav Luketic on 10/22/16.
//  Copyright © 2016 Tomislav Luketic. All rights reserved.
//

#import "MovieCell.h"

@implementation MovieCell

- (void)awakeFromNib {
    [super awakeFromNib];
	
	self.imgMovie.image=[UIImage imageNamed:@"placeholder"];
}

-(void)setMovieID:(NSString *)movieID
{
	_movieID=movieID;
	
  if (![self.poster isEqualToString:@"N/A"])
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		
		NSString* aID=movieID;
		
		NSURLRequest* request=[NSURLRequest requestWithURL:[NSURL URLWithString:self.poster]];
		
		NSCachedURLResponse *cachedResponse = [[NSURLCache sharedURLCache] cachedResponseForRequest:request];
		UIImage* aImage=nil;
		
		if (cachedResponse.data)
			aImage=[UIImage imageWithData:cachedResponse.data];
		else
			aImage=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.poster]]];
		
		if ([aID isEqualToString:movieID])
		{
			dispatch_async(dispatch_get_main_queue(), ^{
				self.imgMovie.image=aImage;
			});
		}
		
		
	});
	
	
	
}

-(void)prepareForReuse
{
	[super prepareForReuse];
	
	self.imgMovie.image=[UIImage imageNamed:@"placeholder"];
}


@end