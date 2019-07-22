//
//  ViewController.swift
//  Daily Quote
//
//  Created by Moustafa Awad on 4/26/18.
//  Copyright © 2018 Moustafa Awad. All rights reserved.
//

import UIKit
import CoreData
import FeedKit
import UserNotifications
import StoreKit
import Lottie
import AVFoundation


class ViewController: UIViewController {




    // MARK: - Outlets
    
    @IBOutlet weak var popoverOutlet: UIView!
    
    @IBOutlet var QuoteListView: UIView!
    
    
    
    @IBOutlet weak var TimePickerViewOutlet: UIView!
    
    @IBOutlet weak var TimePickerOutlet: UIDatePicker!
    @IBOutlet weak var quoteText: UILabel!
    @IBOutlet weak var quoteAuthor: UILabel!
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var shareButtonOutlet: UIButton!
//    gear = list
    @IBOutlet weak var gearButtonOutlet: UIButton!
    @IBOutlet weak var alarmButtonOutlet: UIButton!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    @IBOutlet weak var inAppViewOutlet: UIView!
    @IBOutlet weak var doneButtonOutlet: UIButton!
    @IBOutlet weak var closeButtonOutlet: UIButton!
    @IBOutlet weak var visualEffectTime: UIVisualEffectView!
    @IBOutlet weak var visualEffectInApp: UIVisualEffectView!
    @IBOutlet weak var RestoreButtonOutlet: UIButton!
    
    @IBOutlet weak var screenButtonOutlet: UIButton!
    @IBOutlet var NewView: UIView!
    @IBOutlet weak var newButtonOutlet: UIButton!
    @IBOutlet weak var newVisualOutlet: UIVisualEffectView!
    
    // MARK: - Swipe Gesture Recognizer Outlet and Action
    
    func addSwipeHandler() {
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
        leftSwipe.direction = .left
        
        view.addGestureRecognizer(rightSwipe)
        view.addGestureRecognizer(leftSwipe)

    }
    
    @objc func handleSwipe(sender: UISwipeGestureRecognizer) {
        if sender.state == .ended {
            switch sender.direction {
            case .right:
                nextQuote()
            case .left:
                prevQuote()
            default:
                break
            }
        }
        
    }
    
    // MARK: - Actions
    
