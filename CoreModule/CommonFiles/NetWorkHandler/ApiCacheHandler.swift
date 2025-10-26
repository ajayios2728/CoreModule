////
////  ApiCacheHandler.swift
////  Mutasil
////
////  Created by SCT on 03/09/25.
////
//
import Foundation
import SwiftData


@available(iOS 17, *)
@Model
final class APICache {
    @Attribute(.unique) var key: String        // unique API identifier (url + params hash)
    var json: Data                             // raw API response
    var timestamp: Date                        // when it was saved

    init(key: String, json: Data, timestamp: Date = Date()) {
        self.key = key
        self.json = json
        self.timestamp = timestamp
    }
}


@available(iOS 17, *)
final class APICacheStore {
    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    // MARK: - Generic Save
    func save<T: Codable>(key: String, model: T) {
        do {
            let data = try JSONEncoder().encode(model)
            if let existing = fetchCache(key: key) {
                existing.json = data
                existing.timestamp = Date()
            } else {
                let cache = APICache(key: key, json: data)
                context.insert(cache)
            }
            try context.save()
        } catch {
            print("Failed to encode model: \(error)")
        }
    }

    // MARK: - Generic Fetch
    func get<T: Codable>(key: String, as type: T.Type) -> T? {
        guard let data = fetchCache(key: key)?.json else { return nil }
        do {
            let model = try JSONDecoder().decode(T.self, from: data)
            return model
        } catch {
            print("Failed to decode model: \(error)")
            return nil
        }
    }

    // MARK: - Clear
    func clear(key: String) {
        if let existing = fetchCache(key: key) {
            context.delete(existing)
            try? context.save()
        }
    }

    func clearAll() {
        let descriptor = FetchDescriptor<APICache>()
        if let results = try? context.fetch(descriptor) {
            for item in results { context.delete(item) }
            try? context.save()
        }
    }

    // MARK: - Private helper
    private func fetchCache(key: String) -> APICache? {
        let descriptor = FetchDescriptor<APICache>(
            predicate: #Predicate { $0.key == key }
        )
        return try? context.fetch(descriptor).first
    }
}
