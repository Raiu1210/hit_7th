//
//  QuizViewController.swift
//  hit_7th
//
//  Created by Ryu Ishibashi on 2019/06/06.
//  Copyright © 2019 Ryu Ishibashi. All rights reserved.
//

import UIKit
import SwiftyJSON
import GoogleMobileAds

class QuizViewController: UIViewController {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var num = [5, 6, 7, 8].shuffled()
    var countries:[String] = []
    var data:[String:String] = [:]
    var index = 0
    var message = ""
    var bannerView: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        prepare_quiz()
        show_banner_ad()
        set_navigation_bar()
    }
    
    
    
    private func show_banner_ad() {
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        bannerView.adUnitID = "ca-app-pub-9410270200655875/1210000198"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        addBannerViewToView(bannerView)
    }
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
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
    
    private func prepare_quiz(){
        let selected_id = appDelegate.selected_id?.description
        let jsonString = appDelegate.json_string!
        let json_Data: Data =  jsonString.data(using: String.Encoding.utf8)!
        let parsed_data = try! JSON(data: json_Data)
        
        while parsed_data[index]["id"].stringValue != selected_id {
            index += 1
        }
        
        data.updateValue(parsed_data[index]["title"].stringValue, forKey: "title")
        data.updateValue(parsed_data[index]["1st"].stringValue, forKey: "1st")
        data.updateValue(parsed_data[index]["2nd"].stringValue, forKey: "2nd")
        data.updateValue(parsed_data[index]["3rd"].stringValue, forKey: "3rd")
        data.updateValue(parsed_data[index]["4th"].stringValue, forKey: "4th")
        data.updateValue(parsed_data[index]["5th"].stringValue, forKey: "5th")
        data.updateValue(parsed_data[index]["6th"].stringValue, forKey: "6th")
        data.updateValue(parsed_data[index]["7th"].stringValue, forKey: "7th")
        data.updateValue(parsed_data[index]["8th"].stringValue, forKey: "8th")
        data.updateValue(parsed_data[index]["9th"].stringValue, forKey: "9th")
        data.updateValue(parsed_data[index]["10th"].stringValue, forKey: "10th")
        data.updateValue(parsed_data[index]["data1"].stringValue, forKey: "data1")
        data.updateValue(parsed_data[index]["data2"].stringValue, forKey: "data2")
        data.updateValue(parsed_data[index]["data3"].stringValue, forKey: "data3")
        data.updateValue(parsed_data[index]["data4"].stringValue, forKey: "data4")
        data.updateValue(parsed_data[index]["data5"].stringValue, forKey: "data5")
        data.updateValue(parsed_data[index]["data6"].stringValue, forKey: "data6")
        data.updateValue(parsed_data[index]["data7"].stringValue, forKey: "data7")
        data.updateValue(parsed_data[index]["data8"].stringValue, forKey: "data8")
        data.updateValue(parsed_data[index]["data9"].stringValue, forKey: "data9")
        data.updateValue(parsed_data[index]["data10"].stringValue, forKey: "data10")
        data.updateValue(parsed_data[index]["memo"].stringValue, forKey: "memo")

        
        create_answer_message()
        create_quiz_view()
    
    }

    
    private func create_answer_message() {
        message += "\n\(data["title"]!)\n"
        message += "1位 : \(data["1st"]!) (\(data["data1"]!))\n"
        message += "2位 : \(data["2nd"]!) (\(data["data2"]!))\n"
        message += "3位 : \(data["3rd"]!) (\(data["data3"]!))\n"
        message += "4位 : \(data["4th"]!) (\(data["data4"]!))\n"
        message += "5位 : \(data["5th"]!) (\(data["data5"]!))\n"
        message += "6位 : \(data["6th"]!) (\(data["data6"]!))\n"
        message += "7位 : \(data["7th"]!) (\(data["data7"]!))\n"
        message += "8位 : \(data["8th"]!) (\(data["data8"]!))\n"
        message += "9位 : \(data["9th"]!) (\(data["data9"]!))\n"
        message += "10位 : \(data["10th"]!) (\(data["data10"]!))\n"
        message += "\n\(data["memo"]!)"
        print(message)
    }
    
    private func create_quiz_view(){
        self.view.backgroundColor = UIColor.white
        let quiz_label = UILabel()
        quiz_label.frame = CGRect(x:50,y:100,width: self.view.frame.width*0.8, height:150)
        quiz_label.center.x = self.view.center.x
        quiz_label.numberOfLines = 0
        quiz_label.text = data["title"]! + "\n第7位は？"
        quiz_label.textAlignment = .center
        quiz_label.font = UIFont.boldSystemFont(ofSize: 24.0)
        quiz_label.layer.borderWidth = 3.0
        quiz_label.layer.borderColor = UIColor.black.cgColor
        
        self.view.addSubview(quiz_label)
        for i in 0...3 {
            create_quiz_button(counter: i)
        }
    }
    
    private func create_quiz_button(counter:Int) {
        let choice_Button = UIButton()
        let height:CGFloat = CGFloat(300 + 80 * counter)
        choice_Button.frame = CGRect(x:50, y:height, width: self.view.frame.width*0.7, height:50)
        choice_Button.center.x = self.view.center.x
        choice_Button.layer.borderWidth = 1.0
        choice_Button.layer.cornerRadius = 10.0
        choice_Button.setTitleColor(UIColor.black, for: .normal)
        
        if(num[counter] == 7) {
            choice_Button.setTitle(data["7th"]!, for: .normal)
            choice_Button.addTarget(self, action: #selector(chose_correct_answer(_:)), for: .touchUpInside)
            countries.append(data["7th"]!)
        } else if(num[counter] == 5){
            choice_Button.setTitle(data["5th"]!, for: .normal)
            choice_Button.addTarget(self, action: #selector(chose_wrong_answer(_:)), for: .touchUpInside)
            countries.append(data["5th"]!)
        } else if(num[counter] == 6){
            choice_Button.setTitle(data["6th"]!, for: .normal)
            choice_Button.addTarget(self, action: #selector(chose_wrong_answer(_:)), for: .touchUpInside)
            countries.append(data["6th"]!)
        } else if(num[counter] == 8){
            choice_Button.setTitle(data["8th"]!, for: .normal)
            choice_Button.addTarget(self, action: #selector(chose_wrong_answer(_:)), for: .touchUpInside)
            countries.append(data["8th"]!)
        }
        
        self.view.addSubview(choice_Button)
    }
    
    @objc func chose_correct_answer(_ sender: UIButton) {
        let Alert1_correct: UIAlertController = UIAlertController(title: "正解！　⭕️", message: message,  preferredStyle: .alert)
        let myOkAction = UIAlertAction(title: "ほえ〜", style: .default) { action in
            print("Action OK!!")
        }
        Alert1_correct.addAction(myOkAction)
        present(Alert1_correct, animated: true, completion: nil)
    }
    
    @objc func chose_wrong_answer(_ sender: UIButton) {
                let Alert1_correct: UIAlertController = UIAlertController(title: "残念！　❌", message: message,  preferredStyle: .alert)
                let myOkAction = UIAlertAction(title: "ほえ〜", style: .default) { action in
                    print("Action OK!!")
                }
                Alert1_correct.addAction(myOkAction)
                present(Alert1_correct, animated: true, completion: nil)
    }
    
    
    private func set_navigation_bar() {
        let actionButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.action, target: self, action: #selector(clickActionButton(_:)))
        self.navigationItem.setRightBarButtonItems([actionButton], animated: true)
    }
    
    @objc func clickActionButton(_: UIBarButtonItem) {
        var choices = "A:\(countries[0])\nB:\(countries[1])\nC:\(countries[2])\nD:\(countries[3])\n\n"
        
        let text = "問題：" + data["title"]! + "\n第7位は？\n\n" + choices + "iPhone:https://apps.apple.com/jp/app/7%E4%BD%8D%E3%82%92%E5%BD%93%E3%81%A6%E3%82%8D/id1468442673\n\n#7位当て"
        //        let image: UIImage = #imageLiteral(resourceName: "画像リソース名")
        let shareItems = [text] as [Any]
        let controller = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
        present(controller, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}
