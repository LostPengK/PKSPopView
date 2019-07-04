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
    
    var  dataSource: [Int] = [Int]()
    let pks = PKSPopView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.dataSource.append(contentsOf: [1,2,3])
        
        let config: PKSConfig = .shared
        print(config)
        
        let config1: PKSConfig = .shared
        print(config1)
        
        mainTable.isHidden = true
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        pks.hideContentView()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.show()
        }
    }

    func show() {
        
        pks.showAnimationStyle = .FromLeft
        
        let view: UIView! = UIView(frame: CGRect(origin: CGPoint(x: 200, y: 500), size: CGSize(width: 100, height: 100)))
        view.backgroundColor = .red
        
        pks.contentView = view
        pks.showOnView(self.view!)
    }
}

extension ViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = "row \(indexPath.row)"
        return cell
    }
    
}
