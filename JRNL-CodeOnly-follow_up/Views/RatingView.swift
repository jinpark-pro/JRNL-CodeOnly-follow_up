//
//  RatingView.swift
//  JRNL-CodeOnly-follow_up
//
//  Created by Jungjin Park on 2024-06-02.
//

import UIKit

class RatingView: UIStackView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtons()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButtons()
    }
    
    private var ratingButtons: [UIButton] = []
    private let buttonCount = 5
    
    private func setupButtons() {
        self.axis = .horizontal
        // remove buttons from view
        for button in ratingButtons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        // initialize array
        ratingButtons.removeAll()
        
        let filledStar = UIImage(systemName: "star.fill")
        let emptyStar = UIImage(systemName: "star")
        let highlightedStar = UIImage(systemName: "star.fill")?.withTintColor(.red, renderingMode: .alwaysOriginal)
        for _ in 0..<buttonCount {
            let button = UIButton()
            button.setImage(emptyStar, for: .normal)
            button.setImage(filledStar, for: .selected)
            button.setImage(highlightedStar, for: .highlighted)
            button.setImage(highlightedStar, for: [.highlighted, .selected])
            
            button.translatesAutoresizingMaskIntoConstraints = false
            addArrangedSubview(button)
            ratingButtons.append(button)
        }
    }
}
