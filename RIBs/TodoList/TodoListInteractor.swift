//
//  TodoListInteractor.swift
//  MyRIBsApp
//
//  Created by 최민준(Minjun Choi) on 9/5/25.
//

import Foundation
import RIBs

protocol TodoListRouting: ViewableRouting {
    func attachTodoListDetail()
    func detachTodoListDetail()
}

protocol TodoListPresentable: Presentable {
    var listener: TodoListPresentableListener? { get set }
    
    // 정보 업데이트 -> ViewController 전달
    func updateTodos(_ todos: [Todo])
    func showError(_ message: String)
}

public protocol TodoListListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class TodoListInteractor: PresentableInteractor<TodoListPresentable>, TodoListInteractable, TodoListPresentableListener {
    
    var router: TodoListRouting?
    var listener: TodoListListener?
    
    private var todoService = TodoService()
    private var todos: [Todo] = []
    
    override init(presenter: TodoListPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    // RIB이 활성화될 때 자동으로 호출
    override func didBecomeActive() {
        super.didBecomeActive()
        // 최초 데이터 로드
        self.requestTodos()
    }
    
    
    // MARK: - PresentableListener
    
    func requestTodos() {
        self.requestTodoList()
    }
    
    func didTapRefreshButton() {
        self.requestTodoList()
    }
    
    func didTapTodoItem(todo: Todo?) {
        // TODO: Todo 상세 화면으로 이동
        router?.attachTodoListDetail()
    }
    
    func didToggleTodo(id: Int) {
        if let index = todos.firstIndex(where: { $0.id == id }) {
            todos[index].completed.toggle()
            presenter.updateTodos(todos)
        }
    }
    
    
    // MARK: - Private Methods
    
    private func requestTodoList() {
        todoService.fetchTodos { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let todos):
                self.todos = todos
                self.presenter.updateTodos(todos)
                
            case .failure(let error):
                self.presenter.showError("할 일 목록을 불러오는데 실패했습니다: \(error.localizedDescription)")
            }
        }
    }
}
