//
//  PhotosViewController.swift
//  Nearby
//
//  Created by Dua Almahyani on 06/12/2020.
//

import UIKit

class PhotosViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let mainVC = MapViewController()
    private var photoModel = PhotoModel()
    var api = FlickrAPI()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        loadData()
        
        
        view.backgroundColor = UIColor(named: "BGColor")
    }
    
    
    private func loadData() {
        photoModel.fetchPhotosData { [weak self] in
            print("welp")
            self?.tableView.dataSource = self
            self?.tableView.reloadData()
        }
    }
    

}

extension PhotosViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photoModel.numberOfRowsInSections(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "photosCell", for: indexPath) as! PhotosTableViewCell
        let item = photoModel.cellForRowAt(indexPath: indexPath)
        cell.setCellWithValuesOf(item)
        return cell
    }
    
    
    
}
