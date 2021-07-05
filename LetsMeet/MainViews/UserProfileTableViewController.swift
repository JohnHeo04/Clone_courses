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
    
    //MARK:- Vars
    var userObject: FUser?
    
    
    var allImages: [UIImage] = []
    
    
    
    
    //MARK: - View Lifecycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        pageControl.hidesForSinglePage = true
        
        if userObject != nil {
            showUserDetails()
            loadImages()
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 카드뷰를 선택하면 아래의 프린트 문구가 콘솔창에 발생
//        print("showing user ", userObject?.username)
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
    
    
    //MARK: - Show user profile
    private func showUserDetails() {
        
        aboutTextView.text = userObject!.about
        professionLabel.text = userObject!.profession
        jobLabel.text = userObject!.jobTitle
        genderLabel.text = userObject!.isMale ? "Male" : "Female"
        heightLabel.text = String(format: "%.2f", userObject!.height)
        lookingForLabel.text = userObject!.lookingFor
        
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
    
    //MARK: - Load Images
    private func loadImages() {
        
        let placeholder = userObject!.isMale ? "mPlaceholder" : "fPlaceholder"
        let avatar = userObject!.avatar ?? UIImage(named:  placeholder)
        
        allImages = [avatar!]
        //show page control
        
        self.collectionView.reloadData()
        
        if userObject!.imageLinks != nil && userObject!.imageLinks!.count > 0 {
            
            showActivityIndicator()
            
            FileStorage.downloadImages(imageUrls: userObject!.imageLinks!) { (returnedImages) in
                
                self.allImages += returnedImages as! [UIImage]
                //show page control
                
                DispatchQueue.main.async {
                    self.hideActivityIndicator()
                    self.collectionView.reloadData()
                    
                }
                
                self.collectionView.reloadData()
                
            }
        } else {
            hideActivityIndicator()
            
        }
        
    }
    

}
