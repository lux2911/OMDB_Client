//
//  MovieDetailsViewControllerSW.swift
//  OMDB_Client
//
//  Created by Tomislav Luketic on 10/22/16.
//  Copyright © 2016 Tomislav Luketic. All rights reserved.
//

import UIKit

@objc class MovieDetailsViewControllerSW: UIViewController {

	
	@IBOutlet weak var imgMovie: UIImageView!
	@IBOutlet weak var lblTitle: UILabel!
	@IBOutlet weak var lblRating: UILabel!
	
	@IBOutlet weak var lblInfo: UILabel!
	
	@IBOutlet weak var lblDirector: UILabel!
	@IBOutlet weak var lblWriters: UILabel!
	@IBOutlet weak var lblStars: UILabel!
	
	@IBOutlet weak var scrollView: UIScrollView!
	@IBOutlet weak var containerView: UIView!
	
	
	var movie : Movie!
	var movieImg : UIImage!
	
	let urlSession : URLSession = URLSession.init(configuration: URLSessionConfiguration.default)
	
	let baseURL = "http://www.omdbapi.com/?i=%@&plot=short"
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		imgMovie.image=movieImg
		
		self.lblTitle.text=movie.title + " (" + movie.year + ")"
		
		
		self.loadMovieData()
		
		self.scrollView.frame = self.containerView.frame
		
		//self.scrollView.contentSize =
		
		
		
	}
	
	override func viewDidLayoutSubviews() {
		
		super.viewDidLayoutSubviews()
		
		/*var size = self.containerView.frame.size
		
		size.height += 200
		
		
		
		self.scrollView.contentSize = size*/
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		
		if (segue.identifier == "ShowImdb")
		{
			let vc = segue.destination as! ImdbViewController
			
			vc.imdbID = movie.imdbID
			
		}
	}

	
	func loadMovieData() {
		
		
		self.showSpinnerInWindow()
		
		let url = URL.init(string: String.init(format: baseURL, movie.imdbID))
		
		let dataTask = self.urlSession.dataTask(with: url!) { (Data, URLResponse, Error) in
			
			if (Error == nil)
			{
				
				
				do
				{
					let dict : Dictionary =  try JSONSerialization.jsonObject(with: Data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String,AnyObject>
					let details  = MovieDetails.init()
					
					for (key,value) in dict
					{
						
						if (details.responds(to: Selector(key)))
						{
							details.setValue(value, forKey: key)
						}
						
						
					}
					
					DispatchQueue.main.async {
						self.dismissHUD(animated: true)
						self.refreshMovieUI(details: details)
					}
					
				}
				catch
				{
					DispatchQueue.main.async {
						self.dismissHUD(animated: true)
						self.showError(error: error)
					}
				}
				
				
			}
			else
			{
				DispatchQueue.main.async {
					self.dismissHUD(animated: true)
					self.showError(error: Error!)
				}
			}
			
		}
		
		dataTask.resume()
		
	}
	
	
	func showError(error : Error)
	{
		let ac = UIAlertController.init(title: "Error", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
		let alert = UIAlertAction.init(title: "OK", style: UIAlertActionStyle.default, handler: nil)
		
		ac.addAction(alert)
		
		self.present(ac, animated: true, completion: nil)
		
		
	}
	
	
	func refreshMovieUI(details : MovieDetails)
	{
		
		self.lblDirector.text=details.Director
		self.lblWriters.text=details.Writer
		self.lblStars.text=details.Actors
		
		self.lblInfo.text=details.Rated + " | " + details.Runtime+" | " + details.Genre + " | " + details.Released +
		" (" + details.Country + ")"
		
	}
	
	
	
}





