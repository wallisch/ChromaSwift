// Copyright (c) 2021 Philipp Wallisch
// Distributed under the MIT license, see the LICENSE file for details.

import DVR
import XCTest
@testable import ChromaSwift

class ChromaSwiftTests: XCTestCase {
    let backbeatURL = Bundle.module.url(forResource: "Backbeat", withExtension: "mp3", subdirectory: "Resources")!
    let backbeatFingerprint = "AQABYJGikFSmJBCPijt6Hqkj_PjgH1l-XDyOnoeW48EFBqJ-4_BxHOeRT4Z_7IFPVLWRQ3sYwzJqW3iOixZeDdoTIeVRK7jE4znCPDrOHNcI8TnKI7wUNDryfvgfnDN6QjzRLsej48e5HbeCB9UHfzHEQ3TjYPrwu_gYdOXxnPg_nA_xED2PHlPy48eDZkW_47jEQufRE4auw8cXFtaP8MmOnMdvaA9jWEe95fiOS7LQMSHED2FzXDlOHn0ipDueHbIG_yhnhLlylMedCzkvXEcfQrxR9sh14YmOa8QTkegOb02RHx8q83h3nAoPvehF-NAx5cdzhF-OhsuR4w2h3WiO4-iPHSKHfsiz48ijC5VhadLRu9BeeD28o4-LB5cUCic0G4185BH2HN-OPkeOasM3vMoOzdBy4tWLOzxq4RXuC1utoi8eQRNF-OiOkjT8wzv6uHhwSaFwQotm1DvyYc_x7Qifo_h2fEOv7HB49PiNjzxqUcf3Yjdcn-gn4wruo2p-PGVhh_hxKmh_3Dr0qUQPn9ADH9ODP0hJ5TgCtWHQHP1xHNOhBw075DizI-eOO0en6bBr6Pi0A-XxeMIlHadQjxB11MqRY08edEOeoxqu41pQPYd7dM1x92ij9LiOv9jlwdXRS8YloTqe_LCyMAWeo6J4_MepZIde9CJ86Nh-9DnC72i47MhxaGqK5sdx9NgDkUM_5DlO5NGFyrA06ehdaIc3Hd7Rx8WDSwoFaB7RyDPyCHuOb0d_5Ki24xsuHhWJ5sR74w7RRr7w6Ti2q8HVo56OU0fVHOdhZaHx4xza8fh36Ip09IdP6PAxPcePMI9ytDtyvCG0G81xPOixByI7hPgOACQFEJQBBpgwiABlxAEAW8qIQgIBFahAAggiFAOEGAEIAVQQIIghgCjCIBDCAGEIMEgYAQxRggkgACCCCkGaQMQYYgQRQglBAASOIAAQIgRIBgQRwglCCBACGYIYAYwohIQRADggEEAMCYIAYIacY5BRgikhAECOiOMIIUggoVACQggBhDJAOGsEckQcRwhBAgkFIAICEAGBAUpIIBARQgiGABAAESCQFUwJYREx5SBFhDDAGEmEc4ZQQggxSiGoAAIEIAKJQg4RIhUQzAgjBAAOCASQQMIIQI0gZyOjEFNCAIUcEYcQJBBRCiIlhDAAKAQSMoII4RBDQAAhCABEKCAMU4AoAJgh5RgnAA"
    let backbeatHash = "10000100010100011111010101000011"

