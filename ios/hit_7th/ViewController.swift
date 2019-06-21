//
//  ViewController.swift
//  hit_7th
//
//  Created by Ryu Ishibashi on 2019/06/06.
//  Copyright © 2019 Ryu Ishibashi. All rights reserved.
//

import UIKit
import SwiftyJSON
import Reachability
import GoogleMobileAds


class ViewController: UIViewController, GADBannerViewDelegate {
    let data_server = "http://zihankimap.work/hit_7th/datalist"
    let scrollView = UIScrollView()
    let reachability = Reachability()!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var viewWidth:CGFloat = 0.0
    var viewHeight:CGFloat = 0.0
    var json_string_file_path:String = ""
    var bannerView: GADBannerView!
    var refreshControl:UIRefreshControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "7位を当てろ！"
        self.view.backgroundColor = UIColor.white
        viewWidth = self.view.frame.width
        viewHeight = self.view.frame.height
        let directory_path = NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true)[0]
        let file_Name = "jsonString.txt"
        self.json_string_file_path = directory_path + "/" + file_Name
        
        // when Online and Offline
        if reachability.connection == .wifi || reachability.connection == .cellular {
            self.get_data_from_server(url: self.data_server)
            self.show_banner_ad()
        } else {
            self.offline_procedure()
        }
    }
    
    internal func get_data_from_server(url:String){
        let url = URL(string: url)!
        print("URL : \(url)")
        let request = URLRequest(url: url)
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in if error == nil, let data = data, let response = response as? HTTPURLResponse {
            let jsonString = String(data: data, encoding: String.Encoding.utf8) ?? ""
            self.save_jsonString_data(jsonString: jsonString)
            self.load_jsonString_and_createView(jsonString: jsonString)
            }
            }.resume()
    }
    
    internal func save_jsonString_data(jsonString: String) {
        do {
            try jsonString.write(toFile: self.json_string_file_path, atomically: false, encoding: String.Encoding.utf8)
            print("I wrote jsonString to file")
        } catch let error as NSError {
            print("failed to write: \(error)")
        }
    }
    
    internal func load_jsonString_and_createView(jsonString:String) {
        DispatchQueue.main.async {
            do {
                self.appDelegate.json_string = jsonString
                let json_Data: Data =  jsonString.data(using: String.Encoding.utf8)!
                let parsed_data = try JSON(data: json_Data)
                let num_of_Q = parsed_data.count
                self.create_view(num_of_Q: num_of_Q)
                print(num_of_Q)
                for i in 0 ..< parsed_data.count
                {
                    let id = parsed_data[i]["id"].stringValue
                    let title = parsed_data[i]["title"].stringValue
                    self.create_button(index:i, id: Int(id)!, title: title)
                }
            } catch { print(error) }
        }
    }
    
    
    internal func create_view(num_of_Q:Int) {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(reload), for: .valueChanged)
        scrollView.frame = CGRect(x: 0, y: 90, width: viewWidth, height: viewHeight-90)
        scrollView.contentSize = CGSize(width: Int(viewWidth), height: 80*(num_of_Q+1))
        scrollView.refreshControl = refreshControl
        
        self.view.addSubview(scrollView)
    }
    
    @objc func reload(sender: UIRefreshControl) {
        self.removeAllSubviews(parentView: scrollView)
        self.removeAllSubviews(parentView: self.view)
        
        self.loadView()
        self.viewDidLoad()
        
        sender.endRefreshing()
    }
    
     internal func removeAllSubviews(parentView: UIView){
        let subviews = parentView.subviews
        for subview in subviews {
            subview.removeFromSuperview()
        }
    }
    
    
    internal func create_button(index:Int, id:Int, title:String) {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        let Q_Button = UIButton()
        Q_Button.frame = CGRect(x:0, y:80*index, width:Int(viewWidth), height:80)
        Q_Button.titleLabel?.numberOfLines = 0
        Q_Button.setTitle(title, for: .normal)
        Q_Button.layer.borderWidth = 1.0
        Q_Button.layer.borderColor = UIColor.black.cgColor
        Q_Button.setTitleColor(UIColor.black, for: .normal)
        Q_Button.tag = id
        Q_Button.addTarget(self, action: #selector(ViewController.goQuiz(_:)), for: .touchUpInside)
        self.scrollView.addSubview(Q_Button)
    }
    
    internal func show_banner_ad() {
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
//        bannerView.adUnitID = "ca-app-pub-3940256099942544/6300978111" // test
        bannerView.adUnitID = "ca-app-pub-9410270200655875/4326461587"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        addBannerViewToView(bannerView)
    }
    
    internal func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints(
            [NSLayoutConstraint(item: bannerView,
                                attribute: .bottom,
                                relatedBy: .equal,
                                toItem: bottomLayoutGuide,
                                attribute: .top,
                                multiplier: 1,
                                constant: 0),
             NSLayoutConstraint(item: bannerView,
                                attribute: .centerX,
                                relatedBy: .equal,
                                toItem: view,
                                attribute: .centerX,
                                multiplier: 1,
                                constant: 0)
            ])
    }
    
    
    
    

    @objc func goQuiz(_ sender: UIButton) {
        self.appDelegate.selected_id = sender.tag
        let quizVC = QuizViewController()
        self.navigationController?.pushViewController(quizVC, animated: true)
    }
    
    internal func offline_procedure() {
        do {
            let file_url = NSURL(fileURLWithPath: self.json_string_file_path)
            let jsonString = try String(contentsOf: file_url as URL, encoding: String.Encoding.utf8)
            load_jsonString_and_createView(jsonString:jsonString)
        } catch let error as NSError {
            print("failed to read: \(error)")
        }
    }
}

