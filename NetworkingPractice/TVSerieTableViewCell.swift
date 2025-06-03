//
//  TVSerieTableViewCell.swift
//  NetworkingPractice
//
//  Created by Oswaldo Maestra on 02/06/2025.
//

import UIKit

final class TVSerieTableViewCell: UITableViewCell {
    static let reuseIdentifier = "TVSerieTableViewCell"
    
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.numberOfLines = 0
        label.textAlignment = .left
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
    }()
    
    private lazy var upvotesLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.textColor = .secondaryLabel
        label.textAlignment = .right
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.textColor = .secondaryLabel
        label.textAlignment = .right
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        upvotesLabel.text = nil
        dateLabel.text = nil
    }
    
    private func setupUI() {
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(upvotesLabel)
        stackView.addArrangedSubview(dateLabel)
        
        contentView.addSubview(stackView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        let titleLabelWidthConstraint = titleLabel.widthAnchor.constraint(equalToConstant: contentView.bounds.width/2)
        titleLabelWidthConstraint.isActive = true
        titleLabelWidthConstraint.priority = .defaultHigh
        upvotesLabel.translatesAutoresizingMaskIntoConstraints = false
        let upvotesLabelWidthConstraint = upvotesLabel.widthAnchor.constraint(equalToConstant: contentView.bounds.width/4)
        upvotesLabelWidthConstraint.isActive = true
        upvotesLabelWidthConstraint.priority = .defaultHigh
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        let dateLabelWidthConstraint = dateLabel.widthAnchor.constraint(equalToConstant: contentView.bounds.width/4)
        dateLabelWidthConstraint.isActive = true
        dateLabelWidthConstraint.priority = .defaultHigh
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8).isActive = true
        stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8).isActive = true
        stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8).isActive = true
    }
    
    func configure(with tvSerie: TVSerieDetails) {
        titleLabel.text = "\(tvSerie.id) - \(tvSerie.name)"
        upvotesLabel.text = "\(tvSerie.noOfVotes)"
        dateLabel.text = "\(tvSerie.imdbRating)"
    }
}
