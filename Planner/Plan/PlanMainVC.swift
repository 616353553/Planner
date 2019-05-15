//
//  PlanMainVC.swift
//  Planner
//
//  Created by bainingshuo on 4/22/19.
//  Copyright © 2019 Ningshuo Bai. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class PlanMainVC: UIViewController {

    @IBOutlet weak var backgroundScrollView: UIScrollView!
    @IBOutlet weak var dateCollectionView: UICollectionView!
    
    var tasks = [DisplayableTask]()
    var dates = [Date]()
    var db: Firestore!
    var themeColor = UIColor.init(red: 28/255.0, green: 116/255.0, blue: 235/255.0, alpha: 1.0)
    var viewDidLayoutSubviewsForTheFirstTime = true
    let screenWidth = UIScreen.main.bounds.width
    
    let speratorDistance: CGFloat = 100
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        dateCollectionView.delegate = self
        dateCollectionView.dataSource = self
        
        let today = Date()
        let components = Calendar.current.dateComponents([.year, .month, .day, .weekday], from: today)
        let currentWeekday = components.weekday!
        for i in 0..<21 {
            let offset = i - currentWeekday - 6
            dates.append(Calendar.current.date(byAdding: .day, value: offset, to: today)!)
        }
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: (screenWidth - 38)/7, height: 30)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        dateCollectionView.collectionViewLayout = layout
        dateCollectionView.isPagingEnabled = true
        
        let timeString = ["12\nAM", "01\nAM", "02\nAM", "03\nAM", "04\nAM", "05\nAM",
                          "06\nAM", "07\nAM", "08\nAM", "09\nAM", "10\nAM", "11\nAM",
                          "12\nPM", "01\nPM", "02\nPM", "03\nPM", "04\nPM", "05\nPM",
                          "06\nPM", "07\nPM", "08\nPM", "09\nPM", "10\nPM", "11\nPM", "12\nAM"]
        let contentHeight = 40 + speratorDistance * CGFloat(timeString.count - 1)
        backgroundScrollView.contentSize = CGSize(width: backgroundScrollView.bounds.width, height: contentHeight)
        for (idx, str) in timeString.enumerated() {
            let seperatorView = UIView(frame: CGRect(x: 30, y: 20 + CGFloat(idx) * speratorDistance, width: self.view.bounds.width, height: 0.5))
            let timeLabel = UILabel(frame: CGRect(x: 5, y: 6 + CGFloat(idx) * speratorDistance, width: 18, height: 28))
            timeLabel.textAlignment = .center
            timeLabel.text = str
            timeLabel.font = timeLabel.font.withSize(11)
            timeLabel.textColor = .lightGray
            timeLabel.numberOfLines = 2
            seperatorView.backgroundColor = .lightGray
            backgroundScrollView.addSubview(timeLabel)
            backgroundScrollView.addSubview(seperatorView)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let uid = Auth.auth().currentUser?.uid
        if uid != nil {
            db.collection("displayable_tasks").whereField("owner", isEqualTo: uid!).getDocuments { (querySnapshot, error) in
                if error != nil {
                    let alert = UIAlertController(title: "Error", message: "Unable to retrive task data", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .destructive))
                    self.present(alert, animated: true)
                } else {
                    self.tasks.removeAll()
                    for document in querySnapshot!.documents {
                        let data = document.data() as [String: AnyObject]
                        do {
                            let displayableTask = try DisplayableTask(id: document.documentID, data: data)
                            self.tasks.append(displayableTask)
                        } catch {
                            // nothing
                        }
                    }
                    self.tasks.sort(by: {$0 > $1})
                    for task in self.tasks {
                        print(task.toJSON())
                    }
                    self.splitTasks()
                    self.displayTasks()
                }
            }
        }
