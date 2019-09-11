//
//  ViewController.swift
//  PageViewContrroller
//
//  Created by MB on 9/12/19.
//  Copyright © 2019 MB. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var contentView: UIView!
    
    let dataSource = ["ViewController One","ViewController Two","ViewController Three","ViewController Four"]
    
    var currentViewControllerIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        configurePageViewController()
    }
    
    
    func configurePageViewController(){
        
        
        guard let pageViewController = storyboard?.instantiateViewController(withIdentifier: String(describing: PageViewController.self)) as? PageViewController else{ return}
        
        
        
        
        pageViewController.delegate = self
        pageViewController.dataSource = self
        
       let control = UIPageControl.appearance()
        control.currentPageIndicatorTintColor = .black
        control.pageIndicatorTintColor = .lightGray
      //  UIPageControl.appearance().
        
        addChild(pageViewController)
        pageViewController.didMove(toParent: self)
        
        contentView.addSubview(pageViewController.view)
        
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        let views : [String : Any] = ["pageView" : pageViewController.view]
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[pageView]-0-|",
                                                                 options: NSLayoutConstraint.FormatOptions(rawValue: 0),
                                                                 metrics: nil,
                                                                 views: views)
        )
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[pageView]-0-|",
                                                                  options: NSLayoutConstraint.FormatOptions(rawValue: 0),
                                                                  metrics: nil,
                                                                  views: views)
        )
        
        guard let startingViewController = detailViewController(index : currentViewControllerIndex) else{return}
        
        
        
        pageViewController.setViewControllers([startingViewController], direction: .forward, animated: true)
        
    }
    
    
    func detailViewController(index : Int) -> DataViewController?{
        
        if index >= dataSource.count || dataSource.count == 0{
            return nil
        }
        
        guard let dataSourceVC = storyboard?.instantiateViewController(withIdentifier: String(describing: DataViewController.self)) as? DataViewController else{return nil}
        
        
        dataSourceVC.currentIndex = index
        
        dataSourceVC.displayText = dataSource[index]
        
        
        
        return dataSourceVC
    }

}


extension ViewController : UIPageViewControllerDelegate,UIPageViewControllerDataSource{
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return currentViewControllerIndex
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return dataSource.count
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let dataVC = viewController as? DataViewController
        
        guard var currentIndex = dataVC?.currentIndex
            else{
                return nil
        }
        
        currentViewControllerIndex = currentIndex
        
        if currentIndex == 0{
            return nil
        }
        
        currentIndex -= 1
        
        return detailViewController(index: currentIndex)
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        let dataVC = viewController as? DataViewController
        
        guard var currentIndex = dataVC?.currentIndex
            else{
                return nil
        }
        
        if currentIndex == dataSource.count{
            return nil
        }
        
        currentIndex += 1
        
        
        currentViewControllerIndex = currentIndex
        
        return detailViewController(index: currentIndex)
    }
    
    
    
    
}
