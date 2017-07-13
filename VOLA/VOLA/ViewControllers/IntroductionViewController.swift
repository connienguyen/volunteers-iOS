//
//  IntroductionViewController.swift
//  VOLA
//
//  Introduction slides shown once to user on first open. Each of
//  the slides show a benefit to the user having an account.
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

        // Uncomment for testing purposes
        DefaultsManager.shared.setBool(forKey: .shownIntro, value: true)
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

    private func loadScrollView() {
        scrollView.delegate = self
        scrollView.loadScrollPages(views: Intro.introSlides.map { $0.createSlideView() })
        pageControl.currentPage = 0
    }
}

fileprivate extension Intro.IntroDetail {
    func createSlideView() -> IntroSlideView {
        let view = IntroSlideView.instantiateFromXib()
        view.titleLabel.text = title
        view.detailLabel.text = detail
        view.slideImageView.image = UIImage(named: imageName)
        return view
    }
}

// MARK: - IBActions
extension IntroductionViewController {
    @IBAction func onPageControlPressed(_ sender: Any) {
        scrollView.scrollToPage(page: pageControl.currentPage)
    }

    @IBAction func onLoginPressed(_ sender: Any) {
        let loginVC: LoginViewController = UIStoryboard(.login).instantiateViewController()
        loginVC.introSender = true
        navigationController?.show(loginVC, sender: self)
    }

    @IBAction func onSkipPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension IntroductionViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.currentPage = scrollView.pageNumber()
    }
}
