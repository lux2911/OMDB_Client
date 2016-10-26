//
//  MovieCell.m
//  OMDB_Client
//
//  Created by Tomislav Luketic on 10/22/16.
//  Copyright © 2016 Tomislav Luketic. All rights reserved.
//

#import "MovieCell.h"

@implementation MovieCell

@synthesize movieID;

- (void)awakeFromNib {
    [super awakeFromNib];
	
	self.imgMovie.image=[UIImage imageNamed:@"placeholder"];
}

-(NSString *)movieID
{
	@synchronized (self) {
		return movieID;
	}
}

-(void)setMovieID:(NSString *)aMovieID
{
	@synchronized (self) {
		movieID=aMovieID;
	}
	
	
  if (![self.poster isEqualToString:@"N/A"])
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		
	   @synchronized (self)
		{
		NSString* aID=self.movieID;
		
		NSURLRequest* request=[NSURLRequest requestWithURL:[NSURL URLWithString:self.poster]];
		
		NSCachedURLResponse *cachedResponse = [[NSURLCache sharedURLCache] cachedResponseForRequest:request];
		UIImage* aImage=nil;
		
		if (cachedResponse.data)
			aImage=[UIImage imageWithData:cachedResponse.data];
		else
			aImage=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.poster]]];
		
		if ([aID isEqualToString:self.movieID])
		{
			dispatch_async(dispatch_get_main_queue(), ^{
				
				if (aImage && [aID isEqualToString:self.movieID])
				 self.imgMovie.image=aImage;
			});
		}
		}
		
	});
	
	
	
}

-(void)prepareForReuse
{
	[super prepareForReuse];
	
	self.imgMovie.image=[UIImage imageNamed:@"placeholder"];
}


@end
