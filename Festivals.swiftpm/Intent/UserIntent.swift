import Foundation
import Combine
import SwiftUi

enum UserIntentState {
    case ready
    case testValidation(User)
    case updateModel
}

struct UserIntent {

    private var state = PassThroughSubject<UserIntentState,Never>()

    func addObserver(viewModel: UserViewModel){
        self.state.subscribe(viewModel)
    }

    func intentTestValidation(user: User){
        self.state.send(.testValidation(user))
    }

    func intentValidation(user: User) async -> Result<Bool,APIError> {
        let data = await API.userDAO().update(user: UserDTO(user))
        switch data {
            case .success(_):
                self.state.send(.updateModel)
                return .success(true)
            case .failure(let err):
                return .failure(err)
        }
    }
}