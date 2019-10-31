//
//  SurveysViewController.swift
//  Surveys
//
//  Created by Apple on 10/20/19.
//  Copyright © 2019 TamNguyen. All rights reserved.
//

import UIKit

class SurveysViewController: UIViewController {
    
    @IBOutlet weak var surveyButton: UIButton!
    @IBOutlet weak var collectionView : UICollectionView!
    @IBOutlet weak var layout: UICollectionViewFlowLayout!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    var pageControl: CustomImagePageControl!
    
    let dataSource = SurveyDataSource()
    var service : LoginService!
    
    lazy var viewModel : SurveyListViewModel = {
        let viewModel = SurveyListViewModel(dataSource: dataSource)
        return viewModel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        service = LoginService.shared
        activityIndicatorView.isHidden = true
        activityIndicatorView.color = ThemeManager.color.text
        
        setupViewModel()
        setupCollectionLayout()
        setupPageControl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if viewModel.dataSource?.data.value.count == 0 {
            refreshData()
        }
    }
    
    private func setupPageControl() {
        pageControl = CustomImagePageControl()
        pageControl.tintColor = .clear
        pageControl.pageIndicatorTintColor = .clear
        pageControl.currentPageIndicatorTintColor = .clear
        pageControl.transform = CGAffineTransform(rotationAngle: CGFloat.pi/2)
        pageControl.currentPage = 1
        pageControl.numberOfPages = 0
        let navHeight = navigationController?.navigationBar.frame.height ?? 44 + UIApplication.shared.statusBarFrame.height
        pageControl.frame = CGRect.init(x: view.frame.width - 44, y: 44, width: 44, height: view.frame.height-navHeight)
        view.addSubview(pageControl)
    }
    
    private func setupCollectionLayout() {
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = collectionView.frame.size
        
        collectionView.frame = .zero
        collectionView.backgroundColor = ThemeManager.color.background
        collectionView.dataSource = self.dataSource
        collectionView.delegate = self.dataSource
    }
    
    private func setupViewModel() {
        viewModel.dataSource?.delegate = self
        
        // observer data change
        dataSource.data.addAndNotify(observer: self) { [weak self] _ in
            guard let self = self else {return}
            self.collectionView.reloadData()
            
            if let numberOfPages = self.viewModel.dataSource?.data.value.count {
                if let pageControl = self.pageControl {
                    pageControl.numberOfPages = numberOfPages
                }
            }
            
            if self.activityIndicatorView.isAnimating {
                self.activityIndicatorView.isHidden = true
                self.activityIndicatorView.stopAnimating()
            }
            
            if self.dataSource.data.value.count == 0 {
                self.surveyButton.isHidden = true
            } else {
                self.surveyButton.isHidden = false
            }
        }
        
        // listioner error
        viewModel.onErrorHandling = { [weak self] error in
            guard let self = self else {return}
            NotificationManager.shared.showError(error.localizedDescription)
            
            if self.activityIndicatorView.isAnimating {
                self.activityIndicatorView.isHidden = true
                self.activityIndicatorView.stopAnimating()
            }
        }
    }
}

// MARK: - Function
extension SurveysViewController {
    fileprivate func login() {
        activityIndicatorView.isHidden = false
        activityIndicatorView.startAnimating()
        
        service.login(username: Configuration.USER_NAME, password: Configuration.PASSWORD) { [weak self] result in
            DispatchQueue.main.async {
                self?.activityIndicatorView.isHidden = true
                self?.activityIndicatorView.stopAnimating()
                
                if let value = result.value {
                    if let token = value.access_token, let type = value.token_type {
                        UserDefaults.standard.set(token, forKey: Configuration.OAUTH_ACCESS_TOKEN)
                        UserDefaults.standard.set(type, forKey: Configuration.OAUTH_TOKEN_TYPE)
                        UserDefaults.standard.synchronize()
                        
                        self?.viewModel.fetchData()
                    }
                } else if let error = result.error {
                    NotificationManager.shared.showError(error.localizedDescription)
                }
            }
        }
    }
    
    @objc fileprivate func fetchData() {
        if UserDefaults.standard.object(forKey: Configuration.OAUTH_ACCESS_TOKEN) == nil {
            login()
        } else {
            if viewModel.dataSource?.data.value.count == 0 {
                activityIndicatorView.isHidden = false
                activityIndicatorView.startAnimating()
            }
            
            viewModel.fetchData()
        }
    }
    
    private func refreshData() {
        if viewModel.dataSource?.isLoading == false {
            viewModel.dataSource?.data.value.removeAll()
            viewModel.dataSource?.paging.page = 1
            viewModel.dataSource?.isLoadMore = true
            fetchData()
        }
    }
    
    @IBAction func refreshButtonTapped() {
        refreshData()
    }
    
    @IBAction func surveyButtonTapped() {
        if let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DetailsSurveyVC") as?
            DetailsSurveyViewController {
            if let survey = self.viewModel.dataSource?.data.value.getElement(pageControl.currentPage) {
                vc.survey = survey
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}

// MARK: - SurveyDataSourceDelegate
extension SurveysViewController: SurveyDataSourceDelegate {
    func loadMore() {
        viewModel.fetchData()
    }
    
    func changeCurrentPage(_ index: Int) {
        pageControl.currentPage = index
    }
}
