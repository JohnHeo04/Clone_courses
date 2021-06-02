//
//  ProfileTableViewController.swift
//  LetsMeet
//
//  Created by John Hur on 2021/06/02.
//

import UIKit

class ProfileTableViewController: UITableViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var profileCellBackgroundView: UIView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameAgeLabel: UILabel!
    @IBOutlet weak var cityCountryLabel: UILabel!
    @IBOutlet weak var aboutMeTextView: UITextView!
    
    @IBOutlet weak var jobTextField: UITextField!
    @IBOutlet weak var educationTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var lookingForTextField: UITextField!
    
    
    //MARK: - ViewLifeCycle
    @IBAction func settingsButtonPressed(_ sender: Any) {
        
    }
    
    @IBAction func cameraButtonPressed(_ sender: Any) {
        
    }
    
    @IBAction func editButtonPressed(_ sender: Any) {
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    //MARK: - IBActions
    
}
