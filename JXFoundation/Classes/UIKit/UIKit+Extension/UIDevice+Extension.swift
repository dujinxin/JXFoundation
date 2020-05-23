//
//  UIDevice+Extension.swift
//  Star
//
//  Created by 杜进新 on 2018/6/1.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit
//广告信息
import AdSupport
//电话网络运营商信息
import CoreTelephony
//Wi-Fi，VPN等功能需要
import SystemConfiguration.CaptiveNetwork
import NetworkExtension


public extension UIDevice {
    
    ///综合一下几个ID，使用idfv，存储在keychain中，以保持idfv跟设备绑定，保持唯一
    var idfvInKeychain: String {
        if
            let data = JXKeyChainManager.shared.keyChainSelectData(identifier: UUIDKeychainIdentifier),
            let idfvStr = data as? String {
            return idfvStr
        } else {
            let _ = JXKeyChainManager.shared.keyChainDelete(identifier: UUIDKeychainIdentifier)
            let _ = JXKeyChainManager.shared.keyChainSaveData(data: self.idfv, withIdentifier: UUIDKeychainIdentifier)
            return self.idfv
        }
    }
    /// 每次都不一样
    var uuid: String {
        return NSUUID().uuidString
    }
    /// 卸载之后，会变；不卸载每次启动获取到的一样
    var idfv: String {
        return self.identifierForVendor?.uuidString ?? ""
    }
    /// 广告ID：同设备，所有app 都是一个值
    var idfa: String {
        return ASIdentifierManager.shared().advertisingIdentifier.uuidString
    }
    var modelName : String {
        get{
            var systemInfo = utsname()
            uname(&systemInfo)
            
            let machineMirror = Mirror(reflecting: systemInfo.machine)
            let identifier = machineMirror.children.reduce("") { identifier, element in
                guard
                    let value = element.value as? Int8, value != 0
                    else {
                        return identifier
                }
                return identifier + String(UnicodeScalar(UInt8(value)))
            }
            
            switch identifier {
            case "iPod1,1":  return "iPod Touch 1"
            case "iPod2,1":  return "iPod Touch 2"
            case "iPod3,1":  return "iPod Touch 3"
            case "iPod4,1":  return "iPod Touch 4"
            case "iPod5,1":  return "iPod Touch (5 Gen)"
            case "iPod7,1":  return "iPod Touch 6"
                
            case "iPhone3,1", "iPhone3,2", "iPhone3,3":  return "iPhone 4"
            case "iPhone4,1":  return "iPhone 4s"
            case "iPhone5,1":  return "iPhone 5"
            case "iPhone5,2":  return "iPhone 5 (GSM+CDMA)"
            case "iPhone5,3":  return "iPhone 5c (GSM)"
            case "iPhone5,4":  return "iPhone 5c (GSM+CDMA)"
            case "iPhone6,1":  return "iPhone 5s (GSM)"
            case "iPhone6,2":  return "iPhone 5s (GSM+CDMA)"
            case "iPhone7,2":  return "iPhone 6"
            case "iPhone7,1":  return "iPhone 6 Plus"
            case "iPhone8,1":  return "iPhone 6s"
            case "iPhone8,2":  return "iPhone 6s Plus"
            case "iPhone8,4":  return "iPhone SE"
            case "iPhone9,1":  return "国行、日版、港行iPhone 7"
            case "iPhone9,2":  return "港行、国行iPhone 7 Plus"
            case "iPhone9,3":  return "美版、台版iPhone 7"
            case "iPhone9,4":  return "美版、台版iPhone 7 Plus"
            case "iPhone10,1","iPhone10,4":   return "iPhone 8"
            case "iPhone10,2","iPhone10,5":   return "iPhone 8 Plus"
            case "iPhone10,3","iPhone10,6":   return "iPhone X"
            case "iPhone11,2":  return "iPhone XS"
            case "iPhone11,4","iPhone11,6":   return "iPhone XS Max"
            case "iPhone11,8":  return "iPhone XR"
            case "iPhone12,1":  return "iPhone 11"
            case "iPhone12,3":  return "iPhone 11 Pro"
            case "iPhone12,5":  return "iPhone 11 Pro Max"
            
                
            case "iPad1,1":   return "iPad"
            case "iPad1,2":   return "iPad 3G"
            case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":   return "iPad 2"
            case "iPad2,5", "iPad2,6", "iPad2,7":  return "iPad Mini"
            case "iPad3,1", "iPad3,2", "iPad3,3":  return "iPad 3"
            case "iPad3,4", "iPad3,5", "iPad3,6":  return "iPad 4"
            case "iPad4,1", "iPad4,2", "iPad4,3":  return "iPad Air"
            case "iPad4,4", "iPad4,5", "iPad4,6":  return "iPad Mini 2"
            case "iPad4,7", "iPad4,8", "iPad4,9":  return "iPad Mini 3"
            case "iPad5,1", "iPad5,2":  return "iPad Mini 4"
            case "iPad5,3", "iPad5,4":  return "iPad Air 2"
            case "iPad6,3", "iPad6,4":  return "iPad Pro 9.7"
            case "iPad6,7", "iPad6,8":  return "iPad Pro 12.9"
            case "iPad6,11", "iPad6,12":  return "iPad 5"
            case "iPad7,1", "iPad7,2":   return "iPad Pro 12.9"
            case "iPad7,3", "iPad7,4":  return "iPad Pro 10.5"
            case "iPad7,5", "iPad7,6":  return "iPad 6th generation"
            case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":  return "iPad Pro 11"
            case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":  return "iPad Pro 12.9"
            
                
            case "AppleTV2,1":  return "Apple TV 2"
            case "AppleTV3,1","AppleTV3,2":  return "Apple TV 3"
            case "AppleTV5,3":   return "Apple TV 4"
            case "i386", "x86_64":   return "Simulator"
            default:  return identifier
            }
        }
    }
    
    
    //MARK:网络运营商信息 更多信息请参考CTTelephonyNetworkInfo
//    if #available(iOS 12.0, *) {
//        print(UIDevice.current.telephonyNetworkInfo.serviceSubscriberCellularProviders)
//    } else {
//        // Fallback on earlier versions
//    }
    
