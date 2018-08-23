//
//  GiphyStore.swift
//  eMoney Giphy
//
//  Created by Nikoloz Tatunashvili on 23.08.18.
//  Copyright © 2018 Nikoloz Tatunashvili. All rights reserved.
//

import Foundation
import Alamofire

typealias GiphyStoreCompletion = ((_ data: [SearchResult.GifData], _ update: Bool) -> ())

final class GiphyStore {
    private let host = "https://api.giphy.com"
    private let path = "/v1/gifs/search"
    private let apiKey = "OdW87lPDnU0PDPljMWCHmemwFiE5Sjde"
    private var query = ""
    private var limit = 30
    private var offset = 0
    private var oldDispatchWorkItem: DispatchWorkItem? = nil
    private var oldResult: SearchResult? = nil
    
    private let completion: GiphyStoreCompletion
    
    init(completion: @escaping GiphyStoreCompletion) {
        self.completion = completion
    }
    
    open func search(query: String?) {
        guard let query = query?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            completion([], false)
            return
        }
        guard query.isEmpty == false, self.query != query else {
            return
        }

        oldDispatchWorkItem?.cancel()

        self.query = query
        self.limit = 30
        self.offset = 0
        let request = loadGiphy()
        
        oldDispatchWorkItem = DispatchWorkItem {
            self.hendleRequest(request: request, update: false)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: oldDispatchWorkItem!)
    }
    
    open func nextPage() {
        if configurePagination(pagination: self.oldResult?.pagination) {
            let request = loadGiphy()
            self.hendleRequest(request: request, update: true)
        }
    }
    
    private var requestParameters: Parameters {
        return ["api_key": apiKey, "q": query, "limit": limit, "offset": offset]
    }
    
    private func loadGiphy() -> DataRequest {
        let request = AppSessionManager.request(host + path, method: .get, parameters: requestParameters)
        return request
    }
    
    private func hendleRequest(request: DataRequest, update: Bool) {
        request.responseData { response in
            switch response.result {
            case .success(let data):
                let decoder = JSONDecoder()
                do {
                    let result = try decoder.decode(SearchResult.self, from: data)
                    self.completion(result.data ?? [], update)
                    self.oldResult = result
                }
                catch {
                    print(error.localizedDescription)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func configurePagination(pagination: SearchResult.Pagination?) -> Bool {
        guard let pagination = pagination else {
            return false
        }
        let offset = (pagination.offset + pagination.count)
        if offset >= pagination.total_count { return false }
        self.offset = offset
        self.limit = 30
        return true
    }
}
