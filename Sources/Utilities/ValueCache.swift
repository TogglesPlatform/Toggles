//  ValueCache.swift

import Foundation

final class ValueCache<Key: Hashable, Value> {
    private let wrapped = NSCache<WrappedKey, Entry>()
    
    func insert(_ value: Value, forKey key: Key) {
        wrapped.setObject(Entry(value: value), forKey: WrappedKey(key))
    }
    
    func value(forKey key: Key) -> Value? {
        wrapped.object(forKey: WrappedKey(key))?.value
    }
    
    func removeValue(forKey key: Key) {
        wrapped.removeObject(forKey: WrappedKey(key))
    }
    
    func evict() {
        wrapped.removeAllObjects()
    }
}

private extension ValueCache {
    final class WrappedKey: NSObject {
        private let key: Key

        init(_ key: Key) { self.key = key }

        override var hash: Int {
            key.hashValue
        }

        override func isEqual(_ object: Any?) -> Bool {
            guard let value = object as? WrappedKey else { return false }
            return value.key == key
        }
    }
}

private extension ValueCache {
    final class Entry {
        let value: Value

        init(value: Value) {
            self.value = value
        }
    }
}

extension ValueCache {
    subscript(key: Key) -> Value? {
        get { value(forKey: key) }
        set {
            switch newValue {
            case .some(let value):
                insert(value, forKey: key)
            case .none:
                removeValue(forKey: key)
            }
        }
    }
}
