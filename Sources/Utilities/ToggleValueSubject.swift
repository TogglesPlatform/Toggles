//  ToggleValueSubject.swift

import Combine
import Foundation

final public class ToggleValueSubject: Subject {
    
    public typealias Output = Value
    public typealias Failure = Never

    internal let wrapped: CurrentValueSubject<Value, Never>

    public internal(set) var value: Value {
        get { wrapped.value }
        set { wrapped.value = newValue }
    }

    public init(_ value: Value) {
        wrapped = .init(value)
    }

    public func receive<S>(subscriber: S) where S : Subscriber, Never == S.Failure, Value == S.Input {
        wrapped.receive(subscriber: subscriber)
    }

    public func send(_ input: Value) {
        wrapped.send(input)
    }
    
    public func send(completion: Subscribers.Completion<Never>) {
        wrapped.send(completion: completion)
    }
    
    public func send(subscription: Subscription) {
        wrapped.send(subscription: subscription)
    }
}
