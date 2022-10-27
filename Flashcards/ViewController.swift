//
//  ViewController.swift
//  Flashcards
//
//  Created by Cece Che Tita on 9/13/22.
//

import UIKit

struct Flashcard {
    var question: String
    var answer: String
}

class ViewController: UIViewController {

  
    @IBOutlet weak var card: UIView!
    @IBOutlet weak var backLabel: UILabel!
    @IBOutlet weak var frontLabel: UILabel!
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    // Array to hold our flashcards
    var flashcards = [Flashcard]()
    
    // Current flashcard index
    var currentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       
        
        // Read saved flashcards
        readSavedFlashcards()
        
        //Adding our initial flashcard if needed
            if flashcards.count == 0 {
                updateFlashcard(question: "What's the capital of Brazil?", answer: "Brasilia")
            } else {
                updateLabels()
                updateNextPrevButtons()
        }
        
        
    }

    @IBAction func didTapFlashcard(_ sender: Any) {
        flipFlashcard()
    }
    
    func flipFlashcard () {
        UIView.transition(with: card, duration: 0.3, options: .transitionFlipFromRight, animations: {
            self.frontLabel.isHidden = !self.frontLabel.isHidden
            })
    }
    
    func animateCardOut() {
        UIView.animate(withDuration: 0.3, animations: {
            self.card.transform = CGAffineTransform.identity.translatedBy(x: -300.0, y: 0.0)}, completion: {finished in
                
                //Update Labels
                self.updateLabels()
                
                //Run other animation
                self.animateCardIn()
            })
    }
    
    func animateCardIn() {
        // Start on the right side (don't animate this)
            card.transform = CGAffineTransform.identity.translatedBy(x: -300.0, y: 0.0)
        
        // Animate card going back to its original position
        UIView.animate(withDuration: 0.3) {
            self.card.transform = CGAffineTransform.identity
        }
    }
    
    @IBAction func didTapOnPrev(_ sender: Any) {
        //animate card
        animateCardIn()
        
        // Decrease current index
        currentIndex = currentIndex - 1
        
        // Update labels
        updateLabels()
        
        // Update buttons
        updateNextPrevButtons()
        
    }
    
    
    @IBAction func didTapOnNext(_ sender: Any) {
        
        // Increase current index
        currentIndex = currentIndex + 1
        
        // Update labels
        updateLabels()
        
        // Update buttons
        updateNextPrevButtons()
        
        //animate card
        animateCardOut()
        
       
        
        
    }
    
    func updateNextPrevButtons() {
        // Disable next button if at the end
        if currentIndex == flashcards.count - 1 {
            nextButton.isEnabled = false
        } else {
            nextButton.isEnabled = true
        }
        
        // Disable prev button if at the beginning
        if currentIndex == flashcards.count - 1 {
            prevButton.isEnabled = true
        } else {
            prevButton.isEnabled = false
        }
    }
        
    func updateLabels() {
        // Get current flashcard
        let currentFlashcard = flashcards [currentIndex]
        
        // Update labels
        frontLabel.text = currentFlashcard.question
        backLabel.text = currentFlashcard.answer
    }
    
    func updateFlashcard(question: String, answer: String) {
        let flashcard = Flashcard(question: question, answer: answer)
        frontLabel.text = question
        backLabel.text = answer
        
        // Adding flashcard in the flashcards array
        flashcards.append(flashcard)
        print("Added a new FlashCard, take a look --> ", flashcards)
        
        //Logging to the console
        print("Added new flashcard")
        print("We now have \(flashcards.count) flashcards")
        
        // Update current index
        currentIndex = flashcards.count - 1
        print("Our current index is \(currentIndex)")
        
        // Update buttons
        updateNextPrevButtons()
        
        // Update labels
        updateLabels()
        
        // Save flashcards
        saveAllFlashcardsToDisk()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender:Any?) {
            // We know the destination of the segue is Navigation Controller
            let navigationController = segue.destination as! UINavigationController
            
            // We know the navigation Controller only contains a Creation View Controller
            let creationController = navigationController.topViewController as! CreationViewController
            
            // We set the flashcardsController property to self
             creationController.flashcardsController = self
        }
    
    
    
    func saveAllFlashcardsToDisk() {
        
        // From flashcard array to dictionary arrray
        let dictionaryArray = flashcards.map { (card) -> [String:String] in return ["question": card.question, "answer": card.answer]
        }
        
        // Save array on disk using UserDefaults
        UserDefaults.standard.set(dictionaryArray, forKey: "flashcards")
        
        // Log it
        print("Flashcards saved to UserDefaults")
        
            
    }
    func readSavedFlashcards() {
        // Read dictionary array from disk (if any)
        if let dictionaryArray = UserDefaults.standard.array(forKey: "flashcards") as? [[String: String]] {
            
            // In here we know for sure we have a dictionary array
            let savedCards = dictionaryArray.map { dictionary -> Flashcard in
                return Flashcard(question: dictionary["question"]!, answer: dictionary["answer"]!)
            }
            //Put all thes cards in our flashcards array
            flashcards.append(contentsOf: savedCards)
        }
    }
}
