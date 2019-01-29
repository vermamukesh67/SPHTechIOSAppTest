//
//  QuaterInfoTableViewCell.swift
//  SPHTechIOSAppTest
//
//  Created by Mukesh Verma on 29/01/19.
//  Copyright © 2019 Mukesh Verma. All rights reserved.
//

import UIKit

class QuaterInfoTableViewCell: ReusableTableViewCell {
    @IBOutlet weak var lblQuarter: UILabel!
    @IBOutlet weak var lblVolume: UILabel!
    var objRecord : Records!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func prepareCell(record: Records) {
        self.objRecord = record
        setUpUI()
    }
    
    private func setUpUI() {
        guard let viewModel = self.objRecord else { return }
        
        self.lblVolume.text = viewModel.volume_of_mobile_data
        let year = viewModel.quarter?.components(separatedBy: "-")
        if year?.count ?? 0 > 0
        {
            let strQ = year?[1]
            self.lblQuarter.text = strQ
        }
    }
}

