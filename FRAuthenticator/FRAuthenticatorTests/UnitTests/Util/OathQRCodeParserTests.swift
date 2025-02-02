// 
//  OathQRCodeParserTests.swift
//  FRAuthenticatorTests
//
//  Copyright (c) 2020-2021 ForgeRock. All rights reserved.
//
//  This software may be modified and distributed under the terms
//  of the MIT license. See the LICENSE file for details.
//

import XCTest
@testable import FRAuthenticator

class OathQRCodeParserTests: FRABaseTests {
    
    func test_01_parse_hotp_qr_code_success() {
        let qrCode = URL(string: "otpauth://hotp/Forgerock:demo?secret=IJQWIZ3FOIQUEYLE&issuer=Forgerock&counter=2&algorithm=SHA256")!
        
        do {
            let parser = try OathQRCodeParser(url: qrCode)
            
            XCTAssertNotNil(parser.scheme)
            XCTAssertNotNil(parser.type)
            XCTAssertNotNil(parser.issuer)
            XCTAssertNotNil(parser.label)
            XCTAssertNotNil(parser.secret)
            XCTAssertNotNil(parser.counter)
            XCTAssertNotNil(parser.algorithm)
            
            XCTAssertEqual(parser.scheme, "otpauth")
            XCTAssertEqual(parser.type, "hotp")
            XCTAssertEqual(parser.issuer, "Forgerock")
            XCTAssertEqual(parser.label, "demo")
            XCTAssertEqual(parser.secret, "IJQWIZ3FOIQUEYLE")
            XCTAssertEqual(parser.counter, 2)
            XCTAssertEqual(parser.algorithm, "sha256")
        }
        catch {
            XCTFail("Failed with unexpected error: \(error.localizedDescription)")
        }
    }
    
    
    func test_02_parse_topt_qr_code_success() {
        
        let qrCode = URL(string: "otpauth://totp/ForgeRock:demo?secret=T7SIIEPTZJQQDSCB&issuer=ForgeRock&digits=6&period=30")!
        
        do {
            let parser = try OathQRCodeParser(url: qrCode)
            
            XCTAssertNotNil(parser.scheme)
            XCTAssertNotNil(parser.type)
            XCTAssertNotNil(parser.issuer)
            XCTAssertNotNil(parser.label)
            XCTAssertNotNil(parser.secret)
            XCTAssertNotNil(parser.digits)
            XCTAssertNotNil(parser.period)
            
            XCTAssertEqual(parser.scheme, "otpauth")
            XCTAssertEqual(parser.type, "totp")
            XCTAssertEqual(parser.issuer, "ForgeRock")
            XCTAssertEqual(parser.label, "demo")
            XCTAssertEqual(parser.secret, "T7SIIEPTZJQQDSCB")
            XCTAssertEqual(parser.digits!, 6)
            XCTAssertEqual(parser.period!, 30)
        }
        catch {
            XCTFail("Failed with unexpected error: \(error.localizedDescription)")
        }
    }
    
    
    func test_03_invalid_scheme() {
        let qrCode = URL(string: "invalidscheme://totp/ForgeRock:demo?secret=T7SIIEPTZJQQDSCB&issuer=ForgeRock&digits=6&period=30")!
        
        do {
            let _ = try OathQRCodeParser(url: qrCode)
            XCTFail("Parsing success while expecting failure for invalid scheme")
        }
        catch MechanismError.invalidQRCode {
            
        }
        catch {
            XCTFail("Failed to parse with unexpected error: \(error.localizedDescription)")
        }
    }
    
    
    func test_03_invalid_type() {
        let qrCode = URL(string: "otpauth://invalidtype/ForgeRock:demo?secret=T7SIIEPTZJQQDSCB&issuer=ForgeRock&digits=6&period=30")!
        
        do {
            let _ = try OathQRCodeParser(url: qrCode)
            XCTFail("Parsing success while expecting failure for invalid scheme")
        }
        catch MechanismError.invalidType {
            
        }
        catch {
            XCTFail("Failed to parse with unexpected error: \(error.localizedDescription)")
        }
    }
    
    
    func test_04_parse_topt_qr_code_without_username_success() {
        
        let qrCode = URL(string: "otpauth://totp/ForgeRock?secret=T7SIIEPTZJQQDSCB&issuer=ForgeRock&digits=6&period=30")!
        
        do {
            let parser = try OathQRCodeParser(url: qrCode)
            
            XCTAssertNotNil(parser.scheme)
            XCTAssertNotNil(parser.type)
            XCTAssertNotNil(parser.issuer)
            XCTAssertNotNil(parser.label)
            XCTAssertNotNil(parser.secret)
            XCTAssertNotNil(parser.digits)
            XCTAssertNotNil(parser.period)
            
            XCTAssertEqual(parser.scheme, "otpauth")
            XCTAssertEqual(parser.type, "totp")
            XCTAssertEqual(parser.issuer, "ForgeRock")
            XCTAssertEqual(parser.label, "ForgeRock")
            XCTAssertEqual(parser.secret, "T7SIIEPTZJQQDSCB")
            XCTAssertEqual(parser.digits!, 6)
            XCTAssertEqual(parser.period!, 30)
        }
        catch {
            XCTFail("Failed with unexpected error: \(error.localizedDescription)")
        }
    }
    
    
    func test_05_parse_topt_qr_code_without_period_username_success() {
        
        let qrCode = URL(string: "otpauth://totp/ForgeRock?secret=T7SIIEPTZJQQDSCB&issuer=ForgeRock&digits=6")!
        
        do {
            let parser = try OathQRCodeParser(url: qrCode)
            XCTAssertNotNil(parser.label)
            XCTAssertEqual(parser.label, "ForgeRock")
        }
        catch {
            XCTFail("Failed with unexpected error: \(error.localizedDescription)")
        }
    }
    
    
    func test_06_parse_algorithm_default_sha1() {
        let qrCode = URL(string: "otpauth://hotp/Forgerock:demo?secret=IJQWIZ3FOIQUEYLE&issuer=Forgerock")!
        
        do {
            let parser = try OathQRCodeParser(url: qrCode)
            XCTAssertNotNil(parser.algorithm)
            XCTAssertNotNil(parser.oathAlgorithm)
            XCTAssertEqual(parser.algorithm, "sha1")
            XCTAssertEqual(parser.oathAlgorithm, .sha1)
        }
        catch {
            XCTFail("Failed with unexpected error: \(error.localizedDescription)")
        }
    }
    
    
    func test_07_parse_algorithm_sha1() {
        let qrCode = URL(string: "otpauth://hotp/Forgerock:demo?secret=IJQWIZ3FOIQUEYLE&issuer=Forgerock&algorithm=sha1")!
        
        do {
            let parser = try OathQRCodeParser(url: qrCode)
            XCTAssertNotNil(parser.algorithm)
            XCTAssertNotNil(parser.oathAlgorithm)
            XCTAssertEqual(parser.algorithm, "sha1")
            XCTAssertEqual(parser.oathAlgorithm, .sha1)
        }
        catch {
            XCTFail("Failed with unexpected error: \(error.localizedDescription)")
        }
    }
    
    
    func test_08_parse_algorithm_sha224() {
        let qrCode = URL(string: "otpauth://hotp/Forgerock:demo?secret=IJQWIZ3FOIQUEYLE&issuer=Forgerock&algorithm=sha224")!
        
        do {
            let parser = try OathQRCodeParser(url: qrCode)
            XCTAssertNotNil(parser.algorithm)
            XCTAssertNotNil(parser.oathAlgorithm)
            XCTAssertEqual(parser.algorithm, "sha224")
            XCTAssertEqual(parser.oathAlgorithm, .sha224)
        }
        catch {
            XCTFail("Failed with unexpected error: \(error.localizedDescription)")
        }
    }
    
    
    func test_09_parse_algorithm_sha256() {
        let qrCode = URL(string: "otpauth://hotp/Forgerock:demo?secret=IJQWIZ3FOIQUEYLE&issuer=Forgerock&algorithm=sha256")!
        
        do {
            let parser = try OathQRCodeParser(url: qrCode)
            XCTAssertNotNil(parser.algorithm)
            XCTAssertNotNil(parser.oathAlgorithm)
            XCTAssertEqual(parser.algorithm, "sha256")
            XCTAssertEqual(parser.oathAlgorithm, .sha256)
        }
        catch {
            XCTFail("Failed with unexpected error: \(error.localizedDescription)")
        }
    }
    
    
    func test_10_parse_algorithm_sha384() {
        let qrCode = URL(string: "otpauth://hotp/Forgerock:demo?secret=IJQWIZ3FOIQUEYLE&issuer=Forgerock&algorithm=sha384")!
        
        do {
            let parser = try OathQRCodeParser(url: qrCode)
            XCTAssertNotNil(parser.algorithm)
            XCTAssertNotNil(parser.oathAlgorithm)
            XCTAssertEqual(parser.algorithm, "sha384")
            XCTAssertEqual(parser.oathAlgorithm, .sha384)
        }
        catch {
            XCTFail("Failed with unexpected error: \(error.localizedDescription)")
        }
    }
    

