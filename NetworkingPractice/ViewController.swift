//
//  ViewController.swift
//  NetworkingPractice
//
//  Created by Oswaldo Maestra on 14/05/2025.
//

import UIKit
import Combine

class ViewController: UIViewController {
    var service: TVSeriesService!

    var dataSource = [TVSerieDetails]() {
        didSet {
            tableView.reloadData()
        }
    }
    private var cancellables: Set<AnyCancellable> = []
    
    private let tableView = UITableView()
    
    lazy var upvotedButton: UIButton = {
        let upvotedButton = UIButton(configuration: .plain())
        upvotedButton.setTitle("Most Upvoted", for: .normal)
        upvotedButton.addTarget(self, action: #selector(handleUpvotedButtonTapped), for: .touchUpInside)
        
        return upvotedButton
    }()
    
    lazy var mostRecentButton: UIButton = {
        let upvotedButton = UIButton(configuration: .plain())
        upvotedButton.setTitle("IMDB Rating", for: .normal)
        upvotedButton.addTarget(self, action: #selector(handleRecentButtonTapped), for: .touchUpInside)
        
        return upvotedButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadTVSeriesAsync()
//        loadTVSeriesReactive()
    }
    
    private func loadTVSeriesAsync() {
        Task { @MainActor in
            let tvSeries = try await service.loadAllTVSeries()
            self.dataSource = tvSeries.sorted(by: { $0.id < $1.id })
        }
    }
    
    private func loadTVSeriesReactive() {
        service.loadAllTVSeriesPublisher()
            .receive(on: DispatchQueue.main)
            .sink { result in
                print(result)
            } receiveValue: { series in
                self.dataSource = series
            }
            .store(in: &cancellables)
    }
    
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white
        
        let filterButtonsStackView: UIStackView = {
            let stackView = UIStackView(arrangedSubviews: [upvotedButton, mostRecentButton])
            stackView.axis = .horizontal
            stackView.distribution = .fillEqually
            return stackView
        }()
        
        // Setup table view
        tableView.register(TVSerieTableViewCell.self, forCellReuseIdentifier: TVSerieTableViewCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.tableFooterView = UIView()
        
        view.addSubview(filterButtonsStackView)
        view.addSubview(tableView)
        
        filterButtonsStackView.translatesAutoresizingMaskIntoConstraints = false
        filterButtonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        filterButtonsStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        filterButtonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: filterButtonsStackView.bottomAnchor, constant: 8).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        self.view = view
    }
}

extension ViewController {
    @objc private func handleUpvotedButtonTapped(_ sender: UIButton) {
        self.dataSource = self.dataSource.sorted { $0.noOfVotes > $1.noOfVotes }
    }
    
    @objc private func handleRecentButtonTapped(_ sender: UIButton) {
        self.dataSource = self.dataSource.sorted { $0.imdbRating > $1.imdbRating }
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TVSerieTableViewCell.reuseIdentifier, for: indexPath) as? TVSerieTableViewCell else {
            return UITableViewCell()
        }
        
        cell.configure(with: dataSource[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let titleLabel = UILabel()
        let upvotesLabel = UILabel()
        let publishedDateLabel = UILabel()
        
        titleLabel.text = "Title"
        upvotesLabel.text = "No. of votes"
        publishedDateLabel.text = "IMDB Rating"
        
        let view = UIView()
        view.backgroundColor = .white
        let stackView = UIStackView(arrangedSubviews: [
            titleLabel,
            upvotesLabel,
            publishedDateLabel
        ])
        stackView.spacing = 8
        
        view.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
        stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 8).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8).isActive = true
        stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8).isActive = true
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
}
