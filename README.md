Synchronized
============

Exposes Objective-C's @synchronized directive to Swift

Linking the Framework
---

Drag Synchronized.framework into the Frameworks group of your open Xcode project. Xcode gives you the option to copy the framework, which you should probably do unless you have a different way of managing frameworks. Then click on your project file and select the General tab. Go to Embedded Binaries and add Synchronized.framework.

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