    func test_11_parse_algorithm_sha384() {
        let qrCode = URL(string: "otpauth://hotp/Forgerock:demo?secret=IJQWIZ3FOIQUEYLE&issuer=Forgerock&algorithm=sha512")!
        
        do {
            let parser = try OathQRCodeParser(url: qrCode)
            XCTAssertNotNil(parser.algorithm)
            XCTAssertNotNil(parser.oathAlgorithm)
            XCTAssertEqual(parser.algorithm, "sha512")
            XCTAssertEqual(parser.oathAlgorithm, .sha512)
        }
        catch {
            XCTFail("Failed with unexpected error: \(error.localizedDescription)")
        }
    }
    
    
    func test_12_parse_qrcode_with_image_base64_encoded() {
        let qrCode = URL(string: "otpauth://hotp/Forgerock:demo?secret=IJQWIZ3FOIQUEYLE&issuer=Forgerock&image=aHR0cHM6Ly91cGxvYWQud2lraW1lZGlhLm9yZy93aWtpcGVkaWEvY29tbW9ucy9lL2U1L0Zvcmdlcm9ja19Mb2dvXzE5MHB4LnBuZw==")!
        
        do {
            let parser = try OathQRCodeParser(url: qrCode)
            XCTAssertEqual(parser.image, "https://upload.wikimedia.org/wikipedia/commons/e/e5/Forgerock_Logo_190px.png")
        }
        catch {
            XCTFail("Failed with unexpected error: \(error.localizedDescription)")
        }
    }
    
    
    func test_13_parse_qrcode_with_image_plain_text() {
        let qrCode = URL(string: "otpauth://hotp/Forgerock:demo?secret=IJQWIZ3FOIQUEYLE&issuer=Forgerock&image=https://upload.wikimedia.org/wikipedia/commons/e/e5/Forgerock_Logo_190px.png")!
        
        do {
            let parser = try OathQRCodeParser(url: qrCode)
            XCTAssertEqual(parser.image, "https://upload.wikimedia.org/wikipedia/commons/e/e5/Forgerock_Logo_190px.png")
        }
        catch {
            XCTFail("Failed with unexpected error: \(error.localizedDescription)")
        }
    }
    
    
    func test_14_parse_qrcode_with_image_url_encoded() {
        let qrCode = URL(string: "otpauth://hotp/Forgerock:demo?secret=IJQWIZ3FOIQUEYLE&issuer=Forgerock&image=https%3A%2F%2Fupload.wikimedia.org%2Fwikipedia%2Fcommons%2Fe%2Fe5%2FForgerock_Logo_190px.png")!
        
        do {
            let parser = try OathQRCodeParser(url: qrCode)
            XCTAssertEqual(parser.image, "https://upload.wikimedia.org/wikipedia/commons/e/e5/Forgerock_Logo_190px.png")
        }
        catch {
            XCTFail("Failed with unexpected error: \(error.localizedDescription)")
        }
    }
    
