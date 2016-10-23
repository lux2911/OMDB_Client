//
//  ViewController.m
//  OMDB_Client
//
//  Created by Tomislav Luketic on 10/21/16.
//  Copyright © 2016 Tomislav Luketic. All rights reserved.
//

#import "ViewController.h"
#import "Movie.h"
#import "MovieCell.h"
#import "UIViewController+ProgressHUD.h"
#import "OMDB_Client-Swift.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) NSMutableArray* movies;
@property (nonatomic,strong) NSURLSession* urlSession;
@property (nonatomic,strong) NSURLSessionDataTask* dataTask;
@property (nonatomic,assign) int totalResults;
@property (nonatomic,strong) NSString* searchText;

@end

@implementation ViewController

#define kBaseURL @"http://www.omdbapi.com/?s=%@&type=movie&page=%d"

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.searchBar.delegate=self;
	self.navigationItem.titleView = self.searchBar;
	self.urlSession= [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
	self.movies=[NSMutableArray array];
	
	self.tableView.delegate=self;
	self.tableView.dataSource=self;
	
	self.tableView.rowHeight=70;
	self.tableView.tableHeaderView=nil;
	self.tableView.tableFooterView=[self tableFooter];
	
}


-(UIView*)tableFooter
{
	
	if ([self.movies count]>0)
		return [UIView new];
	
	UIView* aView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,286)];
	aView.backgroundColor=[UIColor darkTextColor];
	
	UIImageView* iv=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 286)];
	[iv setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
	iv.contentMode=UIViewContentModeScaleAspectFit;
	iv.image=[UIImage imageNamed:@"tour_search"];
	
	
	[aView addSubview:iv];
	
	
	return aView;
}



#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return  [self.movies count];
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString* cellName=@"MovieCell";
	
	MovieCell* aCell=[self.tableView dequeueReusableCellWithIdentifier:cellName];
	
	if (!aCell)
	{
		aCell=[[MovieCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellName];
		
	}
	
	Movie* aMovie=self.movies[indexPath.row];
	
	aCell.lblTitle.text=aMovie.Title;
	aCell.lblYear.text=aMovie.Year;
	aCell.poster=aMovie.Poster;
	
	aCell.movieID=aMovie.imdbID; // calls setter that will get image
	
	
	NSInteger cnt=[self.tableView numberOfRowsInSection:0];
		
	
	if (indexPath.row==[self.movies count]-1 && cnt<self.totalResults && !self.dataTask)
	{
		int aPage=(int)(cnt/10)+1;
		[self loadDataForText:self.searchText andPage:aPage];
	}
	
		
	return  aCell;
}


#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
	[searchBar resignFirstResponder];
	
	if ([searchBar.text length]>0)
	{
		[self.movies removeAllObjects];
		self.totalResults=0;
		self.tableView.tableFooterView=[self tableFooter];
		
		[self.tableView reloadData];
		
		self.searchText=searchBar.text;
		[self loadDataForText:searchBar.text andPage:1];
	}
}

#pragma mark -

-(void)loadDataForText:(NSString*)text andPage:(unsigned int)page
{
	
	if (self.dataTask)
		[self.dataTask cancel];
	
	[self showSpinnerInWindow];
	
	
	NSURL* aURL=[NSURL URLWithString:[NSString stringWithFormat:kBaseURL,text,page]];
	
	self.dataTask=[self.urlSession dataTaskWithURL:aURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
		
		self.dataTask=nil;
		
		if (!error)
		{
			NSError * jsonErr;
			NSDictionary* dict=	[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonErr];
			
			if (!jsonErr)
			{
				self.totalResults=[dict[@"totalResults"] intValue];
				
				NSArray* arr = dict[@"Search"];
				
				for (NSDictionary* aMovie in arr) {
					
					Movie* newMovie=[Movie new];
					
					for (NSString* aKey in aMovie)
					{
						if ([newMovie respondsToSelector:NSSelectorFromString(aKey)])
							[newMovie setValue:aMovie[aKey] forKey:aKey];
					}
					
					[self.movies addObject:newMovie];
					
				}
				
				dispatch_async(dispatch_get_main_queue(), ^{
					[self dismissHUDAnimated:YES];
					self.tableView.tableFooterView=[self tableFooter];
					[self.tableView reloadData];
				});
				
			}
			else
			{
				dispatch_async(dispatch_get_main_queue(), ^{
					[self dismissHUDAnimated:YES];
					self.tableView.tableFooterView=[self tableFooter];
					
				});
			}
			
		}
		else
		{
			dispatch_async(dispatch_get_main_queue(), ^{
				[self dismissHUDAnimated:YES];
				[self showError:error];
				self.tableView.tableFooterView=[self tableFooter];
				
			});
		}
		
		
	}];
	
	[self.dataTask resume];
	
}


-(void)showError:(NSError*)error
{
	UIAlertController* ac=[UIAlertController alertControllerWithTitle:@"Error" message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
	
	UIAlertAction* action=[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
												 handler:nil];
	
	[ac addAction:action];
	
	[self presentViewController:ac animated:YES completion:nil];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	 if ([segue.identifier isEqualToString:@"MovieDetails"])
	 {
		 
		 MovieDetailsViewControllerSW* md=(MovieDetailsViewControllerSW*) segue.destinationViewController;
		 
		 NSIndexPath* idx = self.tableView.indexPathForSelectedRow;
		 
		 Movie* aMovie = self.movies[idx.row];
		 md.movie = aMovie;
			
		 MovieCell* aCell=(MovieCell*)[self.tableView cellForRowAtIndexPath:idx];
		 
		 md.movieImg=aCell.imgMovie.image;
		
	 }
}




@end
