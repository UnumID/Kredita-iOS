import SwiftUI

public struct AlertErrorHandler: ErrorHandler {
    
    private let id = UUID()
    
    public func handle<T: View>(
        _ error: Binding<Error?>,
        in view: T,
        recoveryHandler: @escaping (RecoveryOption) -> Void,
        signOutHandler: @escaping () -> Void
    ) -> AnyView {
        guard error.wrappedValue?.resolveCategory() != .requiresSignout else {
            signOutHandler()
            return AnyView(view)
        }
        
        var presentation = error.wrappedValue.map {
            Presentation(
                id: id,
                error: $0,
                recoveryHandler: { recoveryOption in
                    DispatchQueue.main.async {
                        recoveryHandler(recoveryOption)
                    }
                }
            )
        }
        
        let binding = Binding(
            get: { presentation },
            set: { possiblePresentation in
                presentation = possiblePresentation
                if possiblePresentation == nil {
                    error.wrappedValue = nil
                }
            }
        )
        
        return AnyView(view.alert(item: binding, content: makeAlert))
    }
}

private extension AlertErrorHandler {
    struct Presentation: Identifiable {
        let id: UUID
        let error: Error
        let recoveryHandler: (RecoveryOption) -> Void
    }
    
    func makeAlert(for presentation: Presentation) -> Alert {
        let error = presentation.error
        
        switch error.resolveCategory() {
        case let .recoverable(recoveryOption):
            return Alert(
                title: Text("An error occured"),
                message: Text(error.localizedDescription),
                primaryButton: .default(Text("Dismiss")),
                secondaryButton: .default(Text(recoveryOption.description),
                                          action: { presentation.recoveryHandler(recoveryOption) })
            )
        case .nonRecoverable:
            return Alert(
                title: Text("An error occured"),
                message: Text(error.localizedDescription),
                dismissButton: .default(Text("Dismiss"))
            )
        case .requiresSignout:
            assertionFailure("Should have logged out")
            return Alert(title: Text("Logging out..."))
        }
    }
}

public enum ErrorCategory: Equatable {
    case nonRecoverable
    case recoverable(recoveryOption: RecoveryOption)
    case requiresSignout
}

public protocol CategorizedError: Error {
    var category: ErrorCategory { get }
}

public extension Error {
    func resolveCategory() -> ErrorCategory {
        guard let categorized = self as? CategorizedError else {
            return .nonRecoverable
        }
        
        return categorized.category
    }
}

public protocol ErrorHandler {
    func handle<T: View>(
        _ error: Binding<Error?>,
        in view: T,
        recoveryHandler: @escaping (RecoveryOption) -> Void,
        signOutHandler: @escaping () -> Void
    ) -> AnyView
}

public struct ErrorHandlerEnvironmentKey: EnvironmentKey {
    public static var defaultValue: ErrorHandler = AlertErrorHandler()
}

public struct SignOutHandlerEnvironmentKey: EnvironmentKey {
    public static var defaultValue: () -> Void = {}
}

public extension EnvironmentValues {
    var errorHandler: ErrorHandler {
        get { self[ErrorHandlerEnvironmentKey.self] }
        set { self[ErrorHandlerEnvironmentKey.self] = newValue }
    }
    
    var signOutHandler: () -> Void {
        get { self[SignOutHandlerEnvironmentKey.self] }
        set { self[SignOutHandlerEnvironmentKey.self] = newValue }
    }
}

public struct RecoveryOption: Identifiable, Equatable, CustomStringConvertible {
    public let id: String
    public let description: String
    
    public init(id: String, description: String) {
        self.id = id
        self.description = description
    }
}

public extension RecoveryOption {
    static let retry = RecoveryOption(id: "co.unumid.ErrorHandling.retry", description: "Retry")
}

public extension View {
    func handlingErrors(
        using handler: ErrorHandler
    ) -> some View {
        environment(\.errorHandler, handler)
    }
}

public struct ErrorEmittingViewModifier: ViewModifier {
    @Environment(\.errorHandler) var errorHandler
    @Environment(\.signOutHandler) var signOutHandler
    
    var error: Binding<Error?>
    var recoveryHandler: (RecoveryOption) -> Void
    
    public func body(content: Content) -> some View {
        errorHandler.handle(error,
                            in: content,
                            recoveryHandler: recoveryHandler,
                            signOutHandler: signOutHandler)
    }
}

public extension View {
    func emittingError(
        _ error: Binding<Error?>,
        recoveryHandler: @escaping (RecoveryOption) -> Void
    ) -> some View {
        modifier(ErrorEmittingViewModifier(
            error: error,
            recoveryHandler: recoveryHandler
        ))
    }
}
