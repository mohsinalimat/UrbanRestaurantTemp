//
//  EditProfileViewController.swift
//  DinedooRestaurant
//
//  Created by Nagaraju on 27/10/18.
//  Copyright © 2018 casperonIOS. All rights reserved.
//

import UIKit
import SDWebImage

class EditProfileViewController: UIViewController {
    @IBOutlet weak var profilePicImgView: UIImageView!
    @IBOutlet weak var offerBtn: UIButton!
    @IBOutlet weak var offerTypeBtn: UIButton!
    @IBOutlet weak var offersViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollviewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var cuisineTxt: UITextField!
    @IBOutlet weak var phoneNumberTxt: UITextField!
    @IBOutlet weak var ownerTxt: UITextField!
    
    @IBOutlet weak var addressTxt: UITextField!
    @IBOutlet weak var localityTxt: UITextField!
    @IBOutlet weak var flotNoTxt: UITextField!
    @IBOutlet weak var landmarkTxt: UITextField!
    @IBOutlet weak var offerAmtTxt: UITextField!
    @IBOutlet weak var targetAmtTxt: UITextField!
    @IBOutlet weak var maxOffAmtTxt: UITextField!
    
    
    var isOffersExpanded = false
    override func viewDidLoad() {
        super.viewDidLoad()

        offerTypeBtn.layer.cornerRadius = 5.0
        offerTypeBtn.layer.borderWidth = 1.0
        offerTypeBtn.layer.borderColor = #colorLiteral(red: 0.8723144531, green: 0.8723144531, blue: 0.8723144531, alpha: 1)
        
        offerBtn.layer.cornerRadius = 3.0
        offerBtn.layer.borderWidth = 1.0
        offerBtn.layer.borderColor = #colorLiteral(red: 0.7879231572, green: 0.7879231572, blue: 0.7879231572, alpha: 1)
        
        profilePicImgView.layer.borderWidth = 3
        profilePicImgView.layer.borderColor = #colorLiteral(red: 0.7879231572, green: 0.7879231572, blue: 0.7879231572, alpha: 1)
        
         getRestarentProfile()
    }
    
    
    func getRestarentProfile(){
        Themes.sharedInstance.activityView(View: self.view)
        let restarentInfo = UserDefaults.standard.object(forKey: "restaurantInfo") as! NSDictionary
        let data = restarentInfo.object(forKey: "data") as! NSDictionary
        
        let param = [
            "id": data.object(forKey: "subId"),
            ]
        
        print("getProfileURl ----->>> ", Constants.urls.getProfileURl)
        print("param  ----->>> ", param)
        
        URLhandler.postUrlSession(urlString: Constants.urls.getProfileURl, params: param as [String : AnyObject], header: [:]) { (dataResponse) in
            print("Profile response ----->>> ", dataResponse.json)
            Themes.sharedInstance.removeActivityView(View: self.view)
            if dataResponse.json.exists(){
                GlobalClass.restModel = RestaurantModel(fromJson: dataResponse.json)
                self.updateUI()
            }
        }
    }
    
    func updateUI(){
        

        let restarent = GlobalClass.restModel!
        let imgstr = "http://192.168.100.88:1234" + restarent.data.logo
        let logoUrl = NSURL(string:imgstr)!
        self.profilePicImgView.sd_setImage(with: logoUrl as URL, completed: nil)
        self.nameTxt.text = restarent.data.name
        self.cuisineTxt.text = restarent.data.cuisineIdData[0].name
        self.phoneNumberTxt.text = restarent.data.phone.code + "-" + restarent.data.phone.number
        self.ownerTxt.text = restarent.data.userName
        
        self.addressTxt.text = restarent.data.address.line1
        self.localityTxt.text = restarent.data.address.line2
        self.flotNoTxt.text = restarent.data.address.city
        self.landmarkTxt.text = restarent.data.address.state
        
        self.offerTypeBtn.titleLabel?.text = restarent.data.offer.type
        self.targetAmtTxt.text = String(restarent.data.offer.value)
        self.offerAmtTxt.text = String(restarent.data.offer.minAmount)
        self.maxOffAmtTxt.text = String(restarent.data.offer.maxDiscountAmount)
    }
    
    @IBAction func profilePicButtonClicked(_ sender: Any) {
        
    }
    
    @IBAction func saveBtnClicked(sender: UIButton) {
        
    }
    
    @IBAction func offersButtonClicked(_ sender: Any) {
        if isOffersExpanded {
            isOffersExpanded = false
            offersViewHeightConstraint.constant = 0
            scrollviewHeightConstraint.constant = 690
        }else{
            isOffersExpanded = true
            offersViewHeightConstraint.constant = 310
            scrollviewHeightConstraint.constant = 990
            
            _ = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.goNext(timer:)), userInfo: nil, repeats: false)
        }
    }
    
    @objc func goNext(timer:Timer){
        let bottomOffset = CGPoint(x: 0, y: scrollView.contentSize.height - scrollView.bounds.size.height)
        scrollView.setContentOffset(bottomOffset, animated: true)
    }
    
    @IBAction func backButtonClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
