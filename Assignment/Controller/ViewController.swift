//
//  ViewController.swift
//  Assignment
//
//  Created by Alaxabo on 4/11/17.
//  Copyright © 2017 Alaxabo. All rights reserved.
//

import UIKit

var didChooseLeftTab = "didChooseLeftTab"

class ViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tabButton: UIBarButtonItem!
    
    var searchResults = [Track]()
    
    lazy var tapRecognizer: UITapGestureRecognizer = {
        var recognizer = UITapGestureRecognizer(target:self, action: #selector(ViewController.dismissKeyboard))
        return recognizer
    }()
    
    func dismissKeyboard() {
        searchBar.resignFirstResponder()
    }

    var mediaShow = ["Music Video","Movie","Ebook","Audio Book","Podcast"]
    var mediaTypes = ["musicVideo", "movie", "ebook", "audiobook", "podcast"]
    var didSelected = [Bool](repeating: false, count: 5)
    var selectedMedia: String?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.backgroundColor = UIColor.green
        searchBar.placeholder = "Search"
        if self.revealViewController() != nil{
            tabButton.target = self.revealViewController()
            tabButton.action = #selector(SWRevealViewController.revealToggle(_:))
            //self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.revealViewController().rearViewRevealWidth = 130
        }
        
        if selectedMedia == nil {
            didSelected[0] = true
            selectedMedia = mediaTypes[0]
        } else {
            for i in 0...4 {
                if mediaTypes[i] == selectedMedia {
                    didSelected[i] = true
                }
            }
        }
        for i in 0...4 {
            if didSelected[i] == true {
                let indexPath = IndexPath(row: i, section: 0)
                collectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.centeredHorizontally, animated: true)
            }
        }
        NotificationCenter.default.addObserver(self, selector: #selector(getSelectFromLeftTab(_:)), name: NSNotification.Name(rawValue: didChooseLeftTab), object: nil)
        
//        NotificationCenter.default.addObserver(self, selector: #selector(getUpdateSearchResult(_:)), name: NSNotification.Name(rawValue: didUpdateSearchResult), object: nil)
        
        NetworkManager.shared.delegate = self
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func getUpdateSearchResult(_ notification: Notification){
//        let result = notification.object as? [Track]
//        self.searchResults = result!
//        DispatchQueue.main.async {
//            self.tableView.reloadData()
//            self.tableView.setContentOffset(CGPoint.zero, animated: false)
//        }
//    }
    
    func getSelectFromLeftTab(_ notification: Notification){
        let result = notification.object as? String
        self.selectedMedia = result
        for i in 0...4 {
            didSelected[i] = false
            if mediaTypes[i] == selectedMedia{
                didSelected[i] = true
            }
        }
        collectionView.reloadData()
        searchBarSearchButtonClicked(self.searchBar)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = tableView.indexPathForSelectedRow {
            let destionation = segue.destination as! TrackDetailViewController
            destionation.searchDetailResult = searchResults[indexPath.row]
        }
    }

    func controllSwipe(_ sender: UISwipeGestureRecognizer){
        var current = didSelected.index(of: true)
        if sender.direction == UISwipeGestureRecognizerDirection.left{
            if current! < 4{
                didSelected[current!] = false
                current = current! + 1
                didSelected[current!] = true
                selectedMedia = mediaTypes[current!]
            }
            collectionView.reloadData()
            searchBarSearchButtonClicked(self.searchBar)
        }
        if sender.direction == UISwipeGestureRecognizerDirection.right{
            if sender.direction == UISwipeGestureRecognizerDirection.right{
                if current! > 0{
                    didSelected[current!] = false
                    current = current! - 1
                    didSelected[current!] = true
                    selectedMedia = mediaTypes[current!]
                }
            collectionView.reloadData()
            searchBarSearchButtonClicked(self.searchBar)
            }
        }
    }
}

extension ViewController: NetworkManagerDelegate{
    func didUpdateSearchResult(searchResult: [Track]) {
        self.searchResults = searchResult
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.tableView.setContentOffset(CGPoint.zero, animated: false)
        }
    }
}



extension ViewController: UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "TrackCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! TrackCell
        
        let track = searchResults[indexPath.row]
        cell.artistLabel?.text = track.artist
        cell.titleLabel?.text = track.name
        cell.productImage.image = UIImage(data: track.imageData!)
        // Configure the cell...
        let swipeRightGesture = UISwipeGestureRecognizer(target: self, action: #selector(controllSwipe(_:)))
        swipeRightGesture.direction = UISwipeGestureRecognizerDirection.right
        cell.addGestureRecognizer(swipeRightGesture)
        
        let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(controllSwipe(_:)))
        swipeLeftGesture.direction = UISwipeGestureRecognizerDirection.left
        cell.addGestureRecognizer(swipeLeftGesture)
        
        return cell
    }
}

extension ViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // Dismiss the keyboard
        dismissKeyboard()
        
        if !searchBar.text!.isEmpty {
            let expectedCharSet = CharacterSet.urlQueryAllowed
            let searchTerm = searchBar.text!.addingPercentEncoding(withAllowedCharacters: expectedCharSet)!
            let url = URL(string: "https://itunes.apple.com/search?term=\(searchTerm)&media=\(selectedMedia!)")
            NetworkManager.shared.updateSearchResultFromUrl(url!)
        }
    }
//    func position(for bar: UIBarPositioning) -> UIBarPosition {
//        return .topAttached
//    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        view.addGestureRecognizer(tapRecognizer)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        view.removeGestureRecognizer(tapRecognizer)
    }
    
}

extension ViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mediaTypes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Media", for: indexPath) as! CollectionViewCell
        cell.label.text = mediaShow[indexPath.row]
        if didSelected[indexPath.row] {
            cell.backgroundColor = UIColor.red
        } else {
            cell.backgroundColor = UIColor.white
        }

        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedMedia = mediaTypes[indexPath.row]
        for i in 0...4 {
            didSelected[i] = false
        }
        didSelected[indexPath.row] = true
        collectionView.reloadData()
        if !self.searchBar.text!.isEmpty {
            searchBarSearchButtonClicked(self.searchBar)
        }
    }
}




