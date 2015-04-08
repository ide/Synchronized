Synchronized
============

[![Version](https://img.shields.io/cocoapods/v/Synchronized.svg?style=flat)](http://cocoadocs.org/docsets/Synchronized)
[![License](https://img.shields.io/cocoapods/l/Synchronized.svg?style=flat)](http://cocoadocs.org/docsets/Synchronized)
[![Platform](https://img.shields.io/cocoapods/p/Synchronized.svg?style=flat)](http://cocoadocs.org/docsets/Synchronized)

Exposes Objective-C's @synchronized directive to Swift. Like the Objective-C directive, Synchronized acquires a mutex lock, runs some code, and releases the lock when the code completes or throws an exception.

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

Differences from `@synchronized`
---

Objective-C's `@synchronized` is a language-level directive and does not introduce a new function scope. This means that `return` statements cause the program to return from the surrounding function that contains the `@synchronized` directive.

```objc
- (void)returnDifferenceExample
{
    @synchronized {
        return;
    }
    NSLog(@"This line of code does not run.");
}
```

In contrast, Synchronized uses closures which do introduce a function scope. Returning from a closure passed to `synchronized` exits only the closure, not the surrounding function.

```swift
func returnDifferenceExample() {
    synchronized {
        return
    }
    println("This line of code does run.")
}
```

Synchronized's closures are annotated with the `@noclosure` attribute, which removes the need to access instance variables with `self.`, so it is similar to Objective-C's `@synchronized` directive in this regard.
