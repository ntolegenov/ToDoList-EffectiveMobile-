

import SwiftUI
import CoreData

protocol TodoDetailRouterProtocol: AnyObject {
    func dismissView()
}

class TodoDetailRouter: TodoDetailRouterProtocol {
    weak var viewController: UIViewController?
    
    func dismissView() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}
