import Foundation
import Combine

class CreneauViewModel: Subscriber, ObservableObject, CreneauObserver {

    private var model: Creneau
    var copyModel: Creneau
    var id: String
    @Published var debut: String
    @Published var fin: String
    @Published var error : INPUTError = .noError
    
    init(model: Creneau){
        self.copyModel = model.copy()
        self.id = copyModel.id
        self.debut = copyModel.debut
        self.fin = copyModel.fin
        self.model = model
        self.copyModel.observer = self  
    }

    func change(debut: String) {
        self.debut = debut
    }

    func change(fin: String) {
        self.fin = fin
    }
    
    func receive(subscription: Subscription) {
        subscription.request(.unlimited)
    }
    
    func receive(input: CreneauIntentState) -> Subscribers.Demand {
        switch(input){
            case .ready:
                break
            case .updateModel:
                self.model.paste(self.copyModel)
            case .testValidation(let creneau):
                self.copyModel.debut = creneau.debut
                self.copyModel.fin = creneau.fin
        }
        return .none
    }
    
    func receive(completion: Subscribers.Completion<Never>) {
        return
    }

    func getCreneauFromViewModel() -> Creneau {
        return Creneau(id: id, debut: debut, fin: fin)
    }
}