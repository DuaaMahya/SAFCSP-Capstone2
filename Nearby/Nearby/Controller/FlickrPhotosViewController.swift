//
//  FlickrPhotosViewController.swift
//  Nearby
//
//  Created by Dua Almahyani on 02/12/2020.
//

import UIKit

class FlickrPhotosViewController: UIViewController {
    

    @IBOutlet weak var collectionView: UICollectionView!
    
    let mainVC = MapViewController()
    private var photoModel = PhotoModel()
    var api = FlickrAPI()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        loadData()
    }
    
    
    private func loadData() {
        photoModel.fetchPhotosData { [weak self] in
            print("welp")
            self?.collectionView.dataSource = self
            self?.collectionView.reloadData()
        }
    }
    

}

extension FlickrPhotosViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("setction:\(section)")
        return photoModel.numberOfRowsInSections(section: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! FlickrPhotosCollectionViewCell
        
        let item = photoModel.cellForRowAt(indexPath: indexPath)
        cell.setCellWithValuesOf(item)
        return cell
    }
}
