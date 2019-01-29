//
//  YearConsumptionView.swift
//  SPHTechIOSAppTest
//
//  Created by Mukesh Verma on 29/01/19.
//  Copyright © 2019 Mukesh Verma. All rights reserved.
//

import UIKit

protocol YearConsumptionViewDelegate : class {
    
    func didSelectHeaderInSection(section : Int)
}

class YearConsumptionView: UITableViewHeaderFooterView {
    
    @IBOutlet weak var lblYearVolume: UILabel!
    @IBOutlet weak var lblYear: UILabel!
    @IBOutlet weak var btnExpandCollapse: UIButton!
    weak var delegate : YearConsumptionViewDelegate?
    var sectionNumber : Int = 0
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        self.addGestureRecognizer(tap)
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer? = nil) {
        // handling code
        delegate?.didSelectHeaderInSection(section: sectionNumber)
    }
    @IBAction func btnExpandCollaspeTapped(_ sender: Any) {
         delegate?.didSelectHeaderInSection(section: sectionNumber)
    }
    
    // Reuse Identifier String
    public class var reuseIdentifier: String {
        return "\(self.self)"
    }
    
    // Registers the Nib with the provided table
    public static func registerHeaderWithTable(_ table: UITableView) {
        let bundle = Bundle(for: self)
        let nib = UINib(nibName: self.reuseIdentifier , bundle: bundle)
        table.register(nib, forHeaderFooterViewReuseIdentifier: self.reuseIdentifier)
    }
    
    // setup UI
    public func setupUI(strTotalConsumtion : String, strYear : String, section : Int)
    {
        btnExpandCollapse.accessibilityIdentifier = "btnExpandCollapse\(section)"
        self.sectionNumber = section
        lblYear.text = strYear
        lblYearVolume.text = strTotalConsumtion
    }
    
    public func displayIconForExpCollapseForSection(intSection : Int?)
    {
        if let hasSec = intSection, hasSec == self.sectionNumber
        {
            self.btnExpandCollapse.setImage(UIImage.init(named: "collapseIcon"), for: .normal)
        }
        else
        {
            self.btnExpandCollapse.setImage(UIImage.init(named: "expandIcon"), for: .normal)
        }
    }
    
}

