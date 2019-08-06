//
//   路漫漫其修远兮，吾将上下而求索
//
//   ViewController.swift
//   PKSPopView
//
//   Created  by pengkang on 2019/7/4
//   Copyright © 2019 qhht. All rights reserved.
//
    

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var mainTable: UITableView!
    
    @IBOutlet weak var `sswitch`: UISwitch!
    
    var  dataSource: [String] = [String]()
    
    var useAutoLayoutToContentView = true
    
    let pks = PKSPopView()
    
    lazy var contentView:UIView! = {
        let view: UIView! = UIView(frame: CGRect(origin: CGPoint(x: 200, y: 500), size: CGSize(width: 100, height: 100)))
        view.backgroundColor = UIColor.gray
        return view
    }()
    
    lazy var layoutView:AutoLayoutView = {
        let view = AutoLayoutView()
        return view
    }()
    
    @IBAction func switchAutoLayout(_ sender: Any) {
        let mySwitch = sender as! UISwitch
        useAutoLayoutToContentView = mySwitch.isOn
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.dataSource.append(contentsOf: ["scale","top","left","bottom","right","none"])
        
        let config: PKSConfig = .shared
        print(config)
        
        let config1: PKSConfig = .shared
        print(config1)
        
        
    }

  
}

extension ViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = "style:  \(dataSource[indexPath.row])"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        pks.contentView = self.contentView!
        pks.enablePanContentViewToHide = true
        
        let width = self.view.frame.size.width
        let height = self.view.frame.size.height
        
        pks.addHideAnimation = true
        pks.addShowAnimation = true
        
        pks.useAutoLayout = useAutoLayoutToContentView
        if pks.useAutoLayout {
            pks.contentView = layoutView
            pks.layoutPositon = [.top,.left,.right]
        }
        
        switch indexPath.row {
        case 0:
            pks.showAnimationStyle = .scale
            pks.hideAnimationStyle = .scale
            pks.panDirection = .top
            self.contentView!.frame = CGRect(origin: CGPoint(x: 100, y: 100), size: CGSize(width: 200, height: 200))
            
            
        case 1:
            pks.showAnimationStyle = .fromTop
            pks.hideAnimationStyle = .toTop
            pks.panDirection = .top
            self.contentView!.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: width , height: height * 0.3))
        case 2:
            pks.showAnimationStyle = .fromLeft
            pks.hideAnimationStyle = .toLeft
            pks.panDirection = .left
            self.contentView!.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: width*0.75, height: height))
        case 3:
            pks.showAnimationStyle = .fromBottom
            pks.hideAnimationStyle = .toBottom
            pks.panDirection = .bottom
            self.contentView!.frame = CGRect(origin: CGPoint(x: 0, y: height * (1-0.3)), size: CGSize(width: width, height: height * 0.3))
        case 4:
            pks.showAnimationStyle = .fromRight
            pks.hideAnimationStyle = .toRight
            pks.panDirection = .right
            self.contentView!.frame = CGRect(origin: CGPoint(x: width*0.5, y: 0), size: CGSize(width: width*0.5, height: height))
        default:
            pks.addHideAnimation = false
            pks.addShowAnimation = false
            pks.enablePanContentViewToHide = false
            self.contentView!.frame = CGRect(origin: CGPoint(x: 200, y: 500), size: CGSize(width: 100, height: 100))
            print("here")
        }
        
        pks.showOnView(self.view!)
    }
}
