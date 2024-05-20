//
//  CustomTableViewCell.swift
//  JRNL-CodeOnly-follow_up
//
//  Created by Jungjin Park on 2024-05-20.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    var stackView: UIStackView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.backgroundColor = .systemCyan
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.widthAnchor.constraint(equalToConstant: 252),
            stackView.heightAnchor.constraint(equalToConstant: 44),
        ])
    }
}