    var telephonyNetworkInfo : CTTelephonyNetworkInfo {
        return CTTelephonyNetworkInfo()
    }
    @available(iOS 12.0, *)
    var serviceSubscriberCellularProviders: [String : CTCarrier]? {
        return telephonyNetworkInfo.serviceSubscriberCellularProviders
    }
    /// 蜂窝服务提供商的信息
    var carrier: CTCarrier? {
        return telephonyNetworkInfo.subscriberCellularProvider
    }
    /// 网络运营商名称
    var carrierName : String {
        return carrier?.carrierName ?? ""
    }
    /// 手机国家代码
    var mobileCountryCode: String {
        return carrier?.mobileCountryCode ?? ""
    }
    /// 手机网络代码
    var mobileNetworkCode: String {
        return carrier?.mobileNetworkCode ?? ""
    }
    var isoCountryCode: String {
        return carrier?.isoCountryCode ?? ""
    }
    
    //MARK:网络地址（Wi-Fi地址，移动蜂窝网络地址）
    func mobileNetworkAddress() -> String {
        self.ipAddress("pdp_ip0")
    }
    func wifiNetworkAddress() -> String {
        self.ipAddress("en0")
    }
    func ipAddress(_ type: String) -> String {
        
        var address : String?
        var ifaddr : UnsafeMutablePointer<ifaddrs>?
        if getifaddrs(&ifaddr) == 0 {
            var ptr = ifaddr
            while ptr != nil {
                defer {
                    ptr = ptr?.pointee.ifa_next
                }
                let interface = ptr?.pointee
                let addressFamily = interface?.ifa_addr.pointee.sa_family
                if
                    (addressFamily == UInt8(AF_INET) || addressFamily == UInt8(AF_INET6)),
                    let ifa_name = interface?.ifa_name,
                    String(cString: ifa_name) == type,
                    let sa_len = interface?.ifa_addr.pointee.sa_len {
                    
                    var hostName = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    let ifa_addr = interface?.ifa_addr
                    
                    getnameinfo(ifa_addr, socklen_t(sa_len), &hostName, socklen_t(hostName.count), nil, socklen_t(0), NI_NUMERICHOST)
                    
                    address = String(cString: hostName)
                }
            }
            freeifaddrs(ifaddr)
        }
        
        return address ?? ""
    }
    
    
    ///MARK:网络地址（Wi-Fi地址，Mac地址）
    //FIXME: 待测,iOS12之后，需要获取权限
    func ____wifinameNetworkAddress() -> String {
        self.____ipAddress_oo("SSID").lowercased()
    }
    func ____macAddress() -> String {
        self.____ipAddress_oo("BSSID")
    }
    func ____ipAddress_oo(_ type: String) -> String{
        var address = ""
        
        if let interfaces = CNCopySupportedInterfaces(), let arr = interfaces as? Array<Any> {
            arr.forEach { (str) in
                if
                    let dict = CFBridgingRetain(CNCopyCurrentNetworkInfo(str as! CFString)),
                    dict.count != 0,
                    let dic = dict as? Dictionary<String, Any> {
                    address = dic["type"] as! String
                }
            }
        }
        return address
    }
    
