//
//  JXKeyChainManager.swift
//  JXFoundation
//
//  Created by Admin on 5/18/20.
//


/**
 keychain item的类型，也就是kSecClass键的值            主要的Key
 
 kSecClassGenericPassword                                           kSecAttrAccount,kSecAttrService
 kSecClassInternetPassword                                           kSecAttrAccount, kSecAttrSecurityDomain, kSecAttrServer, kSecAttrProtocol,kSecAttrAuthenticationType,
                                         kSecAttrPortkSecAttrPath
 kSecClassCertificate                                                       kSecAttrCertificateType, kSecAttrIssuerkSecAttrSerialNumber
 kSecClassKey                                                                 kSecAttrApplicationLabel, kSecAttrApplicationTag, kSecAttrKeyType,kSecAttrKeySizeInBits, kSecAttrEffectiveKeySize
 kSecClassIdentity                                                           kSecClassKey,kSecClassCertificate
 */



import UIKit

let UUIDKeychainIdentifier = "UUIDKeychainIdentifier"


public class JXKeyChainManager: NSObject {
    
    public static let shared = JXKeyChainManager()
    let lock = NSLock()
    
    override init() {}
    
    // TODO: 创建查询条件
    public func createQuaryMutableDictionary(identifier: String) -> NSMutableDictionary {
        // 创建一个条件字典
        let keychainQuaryMutableDictionary = NSMutableDictionary.init(capacity: 0)
        // 设置条件存储的类型
        keychainQuaryMutableDictionary.setValue(kSecClassGenericPassword, forKey: kSecClass as String)
        // 设置存储数据的标记,kSecClassGenericPassword类型 必须有以下两个
        keychainQuaryMutableDictionary.setValue(identifier, forKey: kSecAttrService as String)
        keychainQuaryMutableDictionary.setValue(identifier, forKey: kSecAttrAccount as String)
        // 设置数据访问属性
        keychainQuaryMutableDictionary.setValue(kSecAttrAccessibleAfterFirstUnlock, forKey: kSecAttrAccessible as String)
        // 返回创建条件字典
        return keychainQuaryMutableDictionary
    }
    
    // TODO: 存储数据
    public func keyChainSaveData(data:Any ,withIdentifier identifier:String) -> Bool {
        lock.lock()
        defer {
            lock.unlock()
        }
        // 获取存储数据的条件
        let keyChainSaveMutableDictionary = self.createQuaryMutableDictionary(identifier: identifier)
        // 删除旧的存储数据
        SecItemDelete(keyChainSaveMutableDictionary)
        // 设置数据
        keyChainSaveMutableDictionary.setValue(NSKeyedArchiver.archivedData(withRootObject: data), forKey: kSecValueData as String)
        // 进行存储数据
        let saveState = SecItemAdd(keyChainSaveMutableDictionary, nil)
        
        return saveState == noErr
    }

    // TODO: 更新数据
    public func keyChainUpdata(data:Any ,identifier: String) -> Bool {
        lock.lock()
        defer {
            lock.unlock()
        }
        // 获取更新的条件
        let keyChainUpdataMutableDictionary = self.createQuaryMutableDictionary(identifier: identifier)
        // 创建数据存储字典
        let updataMutableDictionary = NSMutableDictionary.init(capacity: 0)
        // 设置数据
        updataMutableDictionary.setValue(NSKeyedArchiver.archivedData(withRootObject: data), forKey: kSecValueData as String)
        // 更新数据
        let updataStatus = SecItemUpdate(keyChainUpdataMutableDictionary, updataMutableDictionary)
        
        return updataStatus == noErr
    }
    
    
    // TODO: 获取数据
    public func keyChainSelectData(identifier: String)-> Any? {
        lock.lock()
        defer {
            lock.unlock()
        }
        var idObject: Any?
        // 获取查询条件
        let keyChainReadmutableDictionary = self.createQuaryMutableDictionary(identifier: identifier)
        // 提供查询数据的两个必要参数
        keyChainReadmutableDictionary.setValue(kCFBooleanTrue, forKey: kSecReturnData as String)
        keyChainReadmutableDictionary.setValue(kSecMatchLimitOne, forKey: kSecMatchLimit as String)
        // 创建获取数据的引用
        var cfTypeRef : CFTypeRef?
        // 通过查询是否存储在数据
        let readStatus = withUnsafeMutablePointer(to: &cfTypeRef) {
            SecItemCopyMatching(keyChainReadmutableDictionary, UnsafeMutablePointer($0))
        }
        if
            readStatus == errSecSuccess,
            let data = cfTypeRef as? Data {
            idObject = NSKeyedUnarchiver.unarchiveObject(with: data)
        }
        return idObject
    }
    
    
    
    // TODO: 删除数据
    public func keyChainDelete(identifier: String) -> Bool {
        lock.lock()
        defer {
            lock.unlock()
        }
        // 获取删除的条件
        let keyChainDeleteMutableDictionary = self.createQuaryMutableDictionary(identifier: identifier)
        // 删除数据
        return SecItemDelete(keyChainDeleteMutableDictionary) == errSecSuccess
    }
}
