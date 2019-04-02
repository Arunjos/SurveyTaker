//
//  SurveyCell.swift
//  SurveyTaker
//
//  Created by Arun Jose on 01/04/19.
//  Copyright © 2019 __ORGANIZATION NAME__. All rights reserved.
//

import UIKit
import Kingfisher

class SurveyCell: UITableViewCell {
    @IBOutlet weak private var surveyDescriptionLabel: UILabel!
    @IBOutlet weak private var surveyTitleLabel: UILabel!
    @IBOutlet weak private var surveyImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setupCell(for survey: Survey) {
        self.surveyTitleLabel.text = survey.title
        self.surveyDescriptionLabel.text = survey.description
        if let urlString = survey.bgImage, let url = URL(string: "\(urlString)l") {
            self.surveyImageView.kf.setImage(with: url)
        }
    }
}
