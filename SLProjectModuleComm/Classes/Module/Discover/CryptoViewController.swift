//
//  CryptoViewController.swift
//  SLProjectModuleComm
//
//  Created by 孙梁 on 2021/7/13.
//

import UIKit
import SLIKit
import CryptoSwift

class CryptoViewController: BaseViewController {
    
    private lazy var tableView = UITableView(frame: CGRect.zero, style: .insetGrouped).sl
        .showsVerticalScrollIndicator(false)
        .showsHorizontalScrollIndicator(false)
        .delegate(self)
        .dataSource(self)
        .rowHeight(UITableView.automaticDimension)
        .estimatedRowHeight(80)
        .sectionHeaderHeight(UITableView.automaticDimension)
        .sectionFooterHeight(0)
        .base
    
    private let originStr = "这是明文1234567890"
    private lazy var dataArray: [(String, [(String?, String?)])] = [("明文", [(originStr, nil)])]
}

// MARK: - LifeCyle
extension CryptoViewController {
    override func setMasterView() {
        super.setMasterView()
        title = "加解密"
        view.addSubview(tableView)
        MD5()
        SHA()
        CRC()
        MAC_HMAC()
        MAC_Poly1305()
        PBKDF2()
        AES()
        tableView.reloadData()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tableView.snp.sl.makeConstraints { make in
            make.size.equalToSuperview()
            make.center.equalToSuperview()
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension CryptoViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        dataArray.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataArray[section].1.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell")
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "UITableViewCell")
            cell?.textLabel?.numberOfLines = 0
            cell?.detailTextLabel?.numberOfLines = 0
        }
        cell?.textLabel?.text = dataArray[indexPath.section].1[indexPath.row].0
        cell?.detailTextLabel?.text = dataArray[indexPath.section].1[indexPath.row].1
        return cell~~
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        dataArray[section].0
    }
}

// MARK: - Privater Methods
extension CryptoViewController {
    override func bind() {
        super.bind()
    }
    
    private func MD5() {
        let md5 = originStr.md5()
        dataArray.append(("MD5", [(md5, nil)]))
    }
    
    private func SHA() {
        let sha1 = originStr.sha1()
        let sha224 = originStr.sha224()
        let sha256 = originStr.sha256()
        let sha384 = originStr.sha384()
        let sha512 = originStr.sha512()
        dataArray.append(("SHA", [("sha1", sha1),
                                  ("sha224", sha224),
                                  ("sha256", sha256),
                                  ("sha384", sha384),
                                  ("sha512", sha512)])
        )
    }
    
    private func CRC() {
        let crc16 = originStr.crc16()
        let crc32 = originStr.crc32()
        dataArray.append(("CRC", [("crc16", crc16), ("crc32", crc32)]))
    }
    
    private func MAC_HMAC() {
        let key = "abcde"
        let md5 = try? HMAC(key: key.bytes, variant: .md5).authenticate(originStr.bytes).toHexString()
        let sha1 = try? HMAC(key: key.bytes, variant: .sha1).authenticate(originStr.bytes).toHexString()
        let sha256 = try? HMAC(key: key.bytes, variant: .sha256).authenticate(originStr.bytes).toHexString()
        let sha384 = try? HMAC(key: key.bytes, variant: .sha384).authenticate(originStr.bytes).toHexString()
        let sha512 = try? HMAC(key: key.bytes, variant: .sha512).authenticate(originStr.bytes).toHexString()
        dataArray.append(("MAC-HMAC\nkey: \(key)", [
            ("md5", md5),
            ("sha1", sha1),
            ("sha256", sha256),
            ("sha384", sha384),
            ("sha512", sha512)
        ]))
    }
    
    private func MAC_Poly1305() {
        let key = "ab012345678901234567890123456789"
        let str = try? Poly1305(key: key.bytes).authenticate(originStr.bytes).toHexString()
        dataArray.append(("MAC-Poly1305\nkey: \(key)", [
            (str, nil)
        ]))
    }
    
    private func PBKDF2() {
        /**
         password：用来生成密钥的原始密码
         salt：加密用的盐值
         iterations：重复计算的次数。默认值：4096
         keyLength：期望得到的密钥的长度。默认值：不指定
         variant：加密使用的伪随机函数。默认值：sha256
         */
        
        // 盐值不要太短。为了使攻击者无法构造包含所有可能盐值的查询表，盐值越长越好（至少为 8 字节）
        let salt = "abc12345"
        let md5 = try? PKCS5.PBKDF2(password: originStr.bytes, salt: salt.bytes, iterations: 4096,
                                    variant: .md5).calculate().toHexString()
        let sha256 = try? PKCS5.PBKDF2(password: originStr.bytes, salt: salt.bytes).calculate().toHexString()
        dataArray.append(("PBKDF2\n盐: \(salt)", [
            ("md5", md5),
            ("sha256", sha256)
        ]))
    }
    
    private func AES() {
        do {
            let key = "abcdef1234567890"
            // 使用AES-128-ECB加密模式
            let aes = try CryptoSwift.AES(key: key.bytes, blockMode: ECB())
            // 开始加密
            let encrypted = try aes.encrypt(originStr.bytes)
            // 将加密结果转成base64形式
            let encryptedBase64 = encrypted.toBase64()
            // 开始解密1（从加密后的字符数组解密）
            let decrypted1 = try aes.decrypt(encrypted)
            // 开始解密2（从加密后的base64字符串解密）
            let decrypted2 = try encryptedBase64?.decryptBase64ToString(cipher: aes)
            
            dataArray.append(("AES\nkey: \(key)", [
                ("加密结果", String(data: Data(encrypted), encoding: .utf8)),
                ("加密结果(base64形式)", encryptedBase64),
                ("解密1(从加密后的字符数组解密)", String(data: Data(decrypted1), encoding: .utf8)),
                ("解密2(从加密后的base64字符串解密)", decrypted2)
            ]))
            
        } catch {
            
        }
    }
}
