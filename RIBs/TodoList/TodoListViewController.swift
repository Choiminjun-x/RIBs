//
//  TodoListViewController.swift
//  MyRIBsApp
//
//  Created by 최민준(Minjun Choi) on 9/5/25.
//

import UIKit
import RIBs
import SnapKit

protocol TodoListPresentableListener: AnyObject {
    func requestTodos()
    func didTapRefreshButton()
    func didTapTodoItem(todo: Todo?)
    func didToggleTodo(id: Int)
}

final class TodoListViewController: UIViewController, TodoListViewControllable, TodoListPresentable {
    
    weak var listener: TodoListPresentableListener?
    
    private var tableView: UITableView!
    private let refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshButtonDidTap), for: .valueChanged)
        return refreshControl
    }()
    
    private var todos: [Todo] = []
    private var filteredTodos: [Todo] = []
    private var isCompletedFilter: Bool? = nil // nil: 전체, true: 완료, false: 미완료
    
    // MARK: - Initialization
    
    init() {
        super.init(nibName: nil, bundle: nil)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // listener가 설정되었는지 확인 후 API 호출
        if listener != nil {
            self.listener?.requestTodos()
        }
    }
    
    // viewDidAppear에서도 한 번 더 확인 (안전장치)
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 데이터가 없고 listener가 설정되어 있다면 API 호출
        if todos.isEmpty && listener != nil {
            self.listener?.requestTodos()
        }
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        // 네비게이션 바 설정
        title = "할 일 목록"
        tabBarItem = UITabBarItem(
            title: "할 일", 
            image: UIImage(systemName: "list.bullet.rectangle"),
            selectedImage: UIImage(systemName: "list.bullet.rectangle.fill")
        )
        
        // iOS 스타일 배경색 설정
        view.backgroundColor = .systemGroupedBackground
        
        // 네비게이션 바 스타일링
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [
            .foregroundColor: UIColor.label
        ]
        
        // 필터 버튼 추가
        setupFilterButtons()
        
        self.view.do { superView in
            self.tableView = UITableView(frame: .zero, style: .insetGrouped).do {
                $0.backgroundColor = .clear
                $0.delegate = self
                $0.dataSource = self
                $0.register(TodoTableViewCell.self, forCellReuseIdentifier: "TodoCell")
                $0.refreshControl = self.refreshControl
                
                // iOS 스타일 설정
                $0.separatorStyle = .singleLine
                $0.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
                $0.rowHeight = UITableView.automaticDimension
                $0.estimatedRowHeight = 60
                
                superView.addSubview($0)
                $0.snp.makeConstraints {
                    $0.edges.equalToSuperview()
                }
            }
        }
    }
    
    private func setupFilterButtons() {
        let allButton = UIBarButtonItem(
            title: "전체",
            style: .plain,
            target: self,
            action: #selector(filterAllTapped)
        )
        
        let completedButton = UIBarButtonItem(
            title: "완료",
            style: .plain,
            target: self,
            action: #selector(filterCompletedTapped)
        )
        
        let pendingButton = UIBarButtonItem(
            title: "미완료",
            style: .plain,
            target: self,
            action: #selector(filterPendingTapped)
        )
        
        navigationItem.rightBarButtonItems = [allButton, completedButton, pendingButton]
    }
    
    // MARK: - Actions
    
    @objc private func refreshButtonDidTap() {
        self.listener?.didTapRefreshButton()
    }
    
    @objc private func filterAllTapped() {
        isCompletedFilter = nil
        updateFilteredTodos()
        updateFilterButtonStates()
    }
    
    @objc private func filterCompletedTapped() {
        isCompletedFilter = true
        updateFilteredTodos()
        updateFilterButtonStates()
    }
    
    @objc private func filterPendingTapped() {
        isCompletedFilter = false
        updateFilteredTodos()
        updateFilterButtonStates()
    }
    
    // MARK: - Helper Methods
    
    private func updateFilteredTodos() {
        if let filter = isCompletedFilter {
            filteredTodos = todos.filter { $0.completed == filter }
        } else {
            filteredTodos = todos
        }
        
        tableView.reloadData()
    }
    
    private func updateFilterButtonStates() {
        guard let rightBarButtonItems = navigationItem.rightBarButtonItems else { return }
        
        for (index, button) in rightBarButtonItems.enumerated() {
            switch index {
            case 0: // 전체
                button.tintColor = isCompletedFilter == nil ? .systemBlue : .systemGray
            case 1: // 완료
                button.tintColor = isCompletedFilter == true ? .systemBlue : .systemGray
            case 2: // 미완료
                button.tintColor = isCompletedFilter == false ? .systemBlue : .systemGray
            default:
                break
            }
        }
    }
    
    // MARK: - Presenter Methods
    
    func updateTodos(_ todos: [Todo]) {
        DispatchQueue.main.async { [weak self] in
            self?.todos = todos
            self?.updateFilteredTodos()
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

// MARK: - UITableViewDataSource & UITableViewDelegate

extension TodoListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredTodos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath) as? TodoTableViewCell else {
            return UITableViewCell()
        }
        
        let todo = filteredTodos[indexPath.row]
        cell.configure(with: todo)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let todo = filteredTodos[indexPath.row]
        self.listener?.didToggleTodo(id: todo.id)
    }
}
