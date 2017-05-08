//
//  TrackDetailViewController.swift
//  Assignment
//
//  Created by Alaxabo on 4/17/17.
//  Copyright © 2017 Alaxabo. All rights reserved.
//

import UIKit

class TrackDetailViewController: UIViewController {
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var artist: UILabel!
    
    var searchDetailResult: Track?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        productImage.image = UIImage(data: (searchDetailResult?.imageData)!)
        name.text = searchDetailResult?.name
        artist.text = searchDetailResult?.artist
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: .none)
        ViewController.load()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
