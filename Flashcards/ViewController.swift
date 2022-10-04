//
//  ViewController.swift
//  Flashcards
//
//  Created by Cece Che Tita on 9/13/22.
//

import UIKit

class ViewController: UIViewController {

  
    @IBOutlet weak var backLabel: UILabel!
    @IBOutlet weak var frontLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func didTapFlashcard(_ sender: Any) {
        frontLabel.isHidden = true
    }
    
    func updateFlashcard(question: String, answer: String) {
        frontLabel.text = question
        backLabel.text = answer
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender:Any?) {
            // We know the destination of the segue is Navigation Controller
            let navigationController = segue.destination as! UINavigationController
            
            // We know the navigation Controller only contains a Creation View Controller
            let creationController = navigationController.topViewController as! CreationViewController
            
            // We set the flashcardsController property to self
             creationController.flashcardsController = self
        }
    
}
