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

class ViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var TimePickerViewOutlet: UIView!
    @IBOutlet weak var TimePickerOutlet: UIDatePicker!
    @IBOutlet weak var quoteText: UILabel!
    @IBOutlet weak var quoteAuthor: UILabel!
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var shareButtonOutlet: UIButton!
    @IBOutlet weak var NextButtonOutlet: UIButton!
    @IBOutlet weak var gearButtonOutlet: UIButton!
    @IBOutlet weak var alarmButtonOutlet: UIButton!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    @IBOutlet weak var inAppViewOutlet: UIView!
    @IBOutlet weak var doneButtonOutlet: UIButton!
    @IBOutlet weak var closeButtonOutlet: UIButton!
    @IBOutlet weak var visualEffectTime: UIVisualEffectView!
    @IBOutlet weak var visualEffectInApp: UIVisualEffectView!
    
    
    
    // MARK: - Actions
    
    @IBAction func gearButton(_ sender: Any) {
        animateIn2()
    }
    @IBAction func alarmButton(_ sender: Any) {
        animateIn()
    }
    
    @IBAction func NextButton(_ sender: Any) {
        
        rotateQuote()
        UIView.animate(withDuration: 1.25, delay: 0.3, animations: {
            self.NextButtonOutlet.alpha = 0
        })
    }
    
    @IBAction func ShareButton(_ sender: Any) {
        DispatchQueue.main.async {
            let activityVC = UIActivityViewController(activityItems: [self.quoteText.text,self.quoteAuthor.text], applicationActivities: nil)
        
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func ScreenButton(_ sender: Any) {
        self.quoteText.alpha = 1.0
        self.shareButtonOutlet.alpha = 1.0
        self.NextButtonOutlet.alpha = 1.0
        self.gearButtonOutlet.alpha = 1.0
        self.alarmButtonOutlet.alpha = 1.0
    }
    
    @IBAction func doneButton(_ sender: Any) {
        animateOut()
        appDelegate.scheduleNotification(quote: self.quoteText.text!, date: TimePickerOutlet.date)
    }
    
    @IBAction func closeButton(_ sender: Any) {
        animateOut2()
    }
    
    
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewWillAppear(_ animated: Bool) {
        
        displayLastQuote()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Spoofify()
        
        getQuotes()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        playCoolIntro()
    }
    

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
    
    
    func rotateQuote(){
        let item = self.feed?.items?[count]
        let author:String = (item!.title)!
        var quoting = (item!.description)!
        quoting = String(quoting.characters.dropLast())
        quoting = String(quoting.characters.dropFirst())
        let quote: String = quoting
        DispatchQueue.main.async {
            // ..and update the UI
            self.quoteText.text = quote
            self.quoteAuthor.text = author
        }
        if (count == 0){bgImageView.image = #imageLiteral(resourceName: "bg0")}
        if (count == 1){bgImageView.image = #imageLiteral(resourceName: "bg1")}
        if (count == 2){bgImageView.image = #imageLiteral(resourceName: "bg2")}
        if (count == 3){bgImageView.image = #imageLiteral(resourceName: "bg3")
            count = -1
        }
        count = (count + 1)
    }
    
    
    func getQuotes(){
        let feedURL = URL(string: "https://www.brainyquote.com/link/quotebr.rss")!
        let parser = FeedParser(URL: feedURL)
        
        // Parse asynchronously, not to block the UI.
        parser?.parseAsync(queue: DispatchQueue.global(qos: .userInitiated)) { (result) in
            // Do your thing, then back to the Main thread
            self.feed = result.rssFeed
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
        doneButtonOutlet.setTitle("DONE", for: .normal)
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
    
    func animateIn() {
        visualEffectView.isHidden = false
        self.view.addSubview(TimePickerViewOutlet)
        TimePickerViewOutlet.center = self.view.center
        
        TimePickerViewOutlet.transform = CGAffineTransform.init(scaleX: 1.3, y:1.3)
        TimePickerViewOutlet.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
            self.visualEffectView.effect = self.effect
            self.TimePickerViewOutlet.alpha = 1
            self.TimePickerViewOutlet.transform = CGAffineTransform.identity
        }
    }
    
    func animateOut() {
        UIView.animate(withDuration: 0.3, animations: {
            self.TimePickerViewOutlet.transform = CGAffineTransform.init(scaleX: 1.3, y:1.3)
            self.TimePickerViewOutlet.alpha = 0
            
            self.visualEffectView.effect = nil
            
        })
        visualEffectView.isHidden = true
    }
    func animateIn2() {
        visualEffectView.isHidden = false
        self.view.addSubview(inAppViewOutlet)
        inAppViewOutlet.center = self.view.center
        
        inAppViewOutlet.transform = CGAffineTransform.init(scaleX: 1.3, y:1.3)
        inAppViewOutlet.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
            self.visualEffectView.effect = self.effect
            self.inAppViewOutlet.alpha = 1
            self.inAppViewOutlet.transform = CGAffineTransform.identity
        }
    }
    
    func animateOut2() {
        UIView.animate(withDuration: 0.3, animations: {
            self.inAppViewOutlet.transform = CGAffineTransform.init(scaleX: 1.3, y:1.3)
            self.inAppViewOutlet.alpha = 0
            
            self.visualEffectView.effect = nil
            
        })
        visualEffectView.isHidden = true
    }
    
    func Spoofify() {
        
        self.quoteText.alpha = 0
        self.quoteAuthor.alpha = 0
        self.NextButtonOutlet.alpha = 0
        self.shareButtonOutlet.alpha = 0
        self.gearButtonOutlet.alpha = 0
        self.alarmButtonOutlet.alpha = 0
        
        visualEffectInApp.layer.cornerRadius = 10;
        visualEffectTime.layer.cornerRadius = 10
        visualEffectTime.clipsToBounds = true
        visualEffectInApp.clipsToBounds = true
        
        effect = visualEffectView.effect
        visualEffectView.effect = nil
        visualEffectView.isHidden = true
        
        circleButton()
        circleButton2()
        circleButton3()
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
                quoteText.text = lastQuoteAndAuthor?.value(forKey: "lastQuote") as! String
                quoteAuthor.text = lastQuoteAndAuthor?.value(forKey: "lastAuthor") as! String
            }
        } catch {
            
            print("Failed")
        }
    }
}

