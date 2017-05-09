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
    @IBAction func shareAction(_ sender: UIButton) {
        let firstActivityItem = "Text you want"
        let secondActivityItem :String = (searchDetailResult?.name)!
        let thirdActivityItem :String = (searchDetailResult?.trackViewUrl)!
        // If you want to put an image
        
        let activityViewController : UIActivityViewController = UIActivityViewController(
            activityItems: [firstActivityItem, secondActivityItem,thirdActivityItem], applicationActivities: nil)
        
        // This lines is for the popover you need to show in iPad
        activityViewController.popoverPresentationController?.sourceView = sender
        
        // This line remove the arrow of the popover to show in iPad
        activityViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.any
            //UIPopoverArrowDirection.allZeros
        activityViewController.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)
        
        // Anything you want to exclude
        activityViewController.excludedActivityTypes = [UIActivityType.airDrop]
        self.present(activityViewController, animated: true, completion: nil)
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
