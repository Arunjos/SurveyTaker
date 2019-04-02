//
//  SurveyViewController.swift
//  SurveyTaker
//
//  Created by Arun Jose on 30/03/19.
//  Copyright © 2019 __ORGANIZATION NAME__. All rights reserved.
//

import UIKit

class SurveyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    @IBOutlet weak var surveyTableView: UITableView!
    var viewModel:SurveyViewModel = SurveyViewModelFromSurvey()
    
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
    
    
    //MARK: Setup Methods
    func setupView(){
        
        surveyTableView.dataSource = self
        surveyTableView.delegate = self
        surveyTableView.register(UINib(nibName: "SurveyCell", bundle: nil), forCellReuseIdentifier: Constants.SurveyCellID)
        
        surveyTableView.isPagingEnabled = true
        
        //        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        //        self.view.addSubview(activityIndicator)
        //        activityIndicator.snp.makeConstraints{(make) -> () in
        //            make.center.equalTo(deliveryListTableView)
        //        }
        //        activityIndicator.isHidden = true
    }
    
    func setupViewModel() {
        viewModel.noOfSurveys.bind{[unowned self] count in
            DispatchQueue.main.async {
                self.surveyTableView.reloadData()
            }
        }
        viewModel.isSurveyDataLoading.bind{[unowned self] show in
            if show{
                self.surveyTableView.isHidden = true
                //                self.activityIndicator.startAnimating()
            }else{
                DispatchQueue.main.async {
                    self.surveyTableView.isHidden = false
                    //                    self.activityIndicator.stopAnimating()
                }
            }
        }
        viewModel.error.bind{[unowned self] errorMessage in
            if errorMessage == ""{
                return
            }
            let alertController = UIAlertController(title: "Error", message: errorMessage, preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
            
        }
        viewModel.fetchSurvey()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.noOfSurveys.value
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:Constants.SurveyCellID, for: indexPath) as? SurveyCell
        print(cell?.surveyDescriptionLabel)
        let surveyDetail = viewModel.getSurveyDetail(atIndex: indexPath)
        cell?.setupCell(for: surveyDetail!)
        
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return tableView.frame.size.height
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        UIView.animate(withDuration: 0.8) {
            cell.transform = CGAffineTransform.identity
        }
    }
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        
//        // vertical
//        let maximumVerticalOffset = scrollView.contentSize.height - scrollView.frame.height
//        let currentVerticalOffset = scrollView.contentOffset.y
//        let percentageVerticalOffset = Double(currentVerticalOffset / maximumVerticalOffset)
//        
//        var pecentageOffset = 0.0
//        if let visbleCells = self.surveyTableView.indexPathsForVisibleRows, let topVisibleIndexPath = visbleCells[safe:0] {
//            pecentageOffset = Double((1/self.viewModel.noOfSurveys.value) * (topVisibleIndexPath.row+1))
//            let topCellView = self.surveyTableView.cellForRow(at: topVisibleIndexPath)
//            topCellView?.imageView?.transform = CGAffineTransform(scaleX: CGFloat((pecentageOffset-percentageVerticalOffset)/pecentageOffset),
//                                                                   y: CGFloat((pecentageOffset-percentageVerticalOffset)/pecentageOffset))
//        }
//        if let visibleCells =
//            self.surveyTableView.indexPathsForVisibleRows, let nextVisibleIndexPath = visibleCells[safe:1] {
//            let nextCellView = self.surveyTableView.cellForRow(at: nextVisibleIndexPath)
//            nextCellView?.imageView?.transform = CGAffineTransform(scaleX: CGFloat(percentageVerticalOffset/pecentageOffset), y: CGFloat(percentageVerticalOffset/pecentageOffset))
//        }
//
//    }
    
}
