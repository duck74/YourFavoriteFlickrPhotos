//
//  FavViewController.swift
//  FavFlickrPhotos
//
//  Created by Koss on 05/03/16.
//  Copyright © 2016 mine. All rights reserved.
//

import UIKit

class FavViewController: UIViewController {

    
    @IBOutlet weak var favFullImage: UIImageView!
    
   
    @IBOutlet weak var imageTitle: UILabel!
    
    var imgTitle: String = ""
    
    var imageFav: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(imageTitle)
        // Do any additional setup after loading the view.
        imageTitle.text = imgTitle
        favFullImage.image = imageFav
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
