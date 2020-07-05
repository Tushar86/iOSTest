//
//  ViewController.swift
//  Proficiency Exercise
//
//  Created by Tushar on 05/07/20.
//  Copyright © 2020 Tushar. All rights reserved.
//

import UIKit
import SDWebImage

class ViewController: UIViewController {
    let tableView = UITableView()
    var safeArea: UILayoutGuide!
    var imageArr : [String] = []
    var titleArr : [String] = []
    var descArr : [String] = []
    var viewModelObj = [ViewModel]()
    
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl.attributedTitle = NSAttributedString(string: "Data refresh")
        self.refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        tableView.refreshControl = refreshControl
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "cell")
        view.backgroundColor = .white
        safeArea = view.layoutMarginsGuide
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.estimatedRowHeight = 44
        self.setupTableView()
        self.getData()
    }
    @objc func refresh(sender:AnyObject) {
        self.getData()
        self.refreshControl.endRefreshing()
    }
    func getData(){
        Helper.shared.getDataFromApi(withUrl: EndPoint.url) { (data) in
            self.viewModelObj = data.map({ return ViewModel(mObj: $0)})
            for obj in self.viewModelObj{
                self.imageArr.append(obj.image!)
                self.titleArr.append(obj.title!)
                self.descArr.append(obj.desc!)
            }
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
    func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: safeArea.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: safeArea.rightAnchor).isActive = true
    }
    func rectForText(text: String, font: UIFont, maxSize: CGSize) -> CGSize {
        let attrString = NSAttributedString.init(string: text, attributes: [NSAttributedString.Key.font:font])
        let rect = attrString.boundingRect(with: maxSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil)
        let size = CGSize(width: rect.size.width, height: rect.size.height)
        return size
    }
}

extension ViewController : UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModelObj.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? TableViewCell else { return UITableViewCell() }
        cell.titleLabel.text = self.titleArr[indexPath.row]
        cell.descriptionLabel.text = self.descArr[indexPath.row]
        let url = URL(string: self.imageArr[indexPath.row])
        cell.itemImage.sd_setImage(with: url, placeholderImage: nil, options: [], context: nil)
        return cell
    }
}
