Synchronized
============

[![Version](https://img.shields.io/cocoapods/v/Synchronized.svg?style=flat)](http://cocoadocs.org/docsets/Synchronized)
[![License](https://img.shields.io/cocoapods/l/Synchronized.svg?style=flat)](http://cocoadocs.org/docsets/Synchronized)
[![Platform](https://img.shields.io/cocoapods/p/Synchronized.svg?style=flat)](http://cocoadocs.org/docsets/Synchronized)

Exposes Objective-C's @synchronized directive to Swift

Linking the Framework
---

Synchronized is available through [CocoaPods](http://cocoapods.org). To install it, simply add the following line to your Podfile:

    pod "Synchronized"

Once the framework is linked this Swift code should compile:
```swift
import Synchronized

let x = synchronized(NSObject()) { 0 }
```

Public API
---

```swift
public func synchronized(object: AnyObject, closure: () -> Void)
```

**Usage:**
```swift
synchronized(mutexObject) {
  // Code to run in your critical section
}
```

---

```swift
public func synchronized<T>(object: AnyObject, closure: () -> T) -> T
```

**Usage:**
```swift
let value = synchronized(threadUnsafeDictionary) {
  threadUnsafeDictionary[key]
}
```
