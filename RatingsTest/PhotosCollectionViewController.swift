//
//  PhotosCollectionViewController.swift
//  RatingsTest
//
//  Created by Rui Lebre on 1/8/17.
//  Copyright © 2017 Rui Lebre. All rights reserved.
//

import UIKit

class PhotosCollectionViewController: UICollectionViewController {

    var eventId: String = ""
    var images: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        //self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "PhotoCell")

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
    
        let reference = images[indexPath.row].characters.split{$0 == "="}.map(String.init)[0]
        print(images[indexPath.row].characters.split{$0 == "="}.map(String.init)[1])
        cell.photo.image = getImage(imageName: reference)
    
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //lalalala
        
    }
    
    
    
    func getDirectoryPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func getImage(imageName: String) -> UIImage {
        let fileManager = FileManager.default
        let imagePAth = (self.getDirectoryPath() as NSString).appendingPathComponent(eventId + "/" + imageName)
        print(imagePAth)
        if fileManager.fileExists(atPath: imagePAth){
            return UIImage(contentsOfFile: imagePAth)!
        }else{
            print("No Image")
        }
        
        return UIImage()
    }
}
