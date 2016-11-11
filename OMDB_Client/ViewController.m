//
//  ViewController.m
//  OMDB_Client
//
//  Created by Tomislav Luketic on 10/21/16.
//  Copyright © 2016 Tomislav Luketic. All rights reserved.
//

#import <JavaScriptCore/JavaScriptCore.h>

#import "ViewController.h"
#import "Movie.h"
#import "MovieCell.h"
#import "UIViewController+ProgressHUD.h"
#import "OMDB_Client-Swift.h"

#import "JRSwizzle.h"

/*@protocol SwizzProtocol <JSExport>

-(instancetype)initWithOrigMethod:(SEL)origMethod swizzMethod:(SEL)swizzMethod andClass:(Class)aClass;

@property (nonatomic) SEL origMethod;
@property (nonatomic) SEL swizzMethod;
@property (nonatomic) Class swizzClass;

@end

@interface SwizzJS : NSObject<SwizzProtocol>

@property (nonatomic,assign) SEL origMethod;
@property (nonatomic,assign) SEL swizzMethod;
@property (nonatomic,strong) Class swizzClass;

@end

@implementation SwizzJS

-(instancetype)initWithOrigMethod:(SEL)origMethod swizzMethod:(SEL)swizzMethod andClass:(Class)aClass
{
    self = [super init];
    
    if (self)
    {
        self.origMethod=origMethod;
        self.swizzMethod=swizzMethod;
        self.swizzClass=aClass;
    }
    
    return self;
}


@end
 */

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

/*
+(void)load
{
    
    JSContext *context =[JSContext new];
    
    SwizzJS* swizz=[SwizzJS new];
    
    swizz.swizzClass=NSClassFromString(@"ViewController");
    swizz.origMethod=NSSelectorFromString(@"tableFooter");
    swizz.swizzMethod=NSSelectorFromString(@"tableFooter1");
    
    [context setExceptionHandler:^(JSContext *context, JSValue *value) {
        NSLog(@"WEB JS: %@", value);
    }];

    //context[@"swizz"]=swizz;
    context[@"ViewController"]=NSClassFromString(@"ViewController");
    
    NSString* js=
     @"var doSwizzle = function(origMethod,swizzMethod){ "
    "ViewController.test();"
    " }";
    
    [context evaluateScript:js];

    
    JSValue *jsFunction = context[@"doSwizzle"];
    JSValue *value = [jsFunction callWithArguments:@[@"1",@"2" ]];
    
     
     // calling a JavaScript function
     JSValue *jsFunction = context[@"isValidNumber"];
     JSValue *value = [jsFunction callWithArguments:@[ phone ]];
     
    
    
    [context evaluateScript:js];
    
 
}*/

//+(void)load
//{
//    JSContext *context =[JSContext new];
//    
////    SwizzJS* swizz=[SwizzJS new];
////    
////    swizz.swizzClass=NSClassFromString(@"ViewController");
////    swizz.origMethod=NSSelectorFromString(@"tableFooter");
////    swizz.swizzMethod=NSSelectorFromString(@"tableFooter1");
//    
//    [context setExceptionHandler:^(JSContext *context, JSValue *value) {
//        NSLog(@"WEB JS: %@", value);
//    }];
//    
//    
//     context[@"ViewController"]=NSClassFromString(@"ViewController");
//    
//    NSString* js=
//   // @"var doSwizzle = function(origMethod,swizzMethod){ "
//    //"ViewController.swizzleMethodWithMethod(origMethod,swizzMethod) }";
//    @"ViewController.test();";
//    
//    [context evaluateScript:js];
//    
//    //id s = @selector(tableFooter);
//    
// //   JSValue *jsFunction = context[@"doSwizzle"];
//   // JSValue *value = [jsFunction callWithArguments:@[@"1",s ]];
//    
//    
//
//}

+ (BOOL)swizzleMethod:(SEL)origSel_ withMethod:(SEL)altSel_
{
    return true;
}


//+(void)test
//{
//    
//}
- (void)viewDidLoad {
	[super viewDidLoad];
    
    [ViewController test];

	
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

-(UIView*)tableFooter1
{
    return [UIView new];
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
					[self showError:jsonErr];
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
