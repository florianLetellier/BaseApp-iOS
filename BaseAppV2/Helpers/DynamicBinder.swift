//
//  DynamicBinder.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/9/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

// MARK: - Typealias
typealias Listener<T> = (T) -> Void


/**
    Generic class for binding values and listening
    for value changes. This uses a single listener.
*/
class DynamicBinder<T> {
    
    // MARK: - Public Instance Attributes
    var listener: Listener<T>?
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    
    // MARK: - Initializers
    
    /**
        Initializes an instance of `DynamicBinder`.
     
        Parameter value: A `T` representing the value to
                         bind and listen for changes.
    */
    init(_ value: T) {
        self.value = value
    }
    
    
    // MARK: - Public Instance Methods
    
    /**
        Binds the listener for listening for changes
        to the value.
     
        - Parameter listener: A `Listener?` representing the
                              closure that gets invoked when
                              the value changes.
    */
    func bind(_ listener: Listener<T>?) {
        self.listener = listener
    }
    
    /**
        Binds the listener for listening for changes
        to the value. It immediately gets fired.
     
        - Parameter listener: A `Listener?` representing the
                              closure that gets invoked when
                              the value changes.
    */
    func bindAndFire(_ listener: Listener<T>?) {
        self.listener = listener
        listener?(value)
    }
}


/**
    Generic class for binding values and listening
    for value changes from multiple locations.
*/
class MultiDynamicBinder<T> {
    
    // MARK: - Public Instance Attributes
    var observers: [Observer<T>]
    var value: T {
        didSet {
            observers.forEach({ $0.listener?(value) })
        }
    }
    
    
    // MARK: - Initializers
    
    /**
        Initializes an instance of `MultiDynamicBinder`.
     
        - Parameter value: A `T` representing the value to
                           bind and listen for changes.
    */
    init(_ value: T) {
        self.value = value
        observers = [Observer]()
    }
    
    
    // MARK: - Public Instance Methods
    
    /**
        Binds the listener for listening for changes
        to the value.
     
        - Parameters:
            - listener: A `Listener?` representing the
                        closure that gets invoked when
                        the value changes.
            - observer: An `Any` representing the object
                        that registered the listener.
    */
    func bind(_ listener: Listener<T>?, for observer: Any) {
        let observe = Observer(observer: observer, listener: listener)
        observers.append(observe)
    }
    
    /**
        Binds the listener for listening for changes
        to the value. It immediately gets fired.
     
        - Parameters:
            - listener: A `Listener?` representing the
                        closure that gets invoked when
                        the value changes.
            - observer: An `Any` representing the object
                        that registered the listener.
    */
    func bindAndFire(_ listener: Listener<T>?, for observer: Any) {
        let observe = Observer(observer: observer, listener: listener)
        observers.append(observe)
        listener?(value)
    }
    
    /**
        Removes the listener the observer registered.
     
        - Parameter observer: An `Any` representing the object
                              that has a listener registered.
    */
    func removeListeners(for observer: Any) {
        let object1 = observer as AnyObject
        observers = observers.filter({ (observe: Observer) -> Bool in
            let object2 = observe.observer as AnyObject
            return object1 !== object2
        })
    }
}


/**
    A struct representing an observer
    and their registered listener.
*/
struct Observer<T> {
    
    // MARK: - Public Instance Attributes
    var observer: Any
    var listener: Listener<T>?
    
    
    // MARK: - Initializers
    
    /// Initializers an instance of `Observer`.
    init(observer: Any, listener: Listener<T>?) {
        self.observer = observer
        self.listener = listener
    }
}
