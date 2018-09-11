//
//  FlickrPhotosCollectionViewController.swift
//  FlickrSearch
//
//  Created by shkurta on 11/09/2018.
//  Copyright © 2018 shkurta. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class FlickrPhotosCollectionViewController: UICollectionViewController {
    
    //MARK: - Proporties
    fileprivate let reuseIdentifier = "FlickrCell"
    fileprivate let sectionInsets = UIEdgeInsets(top: 50, left: 20, bottom: 50, right: 20)
    fileprivate var searches = [FlickrSearchResults]() // nje array qe do te i keep te gjitha search-at ne app
    fileprivate let flickr = Flickr() // nje referenc e objektit qe do te bej searchin...
    fileprivate let itemsForRow: CGFloat = 3
}


//MARK: - extesnion
private extension FlickrPhotosCollectionViewController {
    func photoForIndexPath(indexPath: IndexPath) -> FlickrPhoto {
        return searches[(indexPath as NSIndexPath).section].searchResults[(indexPath as IndexPath).row]
    }
}


//MARK: - extnesion
extension FlickrPhotosCollectionViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        //1
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        textField.addSubview(activityIndicator)
        activityIndicator.frame = textField.bounds
        activityIndicator.startAnimating()
        
        
        flickr.searchFlickrForTerm(textField.text!) {
            (results, error) in
            
            
            DispatchQueue.main.async(){
            activityIndicator.removeFromSuperview()
            }
            
            if let error = error {
                print("Error Searching: \(error)")
                return
            }
            
            if let results = results {
                print("Found \(results.searchResults.count) matching \(results.searchTerm)")
                self.searches.insert(results, at: 0)
               
                self.collectionView?.reloadData()
            }
        }
        
        
        textField.text = nil
        textField.resignFirstResponder()
        return true 
    }
}

//MARK: - Extnesion
extension FlickrPhotosCollectionViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return searches.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searches[section].searchResults.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //1
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FlickrPhotoCellCollectionViewCell
        
        //2
        let flickrPhoto = photoForIndexPath(indexPath: indexPath)
        cell.backgroundColor = UIColor.white
        
        //3
        cell.imageView.image = flickrPhoto.thumbnail
        return cell
    }
}


//MARK: -Extension
extension FlickrPhotosCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    //1
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //2
        let paddingSpace = sectionInsets.left * (itemsForRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth/itemsForRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    //3
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    //4
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
 
}
