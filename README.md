Synchronized
============

Exposes Objective-C's @synchronized directive to Swift

Public API
----------
`public func synchronized<T>(object: AnyObject, closure: () -> T) -> T`

**Usage:**
```
let value = synchronized(threadUnsafeDictionary) {
  threadUnsafeDictionary[key]
}
```

---

`public func synchronized(object: AnyObject, closure: () -> Void)`

**Usage:**
```
synchronized(mutexObject) {
  // Code to run in your critical section
}
```
