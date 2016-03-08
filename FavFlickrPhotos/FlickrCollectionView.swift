//
//  FlickrCollectionView.swift
//  FavFlickrPhotos
//
//  Created by Koss on 04/03/16.
//  Copyright © 2016 mine. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

struct Seccion {
    var nombre: String
    var imagenes: [UIImage]
    var imageFlickrURL: String
    var saveDate: NSDate
    
    init(nombre: String, imagenes: [UIImage], imageFlickrUrl: String, saveDate: NSDate){
        self.nombre = nombre
        self.imagenes = imagenes
        self.imageFlickrURL = imageFlickrUrl
        self.saveDate = saveDate
    }
}


class FlickrCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    @IBOutlet weak var searchText: UITextField!
    @IBOutlet weak var colView: FlickrCollectionView!
    
    var imagenes = [Seccion]()
    var selectedIndexPaths = [NSIndexPath]()
    var rowIndex = [Int]()
    var urlString:String?
    var newItems = [FeedItem]()
    
    /*var selectedIndexes = [NSIndexPath]() {
        didSet {
            collectionViewFlickr.reloadData()
        }
    }*/
    
    @IBOutlet weak var collectionViewFlickr: UICollectionView!
    
    @IBAction func searchTextAction(sender: AnyObject) {
        let currentDate = NSDate()
        let sText = searchText.text! as String
        let flickrImg = searchFlickr(sText)
        let seccion = Seccion(nombre: sText, imagenes: flickrImg, imageFlickrUrl: urlString!, saveDate: currentDate)
        imagenes.removeAll()
        //imagenes.append(seccion)
        imagenes.insert(seccion, atIndex: 0)
        print("IMAGEs", imagenes[0].imageFlickrURL)
        searchText.text = nil
        
        self.collectionViewFlickr.reloadData()
        sender.resignFirstResponder()
        print(newItems)
    }
    
    func searchFlickr(termino: String) -> [UIImage] {
        //print("nochwas")
        newItems = []
        var imgs = [UIImage]()
        let urls = "https://api.flickr.com/services/feeds/photos_public.gne?tags=" + termino + "&format=json&nojsoncallback=1"
        urlString = urls.stringByReplacingOccurrencesOfString(" ", withString: "")
        //urlString = "http://localhost/dog.txt"
        //print("urlstring", urlString)
        //let urls = "https://ajax.googleapis.com/ajax/services/search/images?v=1.0&rsz=8&q="
        let url = NSURL(string: urlString!)
        
        let datos = NSData(contentsOfURL: url!)
        let data = fixJsonData(datos!)
       
        do {
            let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments) as? Dictionary<String,AnyObject>
            let currentDate = NSDate()
            let resultados = json
            
            let elementos = resultados!["items"] as? Array<AnyObject>
            
            for elemento in elementos! {
                
                guard let itemDict = elemento as? Dictionary<String,AnyObject> else {
                    continue
                }
                //let img_urls = (elemento as! NSDictionary)//["media"] as! String
                guard let media = itemDict["media"] as? Dictionary<String, AnyObject> else {
                    continue
                }
                guard let img_urls = media["m"] as? String else {
                    continue
                }
                //print(img_urls)
                guard let img_url = NSURL(string: img_urls) else {
                    continue
                }
                //print(img_url)
                let img_datos = NSData(contentsOfURL: img_url)
                if img_datos != nil {
                    if let imagen = UIImage(data: img_datos!) {
                        imgs.append(imagen)
                    }
                }
                else {
                    //print("Nix gefunden")
                }
                let title = itemDict["title"] as? String
                newItems.append(FeedItem(title: title ?? "(no title)", imageURL: img_url, saveDate: currentDate))
                //print(newItems[0].title)
            }
            
        }
        catch let myJSONError {
            let alert = UIAlertController(title: "Alert", message: "No pictures found or JSON error", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
            self.window?.rootViewController?.presentViewController(alert, animated: true, completion: nil)
            print(myJSONError)
        }
        
        return imgs
    }
    
    func fixJsonData (data: NSData) -> NSData {
        var dataString = String(data: data, encoding: NSUTF8StringEncoding)!
        dataString = dataString.stringByReplacingOccurrencesOfString("\\'", withString: "'")
        return dataString.dataUsingEncoding(NSUTF8StringEncoding)!
        
    }
    
    func viewDidLoad() {
        viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Register cell classes
        self.colView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        // Do any additional setup after loading the view.
        //self.searchText.delegate = self;
        searchText.autocorrectionType = .Yes
        searchText.autocorrectionType = .No
        self.collectionViewFlickr.reloadData()
    }
    
    func didReceiveMemoryWarning() {
        didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSectionsInCollectionView(colView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        print("number of sections " , imagenes.count)
        //self.collectionViewFlickr.reloadSections(imagenes.count)
        return imagenes.count
    }
    
    func collectionView(colView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        print("number of items in section", imagenes[section].imagenes.count)
        return imagenes[section].imagenes.count
    }
    
    func collectionView(colView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = colView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! ImageCell
        // Configure the cell
        cell.flickrImage.image = imagenes[indexPath.section].imagenes[indexPath.item]
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let cell = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "Cell2", forIndexPath: indexPath) as! SearchTermLabel
        cell.searchTerm.text = "Searched for: " + imagenes[indexPath.section].nombre
        
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
    return true
    }
    
    /*
    // Uncomment this method to specify if the specified item should be selected
    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        let cell = collectionViewFlickr.cellForItemAtIndexPath(indexPath)
        if cell?.selected == true {
            print("ich bin so selected")
            return true
        }
        else {
            return false
        }
        
    }*/
    
    func collectionView(colView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = colView.cellForItemAtIndexPath(indexPath)
        let item = newItems[indexPath.row]
        if cell!.selected == true {
            cell!.backgroundColor = UIColor.grayColor()
            print("Cell \(indexPath.row) row selected")
            print("Cell \(indexPath.section) section selected")
            //print(cell)
            let optionMenu = UIAlertController(title: nil, message: "Save image to favorites?", preferredStyle: .ActionSheet)
            let saveAction = UIAlertAction(title: "Save", style: .Default, handler: {
                (alert: UIAlertAction!) -> Void in
                print("File Saved")
                //save to db
                print("ITEM ", item.title)
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                appDelegate.dataController.addImageToDB(item)
                cell?.selected = false
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
                (alert: UIAlertAction!) -> Void in
                print("Cancelled")
                cell?.selected = false
                cell?.backgroundColor = UIColor.whiteColor()
            })
            optionMenu.addAction(saveAction)
            optionMenu.addAction(cancelAction)
            
            self.window?.rootViewController?.presentViewController(optionMenu, animated: true, completion: nil)
        }
    }
    

    /*func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        var cell = collectionView.cellForItemAtIndexPath(indexPath)
        if cell!.selected == true {
        
        }
        print(indexPath.row)
        collectionViewFlickr.selectItemAtIndexPath(indexPath, animated: true, scrollPosition:
            UICollectionViewScrollPosition.None)
            //selectRowAtIndexPath(indexPath, animated: true, scrollPosition: UITableViewScrollPosition.None)
        let selectedItem = indexPath.item
        if selectedItem != 0 {
            let cell = collectionView.cellForItemAtIndexPath(indexPath)
            cell!.layer.borderWidth = 2.0
            cell!.layer.borderColor = UIColor.grayColor().CGColor
        }
        
        var listcount = 0
        if let list = collectionViewFlickr.indexPathsForSelectedItems() {
            //print(list)
            let cell = collectionView.cellForItemAtIndexPath(indexPath)
            cell!.layer.borderWidth = 2.0
            cell!.layer.borderColor = UIColor.grayColor().CGColor
            listcount = Int(list.count)
            print(list.count)
            rowIndex = list.map{$0.row}
            print(rowIndex)
        }
        
        }*/
    /*func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath) {
       let cell = collectionView.cellForItemAtIndexPath(indexPath)
        cell!.backgroundColor = UIColor.blackColor()
        cell!.highlighted = true
        cell!.selected = true
        //print("hightlighted")
        //print(cell?.selected)
    }*/
    
    /*func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        if let index = selectedIndexPaths.indexOf(indexPath) {
            let cell = collectionView.cellForItemAtIndexPath(indexPath)
            cell!.layer.removeAllAnimations()
            selectedIndexPaths.removeAtIndex(index)
        }

    }*/
    
    
    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
    return true
    }
    
     func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
    return false
    }
    
    func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }*/
    
    
}


