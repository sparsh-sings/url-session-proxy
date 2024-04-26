//
//  ProxyManager.swift
//  urlsessionProxy
//
//  Created by Sparsh Singh on 26/04/24.
//

import Foundation

class ProxyManager {
    static let shared = ProxyManager()
    
    var proxyConfiguration: URLSessionConfiguration?
    
    func configureProxy(server: String, port: Int, username: String? = nil, password: String? = nil, proxyType: ProxyType) {
        let proxyConfiguration = URLSessionConfiguration.default
        
        switch proxyType {
        case .http:
            let proxyDict: [AnyHashable : Any] = [
                kCFNetworkProxiesHTTPEnable: true,
                kCFNetworkProxiesHTTPProxy: server,
                kCFNetworkProxiesHTTPPort: port
            ]
            proxyConfiguration.connectionProxyDictionary = proxyDict
        case .socks5:
            #if os(macOS)
            let proxyDict: [AnyHashable : Any] = [
                kCFNetworkProxiesSOCKSEnable: true,
                kCFNetworkProxiesSOCKSProxy: server,
                kCFNetworkProxiesSOCKSPort: port
            ]
            proxyConfiguration.connectionProxyDictionary = proxyDict
            #endif
        }
        
        if let username = username, let password = password {
            proxyConfiguration.httpShouldUsePipelining = true
            proxyConfiguration.httpShouldSetCookies = true
            proxyConfiguration.httpCookieAcceptPolicy = .onlyFromMainDocumentDomain
            proxyConfiguration.connectionProxyDictionary?[kCFProxyUsernameKey] = username
            proxyConfiguration.connectionProxyDictionary?[kCFProxyPasswordKey] = password
        }
        
        self.proxyConfiguration = proxyConfiguration
    }
    
    enum ProxyType {
        case http, socks5
    }
}