    //MARK:进程信息（e.g. 某个app的信息）
    /// 进程信息，包含进程名，指示符，主机名，所运行操作系统，系统版本，所占的物理内存，处理器数量，活跃处理器数量等等
    var processInfo: ProcessInfo {
        return ProcessInfo.processInfo
    }
    /// 进程所占内存
    var processTotalMemory: UInt64 {
        return processInfo.physicalMemory
    }
    var processName: String {
        return processInfo.processName
    }
    //MARK:磁盘信息
    /// 内存总容量，不包含系统占用容量
    /// 可以使用系统方法来转换字节为TB，GB，MB： ByteCountFormatter.string(fromByteCount: <#T##Int64#>, countStyle: <#T##ByteCountFormatter.CountStyle#>)
    var totalMemory: UInt64 {
        let ptr = UnsafeMutablePointer<statfs>.allocate(capacity: MemoryLayout<statfs>.size)
        var stat = ptr.pointee
        if statfs("/var",&stat) >= 0 {
            return UInt64(stat.f_bsize) * stat.f_blocks
        }
        return 0
    }
    var freeMemory: UInt64 {
        let ptr = UnsafeMutablePointer<statfs>.allocate(capacity: MemoryLayout<statfs>.size)
        var stat = ptr.pointee
        if statfs("/var",&stat) >= 0 {
            return UInt64(stat.f_bsize) * stat.f_bavail
        }
        return 0
    }
    //两种方式
    var totalMemory1: UInt64 {
        guard let dict = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory()) else { return 0 }
        let size = dict[FileAttributeKey.systemSize] as? UInt64
        return size ?? 0
    }
    var freeMemory1: UInt64 {
        guard let dict = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory()) else { return 0 }
        let size = dict[FileAttributeKey.systemFreeSize] as? UInt64
        return size ?? 0
    }
    
    private var freeMemory11: UInt64 {
        let host_port = mach_host_self()
        var host_size = mach_msg_type_number_t(MemoryLayout<vm_statistics_data_t>.stride / MemoryLayout<integer_t>.stride)
        var page_size : vm_size_t = 0
        var kern_return = KERN_FAILURE
        kern_return = host_page_size(host_port, &page_size)
        if kern_return == KERN_SUCCESS {
            
        }
        var vm_stat : vm_statistics = vm_statistics_data_t()
        let status : kern_return_t = withUnsafeMutableBytes(of: &vm_stat) { [count = vm_stat] in
            let p = $0.baseAddress?.bindMemory(to: Int32.self, capacity: MemoryLayout.size(ofValue: count) / MemoryLayout<Int32>.stride)
            return host_statistics(host_port, HOST_VM_INFO, p, &host_size)
        }
        if status == KERN_SUCCESS {
            let free = vm_size_t(vm_stat.free_count) * page_size
            //活跃的+不活跃的+wire
            let used = (Int64)(vm_size_t(vm_stat.active_count + vm_stat.inactive_count + vm_stat.wire_count) * page_size)

            return self.totalMemory - UInt64(used)
        } else {
            return 0
        }
    }
    //MARK:cpu信息
}