    @IBAction func dismissWelcome(_ sender: Any) {
        animateOut(uiview: NewView)
        screenButtonOutlet.isHidden = false
        UserDefaults.standard.set(true, forKey: "showedWelcome")
        
    }
//    list button
    @IBAction func gearButton(_ sender: Any) {
        animateIn(uiview: QuoteListView)
    }
    @IBAction func alarmButton(_ sender: Any) {
        animateIn(uiview: TimePickerViewOutlet)
    }

    
    @IBAction func ShareButton(_ sender: Any) {
        DispatchQueue.main.async {
            let activityVC = UIActivityViewController(activityItems: ["\"" + self.quoteText.text! + "\"", "\n- " + self.quoteAuthor.text!], applicationActivities: nil)
            if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad)
            {
                //ios > 8.0
                if ( activityVC.responds(to: #selector(getter: UIViewController.popoverPresentationController)) ) {
                    activityVC.popoverPresentationController?.sourceView = self.popoverOutlet
                }
            }
            self.present(activityVC, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func ScreenButton(_ sender: Any) {
        self.quoteText.alpha = 1.0
        self.shareButtonOutlet.alpha = 1.0
        self.gearButtonOutlet.alpha = 1.0
        self.alarmButtonOutlet.alpha = 1.0

    }
    
    @IBAction func doneButton(_ sender: Any) {
        animateOut(uiview: self.TimePickerViewOutlet)
        let rtnString = self.quoteText.text! + "\n - " + self.quoteAuthor.text!
        appDelegate.saveDate(date: TimePickerOutlet.date)
        appDelegate.scheduleNotification(quote: rtnString, date: TimePickerOutlet.date)

    }
    
    @IBAction func dismissList(_ sender: Any) {
        animateOut(uiview: self.QuoteListView)
    }
    
    @IBAction func dismissButton(_ sender: Any) {
        animateOut(uiview: self.TimePickerViewOutlet)
    }
    @IBAction func IAPButton(_ sender: Any) {
        IAPService.shared.purchase(product: .autoRenewing)
    }
    @IBAction func IAPRestore(_ sender: Any) {
        IAPService.shared.restorePurchases()
    }
    
    
    // MARK: - View Controller Functions
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewWillAppear(_ animated: Bool) {
        
        displayLastQuote()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Spoofify() // Stylizes all squares
        askNotificationPermissions()
        getQuoteFromNotification()
        
        //hide list button
        gearButtonOutlet.isHidden = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        playCoolIntro()
        isFirstTime()
        addSwipeHandler()
    }
    
    private var counter: Int = testData.count
    private var count: Int = 1
    private var feed: RSSFeed? = nil
    var effect:UIVisualEffect!
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    
    // MARK: Custom Methods
    
    func askNotificationPermissions(){
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (success, error) in
            
            if error == nil{
                print("Successful Authorization")
            }
        }
    }
    
    func nextQuote(){
        rotateQuote()
    }
    
    func prevQuote(){
        // images count
        count = (count - 1)
        if count == -1 {
            count = 3
        }
        // quote counter
        counter = Int.random(in: 0 ..< testData.count)
        let item = testData[counter]
        let author:String = (item["where"])!
        let quoting = (item["quote"])!
        let quote: String = quoting
        DispatchQueue.main.async {
            // ..and update the UI
            self.quoteText.text = quote
            self.quoteAuthor.text = author
        }
        changeImage(count: count)
    }
    
    func changeImage(count: Int) {
        switch count{
        case 0: fadeImage(newImage: #imageLiteral(resourceName: "bg0"))
        case 1: fadeImage(newImage: #imageLiteral(resourceName: "bg1"))
        case 2: fadeImage(newImage: #imageLiteral(resourceName: "bg2"))
        case 3: fadeImage(newImage: #imageLiteral(resourceName: "bg3"))
        default:
            break
        }
    }
    func fadeImage(newImage: UIImage) {
        UIView.transition(with: self.bgImageView,
                          duration: 0.3,
                          options: .transitionCrossDissolve,
                          animations: {
                            self.bgImageView.image = newImage},
                          completion: nil)
    }

    
    func rotateQuote(){
        counter = Int.random(in: 0 ..< testData.count)
        let item = testData[counter]
        let author:String = (item["where"])!
        let quoting = (item["quote"])!
        let quote: String = quoting
        DispatchQueue.main.async {
            // ..and update the UI
            self.quoteText.text = quote
            self.quoteAuthor.text = author
        }
        // images count
        changeImage(count: count)
        if (count == 3){count = -1}
        count = (count + 1)
    }
    
    
    func getQuoteFromNotification(){
        counter = appDelegate.counter
        let item = testData[counter]
        let author:String = (item["where"])!
        let quoting = (item["quote"])!
        let quote: String = quoting
        DispatchQueue.main.async {
            // ..and update the UI
            self.quoteText.text = quote
            self.quoteAuthor.text = author
        }
    }
    
    func circleButton(){
        let borderAlpha : CGFloat = 0.7
        shareButtonOutlet.frame = CGRect(x: 100,y: 100,width: 200,height: 40)
        shareButtonOutlet.setTitle("SHARE", for: .normal)
        shareButtonOutlet.setTitleColor(UIColor.white, for: .normal)
        shareButtonOutlet.backgroundColor = UIColor.clear
        shareButtonOutlet.layer.borderWidth = 2.0
        shareButtonOutlet.layer.borderColor = UIColor(white: 1.0, alpha: borderAlpha).cgColor
        shareButtonOutlet.layer.cornerRadius = 3 * shareButtonOutlet.frame.height / 5
        
    }
    
    func circleButton2(){
        let borderAlpha : CGFloat = 0.7
        doneButtonOutlet.frame = CGRect(x: 100,y: 100,width: 200,height: 40)
        doneButtonOutlet.setTitle("SET", for: .normal)
        doneButtonOutlet.setTitleColor(UIColor.black, for: .normal)
        doneButtonOutlet.backgroundColor = UIColor.clear
        doneButtonOutlet.layer.borderWidth = 1.5
        doneButtonOutlet.layer.borderColor = UIColor(white: 0, alpha: borderAlpha).cgColor
        doneButtonOutlet.layer.cornerRadius = shareButtonOutlet.frame.height / 2
    }
    
    func circleButton3(){
        let borderAlpha : CGFloat = 0.7
        closeButtonOutlet.frame = CGRect(x: 100,y: 100,width: 200,height: 40)
        closeButtonOutlet.setTitle("START FREE TRIAL", for: .normal)
        closeButtonOutlet.setTitleColor(UIColor.black, for: .normal)
        closeButtonOutlet.backgroundColor = UIColor.clear
        closeButtonOutlet.layer.borderWidth = 1.75
        closeButtonOutlet.layer.borderColor = UIColor(white: 0, alpha: borderAlpha).cgColor
        closeButtonOutlet.layer.cornerRadius = 3 * shareButtonOutlet.frame.height / 5

    }
    
    func circleButton4(button: UIButton){
        let borderAlpha : CGFloat = 0.7
        button.frame = CGRect(x: 100,y: 100,width: 200,height: 40)
        button.setTitle("CONTINUE", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.backgroundColor = UIColor.clear
        button.layer.borderWidth = 1.75
        button.layer.borderColor = UIColor(white: 0, alpha: borderAlpha).cgColor
        button.layer.cornerRadius = 3 * shareButtonOutlet.frame.height / 5
    }
    
    func animateIn(uiview: UIView) {
        visualEffectView.isHidden = false
        self.view.addSubview(uiview)
        uiview.center = self.view.center
        
        uiview.alpha = 0

        UIView.animate(withDuration: 0.4) {
            self.visualEffectView.effect = self.effect
            uiview.alpha = 1
        }
    }
    
    func animateInFrame(uiview: UIView) {
        uiview.frame = CGRect(x: 0, y: 0, width: self.view.frame.width * 0.8, height: self.view.frame.height * 0.8)
        animateIn(uiview: uiview)
        
    }
    
    func animateOut(uiview: UIView) {
        UIView.animate(withDuration: 0.3, animations: {
            uiview.transform = CGAffineTransform.init(scaleX: 1.3, y:1.3)
            uiview.alpha = 0
            
            self.visualEffectView.effect = nil
        })
        visualEffectView.isHidden = true

        
    }
    
    
    
    
    func Spoofify() {
        let yourAttributes : [NSAttributedStringKey: Any] = [
            NSAttributedStringKey.font : UIFont.systemFont(ofSize: 12),
            NSAttributedStringKey.foregroundColor : UIColor.black,
            NSAttributedStringKey.underlineStyle : NSUnderlineStyle.styleSingle.rawValue]
        let attributeString = NSMutableAttributedString(string: "Restore Membership", attributes: yourAttributes)
        RestoreButtonOutlet.setAttributedTitle(attributeString, for: .normal)

        
        self.quoteText.alpha = 0
        self.quoteAuthor.alpha = 0
        self.shareButtonOutlet.alpha = 0
        self.gearButtonOutlet.alpha = 0
        self.alarmButtonOutlet.alpha = 0
        visualEffectInApp.layer.cornerRadius = 10
        visualEffectTime.layer.cornerRadius = 10
        newVisualOutlet.layer.cornerRadius = 10
        visualEffectTime.clipsToBounds = true
        visualEffectInApp.clipsToBounds = true
        newVisualOutlet.clipsToBounds = true
        
        effect = visualEffectView.effect
        visualEffectView.effect = nil
        visualEffectView.isHidden = true
        
        circleButton()
        circleButton2()
        circleButton3()
        circleButton4(button: newButtonOutlet)
        
    }


    
    func playCoolIntro() {
        UIView.animate(withDuration: 1.5, delay: 0.5, animations: {
            self.quoteText.alpha = 1.0
        })
        UIView.animate(withDuration: 1.5, delay: 2, animations: {
            self.quoteAuthor.alpha = 1.0
        })
    }
    
    func displayLastQuote(){
        
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "SavedQuotes")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            let lastQuoteAndAuthor =  (result as! [NSManagedObject]).last

            if (lastQuoteAndAuthor?.value(forKey: "lastAuthor") != nil){
                quoteText.text = (lastQuoteAndAuthor?.value(forKey: "lastQuote") as! String)
                quoteAuthor.text = (lastQuoteAndAuthor?.value(forKey: "lastAuthor") as! String)
            }
        } catch {
            
            print("Failed displayLastQuote()")
        }
    }
    
    // asignates last saved quote
    func requestLastSavedQuotes() -> NSManagedObject? {
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "SavedQuotes")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            let lastQuoteAndAuthor =  (result as! [NSManagedObject]).last
            return lastQuoteAndAuthor!
        } catch {
            
            print("Failed requestLastSavedQuotes()")
            
        }
        return nil
    }
    
    func isFirstTime() {
        let a = UserDefaults.standard.bool(forKey: "showedWelcome")
        if (!a) {
            self.animateIn(uiview: NewView)
        }
    }
    @IBOutlet weak var ImageViewOutlet: UIImageView!
    
//    Receiving quotes from watch
//    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
//        let receivedGlobal = applicationContext["my_global"] as? TypeOfTheGlobal
//    }
}