//        dateCollectionView.contentOffset = CGPoint(x: dateCollectionView.frame.width, y: 0)
//        dateCollectionView.contentOffset.x = dateCollectionView.frame.width
//        dateCollectionView.setContentOffset(CGPoint(x: dateCollectionView.frame.width, y: 0), animated: false)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if viewDidLayoutSubviewsForTheFirstTime {
            viewDidLayoutSubviewsForTheFirstTime = false
        } else {
            dateCollectionView.contentOffset = CGPoint(x: dateCollectionView.frame.width, y: 0)
        }
    }
    
    func splitTasks() {
        guard tasks.count > 0 else {
            return
        }
        for (idx, task) in tasks.enumerated() {
            if idx > 0 {
                let prevEnd = tasks[idx - 1].getTimeFlags()!.first!
                if task.getDeadline() >= prevEnd {
                    task.splitTask(before: prevEnd)
                } else {
                    task.splitTask(before: task.getDeadline())
                }
            } else {
                task.splitTask(before: task.getDeadline())
            }
        }
        
        
        
        
//        var earliestDeadline = tasks[0].getDeadline()
//        for task in tasks {
//            if task.getDeadline() >= earliestDeadline {
//                task.splitTask(before: earliestDeadline)
//            } else {
//                task.splitTask(before: task.getDeadline())
//            }
//            earliestDeadline = task.getTimeFlags()![0]
//        }
    }
    
    func displayTasks() {
        let taskViews = backgroundScrollView.subviews.filter{$0 is TaskView}
        for taskView in taskViews {
            taskView.removeFromSuperview()
        }
        for i in 7..<14 {
            let date = dates[i]
            for task in tasks {
                if let interval = task.intervalOn(date: date) {
                    var components = Calendar.current.dateComponents([.hour, .minute], from: interval[0])
                    let startHour = Double(components.hour!) + Double(components.minute!)/60.0
                    let x = 35 + CGFloat(i - 7) * (screenWidth - 38)/7
                    let y = CGFloat(startHour) * speratorDistance + 20.0
                    components = Calendar.current.dateComponents([.hour, .minute], from: interval[1])
                    let duration = Duration(interval: interval[1].timeIntervalSince(interval[0]))
                    let height = CGFloat(duration.toSecond())/3600.0 * speratorDistance
                    let taskView = TaskView(frame: CGRect(x: x, y: y, width: (screenWidth - 38)/7, height: height))
                    taskView.initialize(task: task, delegate: self)
//                    taskView.contentView.backgroundColor = .red
//                    taskView.task = task
//                    taskView.delegate = self
                    backgroundScrollView.addSubview(taskView)
                }
            }
        }
        
    }
    

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! TaskDetailVC
        vc.task = sender as? DisplayableTask
    }

}

extension PlanMainVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dates.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let date = dates[indexPath[1]]
        let components = Calendar.current.dateComponents([.year, .month, .day, .weekday], from: date)
        let dateCell = collectionView.dequeueReusableCell(withReuseIdentifier: "dateCell", for: indexPath) as! DateCVCell
        if Calendar.current.isDate(date, inSameDayAs: Date()) {
            dateCell.initialize(text: String(components.day!), textColor: .white, bgColor: .red)
        } else {
            dateCell.initialize(text: String(components.day!), textColor: .darkGray, bgColor: .white)
        }
        return dateCell
    }
}

extension PlanMainVC: UIScrollViewDelegate {
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print(initialScroll)
//        if initialScroll {
//            initialScroll = false
//        } else {
//            self.view.isUserInteractionEnabled = false
//        }
////        updateTimeLabel()
//    }
//
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard scrollView is UICollectionView else {
            return
        }
        if scrollView.contentOffset.x == 0.0 {
            dates.removeLast(7)
            var prevWeek: [Date] = []
            for i in (1...7).reversed() {
                prevWeek.append(Calendar.current.date(byAdding: .day, value: -1 * i, to: dates.first!)!)
            }
            dates.insert(contentsOf: prevWeek, at: 0)
            dateCollectionView.reloadData()
            dateCollectionView.contentOffset = CGPoint(x: dateCollectionView.frame.width, y: 0)
            displayTasks()
        } else if scrollView.contentOffset.x == 2 * dateCollectionView.frame.width {
            dates.removeFirst(7)
            var nextWeek: [Date] = []
            for i in (1...7) {
                nextWeek.append(Calendar.current.date(byAdding: .day, value: i, to: dates.last!)!)
            }
            dates.append(contentsOf: nextWeek)
            dateCollectionView.reloadData()
            dateCollectionView.contentOffset = CGPoint(x: dateCollectionView.frame.width, y: 0)
            displayTasks()
        }
        self.view.isUserInteractionEnabled = true
    }
}

extension PlanMainVC: TaskViewDelegate {
    func taskIsTapped(task: DisplayableTask) {
        self.performSegue(withIdentifier: "toTaskDetail", sender: task)
    }
    
    
}
