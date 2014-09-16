Synchronized
============

Exposes Objective-C's @synchronized directive to Swift

Public API
----------

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
