//
//  HomeScreenVC.swift
//  SPHTechIOSAppTest
//
//  Created by Mukesh Verma on 29/01/19.
//  Copyright © 2019 Mukesh Verma. All rights reserved.
//

import UIKit

class HomeScreenVC: UIViewController {
    @IBOutlet weak var tblMobileConsumtion: UITableView!
    
    private var viewModel = HomeViewModel()
    var isRefreshInProgress = false
    var actViewLoader: UIActivityIndicatorView!
    var selectedSection : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareTableView()
        self.setUpNavBar()
        self.observeEvents()
        self.getMobileDataList()
    }
}

// Other useful methods for view setup
extension HomeScreenVC
{
    // Function to observe various event call backs from the viewmodel as well as Notifications.
    private func observeEvents() {
        viewModel.updateUI = { [weak self] in
            DispatchQueue.main.async {
                self?.tblMobileConsumtion.reloadData()
                self?.isRefreshInProgress = false
                self?.actViewLoader.stopAnimating()
            }
        }
    }
    
    private func setUpNavBar()
    {
        actViewLoader = UIActivityIndicatorView(style: .gray)
        actViewLoader.hidesWhenStopped = true
        actViewLoader.frame = CGRect.init(x: 0, y: 0, width: 20, height: 20   )
        let leftBarButton = UIBarButtonItem(customView: actViewLoader)
        self.navigationItem.leftBarButtonItem = leftBarButton
    }
    
    /// Prepare the table view.
    private func prepareTableView() {
        self.tblMobileConsumtion.tableHeaderView = UIView.init()
    QuaterInfoTableViewCell.registerWithTable(self.tblMobileConsumtion)
    YearConsumptionView.registerHeaderWithTable(self.tblMobileConsumtion)
    }
    
    // MARK: Load Mobile Data
    
    func getMobileDataList() {
        if isRefreshInProgress
        {
            return
        }
        if viewModel.shouldLoadMoreData()
        {
            actViewLoader.startAnimating()
            isRefreshInProgress = true
            viewModel.loadMoreData()
        }
    }
    
    func configureCellForIndexPath(indexPath : IndexPath, cell : QuaterInfoTableViewCell)
    {
        if let data = viewModel.getRecordBasedOnSection(section: indexPath.section, row: indexPath.row)
        {
            cell.prepareCell(record: data)
            if indexPath.row > 0
            {
                let data1 = viewModel.getRecordBasedOnSection(section: indexPath.section, row: indexPath.row - 1)!
                
                if  viewModel.isFirstRecordIsGreaterThanSecondRecord(record1: data1, record2: data)
                {
                    cell.lblVolume.textColor = .red
                    cell.lblQuarter.textColor = .red
                }
                else
                {
                    cell.lblVolume.textColor = .blue
                    cell.lblQuarter.textColor = .blue
                }
            }
        }
    }
}

// MARK: UITableView Delegate and DataSource

extension HomeScreenVC : UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.arrSortedYears.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getNumberOfRowsForForSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : QuaterInfoTableViewCell! = tableView.dequeueReusableCell(withIdentifier: "QuaterInfoTableViewCell") as? QuaterInfoTableViewCell
        cell.backgroundColor = .white
        self.configureCellForIndexPath(indexPath: indexPath, cell: cell)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if let hasSelectedSection = self.selectedSection, hasSelectedSection == indexPath.section
        {
            return 44
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView : YearConsumptionView  = tableView.dequeueReusableHeaderFooterView(withIdentifier: "YearConsumptionView") as! YearConsumptionView
        headerView.delegate = self
        headerView.setupUI(strTotalConsumtion: viewModel.getTotalConsumtionForSectionForYear(strYear: viewModel.arrSortedYears[section]), strYear: viewModel.arrSortedYears[section], section : section)
        headerView.displayIconForExpCollapseForSection(intSection: self.selectedSection)
        return headerView
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
}

extension HomeScreenVC : UIScrollViewDelegate
{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let isReachingEnd = scrollView.contentOffset.y >= 0
            && scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height)
        
        if isReachingEnd {
            self.getMobileDataList()
        }
    }
}

extension HomeScreenVC:YearConsumptionViewDelegate
{
    func didSelectHeaderInSection(section : Int)
    {
        if let hasSelectedSection = self.selectedSection, hasSelectedSection == section
        {
            self.selectedSection = nil
        }
        else
        {
          self.selectedSection = section
        }
        self.tblMobileConsumtion.reloadData()
    }
}

