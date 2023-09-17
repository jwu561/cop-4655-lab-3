//
//  AlbumsViewController.swift
//  lab-tunley
//
//  Created by student on 9/17/23.
//

import UIKit
import Nuke





class AlbumsViewController: UIViewController, UICollectionViewDataSource {
    
    
  
    
    var albums: [Album] = []
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // the number of items shown should be the number of albums we have.
        albums.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Get a collection view cell (based in the identifier you set in storyboard) and cast it to our custom AlbumCell
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumCell", for: indexPath) as! AlbumCell

            // Use the indexPath.item to index into the albums array to get the corresponding album
            let album = albums[indexPath.item]

            // Get the artwork image url
            let imageUrl = album.artworkUrl100

            // Set the image on the image view of the cell
        Nuke.loadImage(with: imageUrl, into: cell.albumImageView)

            return cell
    }
    

    
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    
    


    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        collectionView.dataSource = self
        
        // Create a search URL for fetching albums (`entity=album`)
        let url = URL(string: "https://itunes.apple.com/search?term=blackpink&attribute=artistTerm&entity=album&media=music")!
        let request = URLRequest(url: url)

        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in

            // Handle any errors
            if let error = error {
                print("❌ Network error: \(error.localizedDescription)")
            }

            // Make sure we have data
            guard let data = data else {
                print("❌ Data is nil")
                return
            }

           
            
            // Create a JSON Decoder
            let decoder = JSONDecoder()
            do {
                // Try to parse the response into our custom model
                let response = try decoder.decode(AlbumSearchResponse.self, from: data)
                let albums = response.results
                
                
                
                

                
                DispatchQueue.main.async {
                    self?.albums = albums
                    self?.collectionView.reloadData()
                }






               // print(albums)
            } catch {
                print(error.localizedDescription)
            }


        }

        // Initiate the network request
        task.resume()


        
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
