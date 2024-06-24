//
//  ViewControllerExtension.swift
//  MarvelApp
//
//  Created by DISMOV on 04/05/24.
//

import Foundation

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
        
        if (offsetY > (contentHeight - scrollviewHeight)) && (!characterManager.maxItemsLoaded && !characterManager.isLoading ){
            print("calling API...")
            self.characterManager.isLoading = true
            let queryString = keyLoader.getQueryString(limit: Constants.numberOfItemsRequested, offset: self.characterManager.offset)
                print("qs:",queryString)
            
            self.characterManager.loadCharacterData(queryString: queryString){
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    print("char com:",self.characterManager.countCharacter())
                    print("actual offset: ", self.characterManager.offset)
                    self.characterManager.offset = self.characterManager.countCharacter()
                    print("new offset: ", self.characterManager.offset)
                    self.characterManager.isLoading = false
                }
            }
        }
        else{
            print("Don't call API...")
        }
    }
}