    func test_15_qrcode_no_identity() {
        let qrCode = URL(string: "otpauth://totp/?period=30&b=032b75&digits=6&secret=X6KUBOXCEZXMBR6IWB5MES5BPQ======")!
        
        do {
            let _ = try OathQRCodeParser(url: qrCode)
            XCTFail("Parsing success while expecting failure for invalid identity")
        }
        catch MechanismError.missingInformation {
            
        }
        catch {
            XCTFail("Failed with unexpected error: \(error.localizedDescription)")
        }
    }
    
    func test_16_totp_no_identity_with_issuer() {
        let qrCode = URL(string: "otpauth://totp/?period=30&b=032b75&digits=6&secret=X6KUBOXCEZXMBR6IWB5MES5BPQ======&issuer=ForgeRock")!
        
        do {
            let parser = try OathQRCodeParser(url: qrCode)
            XCTAssertEqual(parser.issuer, "ForgeRock")
            XCTAssertEqual(parser.label, "Untitled")
        }
        catch {
            XCTFail("Failed with unexpected error: \(error.localizedDescription)")
        }
    }
    
    func test_17_totp_single_identity() {
        let qrCode = URL(string: "otpauth://totp/ForgeRock?period=30&b=032b75&digits=6&secret=X6KUBOXCEZXMBR6IWB5MES5BPQ======")!
        
        do {
            let parser = try OathQRCodeParser(url: qrCode)
            XCTAssertEqual(parser.issuer, "ForgeRock")
            XCTAssertEqual(parser.label, "ForgeRock")
        }
        catch {
            XCTFail("Failed with unexpected error: \(error.localizedDescription)")
        }
    }
}
