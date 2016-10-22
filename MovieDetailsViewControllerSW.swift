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
	
	
	var imdbID : String!
	var movieTitle : String!
	var movieImg : UIImage!
	
	let urlSession : URLSession = URLSession.init(configuration: URLSessionConfiguration.default)
	
	let baseURL = "http://www.omdbapi.com/?i=%@&plot=short"
	
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		imgMovie.image=movieImg
		
		self.lblTitle.text=movieTitle + " #"
		
		//self.lblTitle.sizeToFit()
		
		let ns = self.lblTitle.text as NSString?
		let aRange = ns?.range(of: "#")
		
		
		 var rect = self.lblTitle.boundingRectForCharacterRange(range: aRange!)
		
		 rect = self.view.convert(rect!, from: self.lblTitle)
		
		 let ai = UIActivityIndicatorView.init(frame: rect!)
		
		 ai.startAnimating()
		
		 self.view.addSubview(ai)
		
		
		
		
		self.loadMovieData()

	}

	
	func loadMovieData() {
		
		let url = URL.init(string: String.init(format: baseURL, imdbID))
		
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
						
						self.refreshMovieUI(details: details)
					}
					
				}
				catch
				{
					
				}
				
				
			}
			
		}
		
		dataTask.resume()
		
	}
	
	
	func refreshMovieUI(details : MovieDetails)
	{
		self.lblTitle.text=details.Title + " (" + details.Year + ")"
		self.lblDirector.text=details.Director
		self.lblWriters.text=details.Writer
		self.lblStars.text=details.Actors
		
		self.lblInfo.text=details.Rated + " | " + details.Runtime+" | " + details.Genre + " | " + details.Released +
		" (" + details.Country + ")"
		
	}
	
	
	
}



extension UILabel {
	func boundingRectForCharacterRange(range: NSRange) -> CGRect? {
		
		guard let attributedText = attributedText else { return nil }
		
		let textStorage = NSTextStorage(attributedString: attributedText)
		let layoutManager = NSLayoutManager()
		
		textStorage.addLayoutManager(layoutManager)
		
		let textContainer = NSTextContainer(size: bounds.size)
		textContainer.lineFragmentPadding = 0.0
		
		layoutManager.addTextContainer(textContainer)
		
		var glyphRange = NSRange()
		
		// Convert the range for glyphs.
		layoutManager.characterRange(forGlyphRange: range, actualGlyphRange: &glyphRange)
		
		return layoutManager.boundingRect(forGlyphRange: glyphRange, in: textContainer)
		
	}
}
