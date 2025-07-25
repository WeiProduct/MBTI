import Foundation
import SwiftUI

protocol ViewModelProtocol: ObservableObject {
    associatedtype Input
    associatedtype Output
    
    var input: Input { get }
    var output: Output { get }
    
    func transform()
}

protocol NavigationProtocol: AnyObject {
    func navigate(to destination: NavigationDestination)
    func pop()
    func popToRoot()
}

enum NavigationDestination {
    case welcome
    case testIntro
    case test
    case result(MBTIType)
    case personalityTypes
    case history
    case profile
    case settings
    case typeDetail(MBTIType)
}