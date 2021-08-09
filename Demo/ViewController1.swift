//
//  ViewController1.swift
//  Example
//
//  Created by Daniels on 2018/3/16.
//  Copyright © 2018 Daniels. All rights reserved.
//

import UIKit
import Tiercel

class ViewController1: UIViewController {

    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var timeRemainingLabel: UILabel!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var validationLabel: UILabel!


    lazy var URLString = "https://5b0988e595225.cdn.sohucs.com/images/20190130/1420967152ae4a388abbd84454823ad0.gif"
    var sessionManager = appDelegate.sessionManager1

    override func viewDidLoad() {
        super.viewDidLoad()
        
        sessionManager.tasks.safeObject(at: 0)?.progress { [weak self] (task) in
            self?.updateUI(task)
        }.completion { [weak self] (task) in
            self?.updateUI(task)
            if task.status == .succeeded {
                // 下载成功
                print("path is: \(task.filePath), \(task.url)")
            } else {
                // 其他状态
            }
        }.validateFile(code: "9e2a3650530b563da297c9246acaad5c", type: .md5) { [weak self] (task) in
            self?.updateUI(task)
            if task.validation == .correct {
                // 文件正确
            } else {
                // 文件错误
            }
        }
    }

    private func updateUI(_ task: DownloadTask) {
        let per = task.progress.fractionCompleted
        progressLabel.text = "progress： \(String(format: "%.2f", per * 100))%"
        progressView.observedProgress = task.progress
        speedLabel.text = "speed： \(task.speedString)"
        timeRemainingLabel.text = "剩余时间： \(task.timeRemainingString)"
        startDateLabel.text = "开始时间： \(task.startDateString)"
        endDateLabel.text = "结束时间： \(task.endDateString)"
        var validation: String
        switch task.validation {
        case .unkown:
            validationLabel.textColor = UIColor.blue
            validation = "未知"
        case .correct:
            validationLabel.textColor = UIColor.green
            validation = "正确"
        case .incorrect:
            validationLabel.textColor = UIColor.red
            validation = "错误"
        }
        validationLabel.text = "文件验证： \(validation)"
    }
    
    @IBAction func start(_ sender: UIButton) {
        sessionManager.download(URLString)?.progress { [weak self] (task) in
            self?.updateUI(task)
        }.completion { [weak self] (task) in
            self?.updateUI(task)
            if task.status == .succeeded {
                // 下载成功
                print("download path is: \(task.filePath), \(task.url)")
            } else {
                // 其他状态
            }
        }.validateFile(code: "9e2a3650530b563da297c9246acaad5c", type: .md5) { [weak self] (task) in
            self?.updateUI(task)
            if task.validation == .correct {
                // 文件正确
            } else {
                // 文件错误
            }
        }
    }

    @IBAction func suspend(_ sender: UIButton) {
        sessionManager.suspend(URLString)
    }


    @IBAction func cancel(_ sender: UIButton) {
        sessionManager.cancel(URLString)
    }

    @IBAction func deleteTask(_ sender: UIButton) {
        sessionManager.remove(URLString, completely: false)
    }

    @IBAction func clearDisk(_ sender: Any) {
        sessionManager.cache.clearDiskCache()
    }
}

