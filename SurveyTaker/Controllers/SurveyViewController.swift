//
//  SurveyViewController.swift
//  SurveyTaker
//
//  Created by Arun Jose on 30/03/19.
//  Copyright © 2019 __ORGANIZATION NAME__. All rights reserved.
//

import UIKit
import CHIPageControl

class SurveyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    @IBOutlet private var pageControl: CHIPageControlAleppo!
    @IBOutlet weak private var surveyTableView: UITableView!
    @IBOutlet weak private var activityIndicator: UIActivityIndicatorView!
    var viewModel: SurveyViewModel = SurveyViewModelFromSurvey()
    var lastVisibilCellIndexPath = IndexPath(row: 0, section: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupViewModel()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Setup Methods
    func setupView() {
        self.surveyTableView.isHidden = true
        surveyTableView.dataSource = self
        surveyTableView.delegate = self
        surveyTableView.register(UINib(nibName: "SurveyCell",
                                       bundle: nil),
                                 forCellReuseIdentifier: Constants.SurveyCellID)
        // Configure page control
        pageControl.transform = pageControl.transform.rotated(by: .pi / 2)
    }
    
    func setupViewModel() {
        // Perform when latest survey fetch
        viewModel.noOfSurveys.bind {[unowned self] rowCount in
            DispatchQueue.main.async {
                if rowCount != 0 {
                    let currentSelectdPage = self.pageControl.currentPage
                    //Add new survey cells
                    self.surveyTableView.insertRows(at: self.viewModel.getPrefectchedIndexPaths(), with: .none)
                    // Update page controller
                    self.updatePageController(WithCount: self.viewModel.noOfSurveys.value,
                                              WithCurrentPage: Double(currentSelectdPage))
                    // Hide Show logic
                    self.surveyTableView.tableFooterView?.isHidden = true
                    self.surveyTableView.isHidden = false
                }
            }
        }
        // To indicate the survey fetch api progress
        viewModel.isSurveyDataLoading.bind { [unowned self] show in
            DispatchQueue.main.async {
                if show {
                    self.activityIndicator.startAnimating()
                } else {
                    self.activityIndicator.stopAnimating()
                }
            }
        }
        // To show error if anything fails
        viewModel.error.bind {[unowned self] errorMessage in
            if errorMessage.isEmpty {
                return
            }
            let alertController = UIAlertController(title: "Error",
                                                    message: errorMessage,
                                                    preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
            
        }
        // Intial fetch function
        viewModel.fetchSurveys()
    }
    
    func updatePageController(WithCount pageCount: Int, WithCurrentPage currentPage: Double = 0) {
        pageControl.numberOfPages = pageCount
        pageControl.radius = 5
        pageControl.inactiveTransparency = 0
        pageControl.borderWidth = 1
        pageControl.tintColor = .white
        pageControl.currentPageTintColor = .white
        pageControl.padding = 6
        pageControl.progress = currentPage
    }
    
    @IBAction private func refreshButtonClicked(_ sender: Any) {
        self.pageControl.progress = 0
        viewModel.refreshSurveys()
        self.surveyTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.noOfSurveys.value
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.SurveyCellID, for: indexPath) as? SurveyCell
        let surveyDetail = viewModel.getSurveyDetail(atIndex: indexPath)
        if let survey = surveyDetail {
            cell?.surveyTapCallBack = { [unowned self] in
                print(indexPath)
                self.performSegue(withIdentifier: "takeSurveySegueID", sender: nil)
            }
            cell?.setupCell(for: survey)
        }
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.bounds.height
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // Animation
        cell.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        UIView.animate(withDuration: 0.8) {
            cell.transform = CGAffineTransform.identity
        }
        // Update page control
        pageControl.progress = Double(indexPath.row)
        
        // If last row then fetch more rows
        let lastSectionIndex = tableView.numberOfSections - 1
        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
        if indexPath.section == lastSectionIndex
            && indexPath.row == lastRowIndex
            && !viewModel.isSurveyDataLoading.value {
            let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
            spinner.hidesWhenStopped = true
            spinner.startAnimating()
            spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))

            self.surveyTableView.tableFooterView = spinner
            self.surveyTableView.tableFooterView?.isHidden = false
            lastVisibilCellIndexPath = indexPath
            self.viewModel.fetchSurveys()
        }
    }

}