    let fireworksURL = Bundle.module.url(forResource: "Fireworks", withExtension: "mp3", subdirectory: "Resources")!
    let fireworksFingerprint = "AQADtEmWMkmWaDjRo5l1XEOP5lmEH0cfNHQ-HF2o4SP6EH_QE80Z_MElBZ-Y4ghF1bBr1MLx489Rygfl4B-aL-Ak4-qFZ-qQZ6h-aNGPKzpOQ_yCI-9RfcEv3EEOLXWKHJU_NFIUnijRnKdwaike5OD0QG-OPPiO03jYFA9qBX6OB0doxSHB7gquBFou9Mrxo32g5Tj6oMGHhj36HChv-MLRJ0T5wP_wd_igHfnxD0dvGP2Cojn-4Wh29NmQTyv6HFr-4Ebzoz96NPtxssb5oEfzCneJsmj54TfOD76Oa8dP9K3QrPhQenhwS0BffCOOox_eo39wHg1X9Dz6DR7Doj-KPsO1o9mPK4lA5qB-9DneEI1CGmGFE6cynCnOHLh97D5q8fjQB9-NNx_uKBUu9AnhuAg_fMF-_Amq72jUQnWOvvBxG02lIc8eoMkRjsETGtrh53jUc9h0fAsuojR04sefo3EyaD7QHJH4KMfz4A8uSTp6hFmDPyia48cfHM0P7UmFE-EtPPCP_Dl0hC_O4jnKX0gJnchvoXxwB0d_9PjRC-mOO4Uo7kiLO0TzJ9iPZkf94snh5wj0UDjiJqRxUuiaFs_hUTr-D_lxaNc85OOD-jU85vjx4wmaUXioIHeK3YI-9MclH8cJvyh5HGcOLTdKTei-oHFT5MXzIUvq4wd_QvzQfBvy5WiDMDeu-9CPyDuaN8Rh9HiFI79R0R18q9Br-LhG_IcYnIcPfMTxAaJa4zh-Cz9-yPQRGhd-VKpUwt2OPTuuww8m5CT0MQquBDkdjHgkHTlRPiJEpGfRG8dj4T3KHOmh7ceDBzeeGhqP5gSO7g3EI4d_4cUPyzqOm0eLEycuWsiP73gOHYxkk_Av5CyeHeWOzyuKBvwRv9AvI4wc1MV_9HrgiJmHXIvh6tCNzXvgHPkRPgr6w1VxnsTxINU14eLxwgc8LUc1HY-0mEXEF-ITZQy-6EeuhEV-NGPRj1DF40o-XD90NGoWlEp4PMfBPMuhZSSeHEefo3mMR8R3HI3CHu2ODz-k5AzKH88BRoeWbjF-pE8PTtPB6_hRjiHxZxQeHwd7I__RTLcQj8d39IHHK8UXDt6G3MahnXhy4jv-ZXikB8c_OA4_yFCp49fQH1eO9Dz648tRmwiTL8dX9Dm0KEoiPPrwXOgJLVUWfBeeL8IZBZImMdB14sIDKpSGN4fOgz8-HTYuG_SOTlGIxsnxKTougXmPhtnx5ZB39OHQ_IeuDD-aHl2O5_hxWhCVB78hq8e7oXyPhpyR63hr1A6aacd3vBOJV0d7I5NyAecunK3QKjJ-NFcGrTPyBPUx5ce-sMR__PiJPC3x5NB19EfTDU_CGC9YDs26o82Lpx9-WB2eF-dDHEfDMSjl44H8F95S49nxUId2OCJjZClx6eiPJi7u40pwHm9Kof0IT0cObw-sXsO38PhleFcj6MoJj0GN_oBGxsGPlw2uXHh2HI1K1FvwJNCj4UgVqeCTPA14vLDa4ZHwSB_yg3p1PJqDR1_xg6oS6E1xpbnwG4yVKEdD1cZ1QmKPplugvcd14NIjNKJQSheuF7oFZ4k7XNoeXGD2B1rGJSOeHVfCoz-s48oo9MH5o2iW4-oBLQ5TgVk2bfjBHqq0Cw1_lBcuYMqzFKUkHdWIZsvxmfjDBNehhXqJSqRn6FOCH-EuCs2IsxMeHWsuNKOFnviF_MeL5-gO5kHXwj8OP8d7wedx-CEO__hl-MRhUiQOkwQOHzfh487hQ_iCyjl0aORghdGhw8fhB2_h8_jhB5_g08Al6OgJ9mh-MGTQaYd4Iq8EX_CITtLBGQwai0eCsFHhOQfDDn88dCJc3chvmNBfNH-gbUeTvcIb9BZ6vBX-QQsYGSUlWD4o7oJ-4uBRq9CXGE3Rh-UQvmjUrIip48mHPsuDpgpxUT_alcebbWCO58QzfOnhKoYcPmiyvEJZ9Bs-9PheMGh69BEc8XB1DeF8tEQ6QsyP0EPj76hcXIHP4vEs3E-QXAvC-Kh1nJKPx8dBIhcPPQl-_IeWuEc95biCo7ly1CJOPHjjoDqaH8cbdCN0vPug2ceXxjj1ERVEcqnQv7gIHqmLW8mBjzhzhBf2NwnKs4LK4xdR_UGTRTn05Ud9BemYbMR3lDqe5GiO6cYTksiPO8eT46SJfkkH66ikxdB3gd2P8LJhh0GvBz_eXWi0Dz3yU9CFlEmQBy_xR6h4NFaO5xFqB96KisqhH8wN10HH4MlRaDEu0cKjB93ho04kDlfQ_mAyCceh6RF8omqKD2gObYmIHs186Dc-pSm-TOgP_0Z7g2cD3UdzhE_wFtPE49bRc0pC_MSPHz_ROA_aBaEsfIXo5EjLW-jx5dh7nMcT5sihTgdHHSaARYAZsRBFABILCBCCaCKMMAxZYQTQBgGBBBMkMACFVR4CAISSQjBGIGNKIWYRAEQQ6gxVHilACEWQCAOsGc4iqzyARmpBhAGIAISAJsIQZIEjhBAAhGAECsMEcwwOYhRwTABihUAKISMFA0gQwAhEgCBHFQKAIDKEE8oRQJBASAGjLFAGEIAMFMwAgYQwSDEgmAHWQCIoIYgagoAQADJKgVCcOEFhMwI6DZADQAENAZIAIMQgAQAQIh0gADCMkEWMKAIUEMwpwwxRUBgHCBCICIEoEIAACowCDDCChENACKSUScwZ4QjSQEAKhKAKCYGQAYwQJh1RgAJCpSBCiIapgBYySYkiECElAJEeCGGIQgAYAwAggigjCGYIGGIIIAdICyAUFCAgBGEECEQYEMkwIohRSCBkCEMCmSKBAA4aIpCARBlCiBFcAAoAIgQbY5wCxAAADFFICauIAoYKoAAxwFGFjBFQEGUcEYIwgIgwSDCCmBBcIEKQEoIIopSSRhHIBFKEECAYYEYCJJQChkBDkQYEEEWAYQoYRZxgBgyAgCMGCIVMUMIYJKAiBlCiDAdIKKgEAMQBIYQBUiCECDicAIMNMk4KAJAxjBkBmAGESACQQcYIBwEAhRhCgBEGAUQAJMI4QYRwFBglgCEGEYaAM0gRxogCzAkjhLLAMCOMCkw4YYSxTgkAjDYSGSQsEEIYB5hwgkAlkBDAEAOAQYIAoYgggCAGEUJKFSCEYgIAIIQQkiFDBAMASQYIUQghIwBSgBBiCRFOAGEEFIIYgQwixChlBKEKDKCEAQoQTBQQTgIgIBFEAKAAM5YhIggQDBCEgCDCKGAIYAZAQCgATBigkGEGAcUYYUYiJIBYTDgiDBAKGCgQMEQJBRgQwCBgGIMCGSOEAU4QAaBhAA"
    let fireworksHash = "00100100010001011111000101100111"

