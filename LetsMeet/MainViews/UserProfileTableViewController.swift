//
//  UserProfileTableViewController.swift
//  LetsMeet
//
//  Created by John Hur on 2021/06/30.
//

import UIKit

class UserProfileTableViewController: UITableViewController {

    //MARK: - IBOutlets
    
    @IBOutlet weak var sectionOneView: UIView!
    @IBOutlet weak var sectionTwoView: UIView!
    @IBOutlet weak var sectionThreeView: UIView!
    @IBOutlet weak var sectionFourView: UIView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var dislikeButtonOutlet: UIButton!
    @IBOutlet weak var likeButtonOutlet: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var aboutTextView: UITextView!
    
    @IBOutlet weak var professionLabel: UILabel!
    @IBOutlet weak var jobLabel: UILabel!
    
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var lookingForLabel: UILabel!
    
    
    
    
    //MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBackgrounds()
        hideActivityIndicator()
        
    }
    
    //MARK: - IBActions
    
    
    //MARK: - TableViewDelegate
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // Title 반환을 원하지 않기 때문에 "" return
        return ""
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return section == 0 ? 0 : 10
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView()
        view.backgroundColor = .clear
        
        
        return view
    }
    
    
    //MARK: - Setup UI
    private func setupBackgrounds() {
// cornerRadius로 사용자 정보를 둥글게 처리함
        sectionOneView.clipsToBounds = true
        sectionOneView.layer.cornerRadius = 30
        sectionOneView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        sectionTwoView.layer.cornerRadius = 10
        sectionThreeView.layer.cornerRadius = 10
        sectionFourView.layer.cornerRadius = 10
        
        
        
    }
    
    //MARK: - Activity indicator
    
    private func showActivityIndicator() {
        self.activityIndicator.startAnimating()
        self.activityIndicator.isHidden = false
        
    }
    
    private func hideActivityIndicator() {
        self.activityIndicator.stopAnimating()
        self.activityIndicator.isHidden = true
        
    }
    

}
