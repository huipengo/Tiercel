//
//  ViewController2.swift
//  Example
//
//  Created by Daniels on 2018/3/16.
//  Copyright © 2018 Daniels. All rights reserved.
//

import UIKit
import Tiercel

class ViewController2: BaseViewController {

    override func viewDidLoad() {
        
        sessionManager = appDelegate.sessionManager2

        super.viewDidLoad()


        URLStrings = [
            "https://5b0988e595225.cdn.sohucs.com/images/20190130/4afa097dcb494160a147dd880137b9fa.gif",
            "https://5b0988e595225.cdn.sohucs.com/images/20190130/1420967152ae4a388abbd84454823ad0.gif",
            "https://5b0988e595225.cdn.sohucs.com/images/20190130/b457402fb7a64886a10614358cd7a873.webp",
            "https://5b0988e595225.cdn.sohucs.com/images/20190130/d963f95f85b44f8fb17724dcf067f101.gif",
        ]
        

        setupManager()

        updateUI()
        tableView.reloadData()
        
    }
}


// MARK: - tap event
extension ViewController2 {

    @IBAction func addDownloadTask(_ sender: Any) {
        let downloadURLStrings = sessionManager.tasks.map { $0.url.absoluteString }
        guard let URLString = URLStrings.first(where: { !downloadURLStrings.contains($0) }) else { return }
        
        sessionManager.download(URLString) { [weak self] _ in
            guard let self = self else { return }
            let index = self.sessionManager.tasks.count - 1
            self.tableView.insertRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
            self.updateUI()
        }
    }

    @IBAction func deleteDownloadTask(_ sender: UIButton) {
        let count = sessionManager.tasks.count
        guard count > 0 else { return }
        let index = count - 1
        guard let task = sessionManager.tasks.safeObject(at: index) else { return }
        // tableView 刷新、 删除 task 都是异步的，如果操作过快会导致数据不一致，所以需要限制 button 的点击
        sender.isEnabled = false
        sessionManager.remove(task, completely: false) { [weak self] _ in
            self?.tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
            self?.updateUI()
            sender.isEnabled = true
        }
    }
    
    
    @IBAction func sort(_ sender: Any) {
        sessionManager.tasksSort { (task1, task2) -> Bool in
            if task1.startDate < task2.startDate {
                return task1.startDate < task2.startDate
            } else {
                return task2.startDate < task1.startDate
            }
        }
        tableView.reloadData()
    }
}