    func testInvalidFile() {
        XCTAssertThrowsError(try AudioFingerprint(from: URL(fileURLWithPath: "Invalid.mp3"))) { error in
            XCTAssertEqual(error as? AudioDecoder.Error, AudioDecoder.Error.invalidFile)
        }

        let licenseURL = Bundle.module.url(forResource: "LICENSE", withExtension: nil, subdirectory: "Resources")!
        XCTAssertThrowsError(try AudioFingerprint(from: licenseURL)) { error in
            XCTAssertEqual(error as? AudioDecoder.Error, AudioDecoder.Error.invalidFile)
        }
    }

    func testInvalidFingerprint() {
        XCTAssertThrowsError(try AudioFingerprint(from: "Invalid", duration: 2.0)) { error in
            XCTAssertEqual(error as? AudioFingerprint.Error, AudioFingerprint.Error.invalidFingerprint)
        }
    }

    func testURLFingerprint() throws {
        let result = try AudioFingerprint(from: backbeatURL)

        XCTAssertEqual(result.algorithm, AudioFingerprint.Algorithm.test2)
        XCTAssertEqual(Int(result.duration), 46)
        XCTAssertEqual(result.fingerprint, backbeatFingerprint)
        XCTAssertEqual(result.hash, backbeatHash)
    }

