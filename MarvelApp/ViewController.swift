//
//  ViewController.swift
//  MarvelApp
//
//  Created by Rafael González on 30/04/24.
//

import UIKit
import SDWebImage

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var keyLoader = KeyLoader.shared
    var characterManager: CharacterServiceManager?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        print(keyLoader.getAPIParams())
//        print(keyLoader.getQueryString())
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        characterManager = CharacterServiceManager()
        
        characterManager?.loadCharacterData(queryString: keyLoader.getQueryString(limit: Constants.numberOfItemsRequested, offset: 0)) {
            DispatchQueue.main.async {
                print("Completion executed!!")
                self.collectionView.reloadData()
                self.characterManager?.offset = (self.characterManager?.countCharacter())!
            }
        }
    }
}

extension ViewController : UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (characterManager?.countCharacter())!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CharacterCell
        cell.name.text = characterManager?.getCharacter(at: indexPath.row).name
        let url = URL(string: (characterManager?.getCharacter(at: indexPath.row).thumbnail.url)!)
        cell.image.sd_setImage(with: url)
        
        return cell
    }
}

extension ViewController : UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        ////        size of scrollview content
        //        print("contentSize.height", scrollView.contentSize.height)
        ////        screen's available space for scrollview element
        //        print("bounds.height:", scrollView.bounds.height)
        ////        contentOffset y = contentSize.height - bounds.height
        //        print("contentOffset y:", scrollView.contentOffset.y)
                
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let scrollviewHeight = scrollView.bounds.height
        
        if (offsetY > (contentHeight - scrollviewHeight)) && (!characterManager!.maxItemLoaded && !characterManager!.isLoading ){
            print("calling API...")
            self.characterManager!.isLoading = true
            let queryString = keyLoader.getQueryString(limit: Constants.numberOfItemsRequested, offset: self.characterManager!.offset)
                print("qs:",queryString)
            
            self.characterManager!.loadCharacterData(queryString: queryString){
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    print("char com:",self.characterManager!.countCharacter())
                    print("actual offset: ", self.characterManager!.offset)
                    self.characterManager!.offset = self.characterManager!.countCharacter()
                    print("new offset: ", self.characterManager!.offset)
                    self.characterManager!.isLoading = false
                }
            }
        }
        else{
            print("Don't call API...")
        }
    }
}
