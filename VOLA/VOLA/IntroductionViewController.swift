//
//  IntroductionViewController.swift
//  VOLA
//
//  Created by Connie Nguyen on 6/10/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import UIKit

class IntroductionNavigationController: UINavigationController {}

class IntroductionViewController: UIViewController {

    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!

    private var viewDidLayout: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Commented out for testing purposes
        //UserDefaults.standard.set(true, forKey: DefaultsKey.shownIntro.rawValue)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.isNavigationBarHidden = true
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if !viewDidLayout {
            viewDidLayout = true
            loadScrollView()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        navigationController?.isNavigationBarHidden = false
    }

    @IBAction func onPageControlPressed(_ sender: Any) {
        let pageNumber = pageControl.currentPage
        var frame = scrollView.frame
        frame.origin.x = scrollView.frame.width * CGFloat(pageNumber)
        frame.origin.y = 0.0
        scrollView.scrollRectToVisible(frame, animated: true)
    }

    @IBAction func onLoginPressed(_ sender: Any) {
        let loginVC: LoginViewController = UIStoryboard(.login).instantiateViewController()
        loginVC.introSender = true
        navigationController?.show(loginVC, sender: self)
    }

    @IBAction func onSkipPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    private func loadScrollView() {
        let pageCount: CGFloat = 3.0

        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentSize = CGSize(width: scrollView.frame.width * pageCount, height: 1.0)

        // Add slides as subviews
        for i in 0..<Int(pageCount) {
            let frame = CGRect(x: scrollView.frame.width * CGFloat(i), y: 0.0, width: scrollView.frame.width, height: scrollView.frame.height)
            let introSlide = IntroSlideView.instantiateFromXib()
            introSlide.frame = frame
            introSlide.titleLabel.text = "slide-\(i).title.label".localized
            introSlide.detailLabel.text = "slide-\(i).detail.label".localized
            // TODO: Add correct image assets to introSlideView
            scrollView.addSubview(introSlide)
        }

        pageControl.currentPage = 0
    }
}

extension IntroductionViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let viewWidth: CGFloat = scrollView.frame.width
        let pageNumber = floor((scrollView.contentOffset.x - viewWidth * 0.5) / viewWidth) + 1
        pageControl.currentPage = Int(pageNumber)
    }
}