    func testStringFingerprint() throws {
        let result = try AudioFingerprint(from: backbeatFingerprint, duration: 46.0)

        XCTAssertEqual(result.algorithm, AudioFingerprint.Algorithm.test2)
        XCTAssertEqual(Int(result.duration), 46)
        XCTAssertEqual(result.fingerprint, backbeatFingerprint)
        XCTAssertEqual(result.hash, backbeatHash)
    }

    func testAlgorithmSelection() throws {
        let result = try AudioFingerprint(from: backbeatURL, algorithm: .test4)
        XCTAssertEqual(result.algorithm, AudioFingerprint.Algorithm.test4)

        let constructedResult = try AudioFingerprint(from: result.fingerprint!, duration: result.duration)
        XCTAssertEqual(constructedResult.algorithm, AudioFingerprint.Algorithm.test4)
    }

    func testFingerprintMaxDuration() throws {
        let result = try AudioFingerprint(from: fireworksURL)
        XCTAssertEqual(result.algorithm, AudioFingerprint.Algorithm.test2)
        XCTAssertEqual(Int(result.duration), 120)
        XCTAssertEqual(result.fingerprint, fireworksFingerprint)
        XCTAssertEqual(result.hash, fireworksHash)

        let longResult = try AudioFingerprint(from: fireworksURL, maxDuration: nil)
        XCTAssertEqual(Int(longResult.duration), 191)

        let shortResult = try AudioFingerprint(from: fireworksURL, maxDuration: 10)
        XCTAssertEqual(Int(shortResult.duration), 10)
    }

    func testSimilarity() throws {
        let result = try AudioFingerprint(from: backbeatURL)

        let otherResult = try AudioFingerprint(from: fireworksURL)

        XCTAssertEqual(result.similarity(to: otherResult), 0.78125)
    }

    func testHashSimilarity() throws {
        let result = try AudioFingerprint(from: backbeatURL)

        XCTAssertEqual(result.similarity(to: backbeatHash), 1.0)
    }

    func testInvalidHashSimilarity() throws {
        let result = try AudioFingerprint(from: backbeatURL)

        XCTAssertNil(result.similarity(to: "Invalid"))
    }

    func testAcoustIDInvalidAPIKey() throws {
        let fingerprint = try AudioFingerprint(from: backbeatURL)

        let session = Session(cassetteName: "Fixtures/invalidAPIKey", testBundle: Bundle.module)
        let acoustID = AcoustID(apiKey: "zfkYWDrUqAk", timeout: 3.0, session: session)

        let expectation = expectation(description: "AcoustID invalid API key")
        acoustID.lookup(fingerprint) { response in
            switch response {
            case .failure(let error):
                XCTAssertEqual(error, AcoustID.Error.invalidApiKey)
            case .success(let results):
                XCTFail("\(results)")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 4.0)
    }

    func testAcoustIDNoResults() throws {
        let fingerprint = try AudioFingerprint(from: fireworksURL)

        let session = Session(cassetteName: "Fixtures/noResults", testBundle: Bundle.module)
        let acoustID = AcoustID(apiKey: "zfkYWDrOqAk", timeout: 3.0, session: session)

        let expectation = expectation(description: "AcoustID successful API lookup without results")
        acoustID.lookup(fingerprint) { response in
            switch response {
            case .failure(let error):
                XCTFail("\(error)")
            case .success(let results):
                XCTAssertTrue(results.isEmpty)
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 4.0)
    }

    func testAcoustIDSuccess() throws {
        let fingerprint = try AudioFingerprint(from: backbeatURL)

        let session = Session(cassetteName: "Fixtures/success", testBundle: Bundle.module)
        let acoustID = AcoustID(apiKey: "zfkYWDrOqAk", timeout: 3.0, session: session)

        let expectation = expectation(description: "AcoustID successful API lookup")
        acoustID.lookup(fingerprint) { response in
            switch response {
            case .failure(let error):
                XCTFail("\(error)")
            case .success(let results):
                XCTAssertEqual(results.first?.id, "8b185b60-f681-484b-96ff-9554139097b7")
                XCTAssertEqual(results.first?.score, 0.919154)
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 4.0)
    }
}
