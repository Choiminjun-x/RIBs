//
//  UserInfoViewController.swift
//  MyRIBsApp
//
//  Created by 최민준(Minjun Choi) on 9/5/25.
//

import UIKit
import RIBs
import SnapKit

// 사용자 Action 전달 -> Interactor
protocol UserInfoPresentableListener: AnyObject {
    func requestPageInfo()
    
    func didTapRefreshButton()
    func didTapUserInfoDetailButton(user: User?)
}

final class UserInfoViewController: UIViewController, UserInfoViewControllable, UserInfoPresentable {
    
    weak var listener: UserInfoPresentableListener? // Interactor로 이벤트를 전달하기 위함
    
    private var tableView: UITableView!
    private let refreshControl: UIRefreshControl = {
           let refreshControl = UIRefreshControl()
           refreshControl.addTarget(self, action: #selector(refreshButtonDidTap), for: .valueChanged)
           return refreshControl
       }()
    
    private var users: [User] = []

    init() {
        super.init(nibName: nil, bundle: nil)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    private func setupUI() {
        // 네비게이션 바 설정
        title = "사용자 목록"
        tabBarItem = UITabBarItem(title: "사용자 목록", image: UIImage(systemName: "person.2"), selectedImage: UIImage(systemName: "person.2.fill"))
        
        // iOS 스타일 배경색 설정
        view.backgroundColor = .systemGroupedBackground
        
        // 네비게이션 바 스타일링
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [
            .foregroundColor: UIColor.label
        ]
        
        self.view.do { superView in
            self.tableView = UITableView(frame: .zero, style: .insetGrouped).do {
                $0.backgroundColor = .clear
                $0.delegate = self
                $0.dataSource = self
                $0.register(UserInfoTableViewCell.self, forCellReuseIdentifier: "UserInfoCell")
                $0.refreshControl = self.refreshControl
                
                // iOS 스타일 설정
                $0.separatorStyle = .singleLine
                $0.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
                $0.rowHeight = UITableView.automaticDimension
                $0.estimatedRowHeight = 80
                
                superView.addSubview($0)
                $0.snp.makeConstraints {
                    $0.edges.equalToSuperview()
                }
            }
        }
    }
    
    @objc private func refreshButtonDidTap() {
        self.listener?.didTapRefreshButton()
    }
    
    
    // MARK: Presenter Method
    
    func updateUsers(_ users: [User]) {
        DispatchQueue.main.async { [weak self] in
            self?.users = users
            self?.tableView.reloadData()
            self?.refreshControl.endRefreshing()
        }
    }
    
    func showError(_ message: String) {
        DispatchQueue.main.async { [weak self] in
            let alert = UIAlertController(title: "오류", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default))
            self?.present(alert, animated: true)
            self?.refreshControl.endRefreshing()
        }
    }
}

extension UserInfoViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserInfoCell", for: indexPath) as? UserInfoTableViewCell else {
            return UITableViewCell()
        }
        
        let user = users[indexPath.row]
        cell.configure(with: user)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let user = self.users[indexPath.row]
        self.listener?.didTapUserInfoDetailButton(user: user)
    }
}
