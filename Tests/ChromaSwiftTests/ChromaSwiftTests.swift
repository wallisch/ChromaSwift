// Copyright (c) 2021 Philipp Wallisch
// Distributed under the MIT license, see the LICENSE file for details.

import DVR
import XCTest
@testable import ChromaSwift

class ChromaSwiftTests: XCTestCase {
    // swiftlint:disable line_length
    let backbeatURL = Bundle.module.url(forResource: "Backbeat", withExtension: "mp3", subdirectory: "Audio")!
    let backbeatFingerprint = "AQABYJGikFSmJBCPijt6Hqkj_PjgH1l-XDyOnoeW48EFBqJ-4_BxHOeRT4Z_7IFPVLWRQ3sYwzJqW3iOixZeDdoTIeVRK7jE4znCPDrOHNcI8TnKI7wUNDryfvgfnDN6QjzRLsej48e5HbeCB9UHfzHEQ3TjYPrwu_gYdOXx5cSHMw_xED2PHlPy48eDZkW_47jEQufRE4auw8cXFtaP8MmOnMdvaA9jWEftHD8uyULHhBA_hM1x5Th59ImQ7nh2yBr8o5wR5spRHncu5LxwHX0I8UbZI9eFJzquEU9Eoju8NUV-fKjM491xKjz0ohfhQ8eUH88RfjkaLkeON4R2ozmOoz92iBz6Ic-OI48uVIalSUfvQnvh9fCOPi4eXFIonNBsNPKRR9hzfDv6HDmqDd_wKjs0Q8uJVy_u8KiFV7gvbLWKvngETRThoztK0vAP7-jj4sElhcIJLZrRH3mEPce3I3yO4tvxDb2yw-HR4zeqkcdFHd-L3XB9op-MK7iPqvnxlIUd4sepoP1x69CnEj18Qg98TA_-ICWV4wjUhkFz9MdxTIceNOyQ48yOnDvuHJ2mw66h49MOlMfjCZd0nEI9QtRRK0eOPXnQDXmOariOa0H1HO7RNcfdo43S4zr-YpcHV0cvGZeE6njyw8rCFHiOiuLxH6eSHXrRi_ChY_vR5wi_o-GyI8ehqSmaH8fRYw9EDv2Q5ziRRxcqw9Kko3ehHd50eEcfFw8uKRSgeUQjz8gj7Dm-Hf2Ro9qOb7h4VCSaE--NO0Qb-cKn49iuBldN1BNOHVVznIeVhcaPc2jH49-hK9LRHz6hw8f0HD_CPMrR7sjxhtBuNMfxoMceiOwQ4jsAJAUQlAEGmDCIAGXEAQBbyohCAgEVqEACCCIUA4QYAQgBVBAgiCGAKMIgEMIAYQgwSABhFmACCACIoEKQJhAxhhhBhFBCEAABJQgAhAgBkgFBhHCCEAKEQIYgRgAjCiFhBAAOCAQQQ4IgAJgh5xhklGBKCACQI-I4QggSSCiUgBBCAKEMEM4agRwRxxFCCBJIKAAREIAIaBBQQgKBiBBCMASAAIgAgaxgSgiLiCkHKSKEAcZIIpwzhBJCiFEKQQUQIAARSBRyiBCpgGBGGCEAcEAggAQSRgBqBDkbGYWYEgIo5Ig4hCCBiFIQKSGEAUAhkBARwiGGgABCEACIUEAYpgBRADBDyjFOAA"
    let backbeatFingerprintTest4 = "AwABYJGikFSmJBB_VFTQ88gHqzvgH1mu48KP5jw0Hz8OKYPzG_CPE8ePXIZ_7IHPo6qRQ3sYw_JRO8ePS7JwptAeIQyPByeP5wjz6DhzXCPE5yiP8FKORsj74c-D3-gJ8TTaBY-O5zh93AqqBV-gK8chWnQwHb9Y1COu8TjP4SeeycXR86gcTDl-PGhW9DuOJ2Kh9Thh6Dr84cth_Qgf5ciP09DeGI2Obzm-45IsdEwI8UPYHN_xH30ihNnRLjvkwusR3miuHGWP_0LOC9fRZ4GWH2eOXBee6LhGPBGJ7vDWFPnxodp4fIdKhcdZ9IQP8Zie40eYRznaHTneENqN5jiO_tghckWPfAfy6EJlwZLCoy-09_AK7-jj4sElhcIJLTU6H3mEPce3o88RHt_wDVWVHS564vmL86hFXMePrT764omgiYaP7kHJC0d5PC7uB9conNCiGfWOfNiT4zvC56iG6_jQKzscHj1-o1oUHtfxvdgN1yf6ybiC0sebH1ampTieo6J4_Li1Q59K9IIPPdh-9EH4Bw2548ihaima_ehx9NgDfWg-5MF55DvuHI00Ha-hB950eOhj4cIlVcJRjxB1hI1yYE8edBvyo9pxBW9QPYc7outxh0cb-cJ1_NjVwD96yTiFqsfzw8rCFD8-VObx7jgVHnrRi_ChY8qP5wi_HA2XI8dNaLfRHMfRHztEDv2QZ8eRRxcqw5IiHX2hHd50eEcfFw8uKRROaDYa-cgj7Dm-HeFzoNqOb7iyoyKaE7_xkUctH59c3Nh-4qpRK8J9VM2Pp4QdGj9OBe2P_9AVHf3hEzp8TM_xI8yVB50QqA3R3Ojx4JiOByI7hMezIz8AxARABDCABGICAONMAgI5SglEAgGgAgGUICEEI0IxQIgRgBAgBAGAGECAIswBIZwCVAEjBBBUKCcAJIIKQRp0xhBDBCECUAYgAo4gABAiggAJCBCCCEAIAUIAQwxBjABGFEICCqCIAMIwBYgCgBlyjkGGCSUEA8IRcRwhBAkkFAhIEACEEwZJAgSzxDjnjFCOEGKEEwpBBwQgAhoKlJBAIAGEYMwII4AgQCGABCJCSCC02UgQxYQywBgFERGHEkKMYhYpgAxAACKFHICEIAYEQ0gYAYADAgHEkCAIAGDIOQYZJZgSginkiDiOEIIEEgoiJYSAwACFEUBECCEYAkAAgQgBRCggDFNCKETKYYIJxQA"
    let backbeatHash = "10000100010100011111010101000011"

    let fireworksURL = Bundle.module.url(forResource: "Fireworks", withExtension: "mp3", subdirectory: "Audio")!
    let fireworksFingerprint = "AQADtEmWMkmWaDjRo5l1XEOP5lmEH0cfNHQ-HF2o4SP6EH_QE80Z_MElBZ-Y4ghF1bBr1MLx489Rygfl4B-aL-Ak4-qFZ-qQZ6h-aNGPKzpOQ_yCI-9RfcEv3EEOLXWKHJU_NFIUnijRODyFeyke5OD0QG-OPPiO03jYFA9qBX6OB0doxSHB7gquBFou9Mrxo32g5Tj6oMGHhj36HChv-MLRJ0T5wP_wd_igHfnxD0dvGP2Cojn-4Wh29NmQTyv6HFr-4Ebzoz96NPtxssb5oEfzCneJsmj54TfOD76Oa8dP9K3QrPhQenhwS0BffCOOox_eo39wHg1X9Dz6DR7Doj-KPsO1o9mPK4lA5qB-9DneEI1CGmGFE6cynCnOHLh97D5q8fjQB9-NNx_uKBUu9AnhuAg_fMF-_Amq72jUQnWOvvBxG02lIc8eoMkRjsETGtrh53jUc9h0fAsuojR04sefo3EyaD7QHJH4KMfz4A8uSTp6hFmDPyia48cfHM0P7UmFE-EtPPCP_Dl0hC_O4jnKX0gJnchvoXxwB0d_9PjRC-mOO4Uo7kiLO0TzJ9iPZkf94snh5wj0UDjiJqRxUuiaFs_hUTr-D_lxaNc85OOD-jU85vjx4wmaUXioIHeK3YI-9MclH8cJvyh5HGcOLTdKTei-oHFT5MXzIUvq4yN4QvzQfBvy5WiDMDeu-9CPyDuaN8Rh9HiFI79R0R18q9Br-LhG_IcYnIcPfMTxAaJa4zh-Cz9-yPQRGhd-VKpUwt2OPTuuww8m5CT0MQquBDkdjHgkHTlRPiJEpD_6FMdj4T3KHOmh_fiDBzeeGhqP5gSO7g3EI4d_4cVvWJaP4-bR4sRxSRby4zueQzoq2ST8CzmLZ0e54_OKogF_xC_0ywgjB3XxH70eOGLmIddiuDp0Y_MeOEd-hI-C_nBVnCdxPEh1Tbh4vPABT8tRTccjLWYR8YX4RBmDL_qRK2GRv2hG9CNU8biSD9cPHY2aBaUSHs9xMM9yaBmJJ8fR52huPMJ3HI3CHu2ODz-k5AzKH88BRoeWbjF-pE8PTtPB6_hRjiHxZxQeHwd74z_CTLcQj8d39IHHK8UXDt6G3MahnXhy4jv-ZXikB8c_OA4_yFCp49fQH1eO9Dz648tRmwiTL8dX9Dm0KEoiPPrwXOgJLVUWfBeeL8IZBZImMdB14sIDKpSGN4fOgz8-HTYuG_SOTlGIxsnxKTougXmPhtnx5ZB39OHQ_IeuDD-aHl2O5_hxWhCVB78hq8e7oXyPhpyR63hr1A6aacd3vBOJV0d7I5NyAecunK3QKjJ-NFcGrTPyBD2mVMe-sMR__PiJPC3x5NB19GiqDE_CGC9YDs26o82Lpx9-WB2eF-dDHEfDMSjl44H8F95S49nxUId2OCJjZClx6eiPJi7u40pwHm9Kof0IT0cObw-sXsOVhcdl-GoEPcoJj0GN_oBGJg3-42WDKxeeHUejEvUWPAn0aDhSRSqe5GlwvLDa4ZHwSB_yg3p1PJqDR1_xg6oS6E1xpbnwG4yVKEdD1cZ1QmKPplugvcd14NIjNKJQSheuF7oFZ4k7XNoeXGD2B1rGJSOeHVfCoz-s48oo9MH5o2iW4-oBLQ5TgVk2bfjBHqq0Cw1_lBcuYMqzFKUkHdWIZsvxmfjDBNehhXqJSqRn6FOCH-FuoRmJsxMeHWsuNKOFnviF_MeL5-gO5kHXwj8OP8d7wedx-CEO__hl-MRhUiQOkwQOHzfh4zmcQ_iCyjl0aORghdGhw8fhB2_h8_jhB5_g08Al6OgJ9mh-MGTQaYd4Iq8EX_CITtLBGQwai0eCsFHhOQfDDn88dCJc3chvmNBfNH-gbUeTvcIb9BZ6vBX-QQsYGSUlWD4o7oJ-4uBRq9CXGE3Rh-UQvmjUrIip48mHPsuDpgpxUT_alcebbWCO58QzfOnhKoYcPmiyvEJZ9Bs-9PheMGh69BEc8XB1DeF8tEQ6QsyP0EPj76hcXIHP4vEs3E-QXAvC-Kh1nJKPx8dBIhcPPQl-_IeWuEc95biCo7ly1CJOPLgdVGh-HG_QjRAPq_ug2ceXxjj1ERVEcqnQv7gIHqmLW8mBjzhzhBf2NwnKV1Dp4xdR_UGTRTn05Ud9BemYbMR3lDqe5GiO6cYTksiPO8eT46SJfkkH66ikxdB3gd2P8LJhh0GvBz_eXWi0Dz3yU9CFlEmQBy_xR6h4NFaO5xFqB96Kisoh_egN10HH4MlRaDEu0cKjB93ho04kDlfQ_mAyCceh6RF8omqKD2g8aEuMHs186Dc-pSm-TOgP_0Z7g2cD3UdzhE_wFtPE49bRc0pC_MSPHz_ROA_aBaEsfIXo5EjLW-jx5dh7nMcT5sihTgdHHSaARYAZsRBFABILCBCCaCKMMAxZYQTQBgGBBBMkMACFVR4CIJQUgjECGVMKMYsAIIJQZ6jySAFCKIJEGGDNcBZZ5QE0UgsiDEAEIAQ0EYYgCxwhhAAgBCNQGCaYY3AQo4BjAhArBFIIGSkYQIIARiACBDmqEAAEkSGcUI4AggRCChhlgTKAAGSgYAYIJIRBigHBDLAGEkEJQdQQBIQAkFEKhOLECQqbEdBpgBwACmgIkAQAIQYJAIAQ6QABgGGELGJEEaCAYE4ZZoiCwjhAMBECUSAAARQYBRhgBAmHgBBIKZOYM8IRpIGAFAhBFRICIQMYIYRJRxSghggiBRFCNEwFtBAYShTBCCkBiNRACEMUAsAYAAARRBlBMEPAEEMAOUBaAKGgAAEhiCBAIMKASIYRQYxCAilDGBLIFAkEcNAQgQQkyhBCjOBCUAAQIdgY4xQgBgBgiEJKWEUUMFQABYgBjipkjICCKOOIEIQBRIRBghHEhOACEYKUEEQQpZQ0ikAmkCKEAMEAMxIgoRQwBBqKTAFEEWCYAkYRxw0YAAFHDBAKmaCEMUhARQygRBkOkFBQCQDAAUIYIIRACBFwOEEGHGScFAAgYxgzAjADCJEAIIOMEQ4CAAoxhAAjDAKIAEiEcYII4SgwSgBDDCIMAWeQIowRBZgTRghlgWFGGBWYcMIIY50SgBlsJDJIWCCEMA4w4QSBSiAhgCEGAIMEAUIRQQBBDCKElCpACMUEAEAIISRDhggGAJIMEKIQQkYApAAhxBIinADCCCgEMQIZRIhRShCqMFDCAAUIJgoIJwFQhAgiAFCAGcsQEQQIBghCQBBhFDAEMAMgIBQAJgxQyDBDgGKMMCMREkAsJpwwQChgoEDAECUUYEAAg4BhDApkjBAGOEEEgIYB"
    let fireworksHash = "00100100010001011111000101100111"
    // swiftlint:enable line_length

    func testInvalidFile() {
        XCTAssertThrowsError(try AudioFingerprint(from: URL(fileURLWithPath: "Invalid.mp3"))) { error in
            XCTAssertEqual(error as? AudioDecoder.Error, AudioDecoder.Error.invalidFile)
        }

        let licenseURL = Bundle.module.url(forResource: "LICENSE", withExtension: nil, subdirectory: "Audio")!
        XCTAssertThrowsError(try AudioFingerprint(from: licenseURL)) { error in
            XCTAssertEqual(error as? AudioDecoder.Error, AudioDecoder.Error.invalidFile)
        }
    }

    func testInvalidFingerprint() {
        XCTAssertThrowsError(try AudioFingerprint(from: "Invalid", duration: 10.0)) { error in
            XCTAssertEqual(error as? AudioFingerprint.Error, AudioFingerprint.Error.invalidFingerprint)
        }

        XCTAssertThrowsError(try AudioFingerprint(from: "", duration: 10.0)) { error in
            XCTAssertEqual(error as? AudioFingerprint.Error, AudioFingerprint.Error.invalidFingerprint)
        }
    }

    func testInvalidDuration() {
        XCTAssertThrowsError(try AudioFingerprint(from: backbeatURL, maxSampleDuration: -1.0)) { error in
            XCTAssertEqual(error as? AudioDecoder.Error, AudioDecoder.Error.invalidMaxSampleDuration)
        }

        XCTAssertThrowsError(try AudioFingerprint(from: backbeatURL, maxSampleDuration: 0.0)) { error in
            XCTAssertEqual(error as? AudioDecoder.Error, AudioDecoder.Error.invalidMaxSampleDuration)
        }

        XCTAssertThrowsError(try AudioFingerprint(from: backbeatFingerprint, duration: -1.0)) { error in
            XCTAssertEqual(error as? AudioFingerprint.Error, AudioFingerprint.Error.invalidDuration)
        }

        XCTAssertThrowsError(try AudioFingerprint(from: backbeatFingerprint, duration: 0.0)) { error in
            XCTAssertEqual(error as? AudioFingerprint.Error, AudioFingerprint.Error.invalidDuration)
        }
    }

    func testURLFingerprint() throws {
        let result = try AudioFingerprint(from: backbeatURL)

        XCTAssertEqual(result.algorithm, AudioFingerprint.Algorithm.test2)
        XCTAssertEqual(UInt(result.duration), 46)
        XCTAssertEqual(result.hash, backbeatHash)
    }

    func testStringFingerprint() throws {
        let result = try AudioFingerprint(from: backbeatFingerprint, duration: 46.0)

        XCTAssertEqual(result.algorithm, AudioFingerprint.Algorithm.test2)
        XCTAssertEqual(UInt(result.duration), 46)
        XCTAssertEqual(result.fingerprint, backbeatFingerprint)
        XCTAssertEqual(result.hash, backbeatHash)
    }

    func testAlgorithmSelection() throws {
        let result = try AudioFingerprint(from: backbeatURL, algorithm: .test4)
        XCTAssertEqual(result.algorithm, AudioFingerprint.Algorithm.test4)

        let constructedResult = try AudioFingerprint(from: result.fingerprint, duration: result.duration)
        XCTAssertEqual(constructedResult.algorithm, AudioFingerprint.Algorithm.test4)
    }

    func testFingerprintMaxSampleDuration() throws {
        let result = try AudioFingerprint(from: fireworksURL)
        XCTAssertEqual(result.algorithm, AudioFingerprint.Algorithm.test2)
        XCTAssertEqual(UInt(result.duration), 191)
        XCTAssertEqual(result.hash, fireworksHash)

        let longResult = try AudioFingerprint(from: fireworksURL, maxSampleDuration: nil)
        XCTAssertEqual(UInt(longResult.duration), 191)
        XCTAssertGreaterThan(longResult.fingerprint.count, result.fingerprint.count)

        let shortResult = try AudioFingerprint(from: fireworksURL, maxSampleDuration: 10.0)
        XCTAssertEqual(UInt(shortResult.duration), 191)
        XCTAssertLessThan(shortResult.fingerprint.count, result.fingerprint.count)
    }

    func testSimilarity() throws {
        let result = try AudioFingerprint(from: backbeatURL)
        let compareResult = try AudioFingerprint(from: backbeatFingerprint, duration: 46.0)
        XCTAssertEqual(try result.similarity(to: result), 1.00)
        XCTAssertGreaterThan(try result.similarity(to: compareResult), 0.99)

        let shortCompareResult = try AudioFingerprint(from: backbeatURL, maxSampleDuration: 10.0)
        XCTAssertGreaterThan(try result.similarity(to: shortCompareResult, ignoreSampleDuration: true), 0.99)

        let otherResult = try AudioFingerprint(from: fireworksURL)
        let otherCompareResult = try AudioFingerprint(from: fireworksFingerprint, duration: 191.0)
        XCTAssertEqual(try otherResult.similarity(to: otherResult), 1.00)
        XCTAssertGreaterThan(try otherResult.similarity(to: otherCompareResult), 0.99)

        XCTAssertLessThan(try result.similarity(to: otherResult, ignoreSampleDuration: true), 0.55)
    }

    func testInvalidSimilarity() throws {
        let result = try AudioFingerprint(from: backbeatFingerprint, duration: 46.0)
        let resultTest4 = try AudioFingerprint(from: backbeatFingerprintTest4, duration: 46.0)
        let otherResult = try AudioFingerprint(from: fireworksFingerprint, duration: 191.0)

        XCTAssertThrowsError(try result.similarity(to: otherResult)) { error in
            XCTAssertEqual(error as? AudioFingerprint.Error, AudioFingerprint.Error.sampleDurationDifference)
        }

        XCTAssertEqual(resultTest4.algorithm, AudioFingerprint.Algorithm.test4)
        XCTAssertThrowsError(try result.similarity(to: resultTest4)) { error in
            XCTAssertEqual(error as? AudioFingerprint.Error, AudioFingerprint.Error.differentAlgorithm)
        }
    }

    func testHashSimilarity() throws {
        let result = try AudioFingerprint(from: backbeatURL)

        XCTAssertEqual(try result.similarity(to: backbeatHash), 1.0)

        XCTAssertEqual(try result.similarity(to: fireworksHash), 0.78125)
    }

    func testInvalidHashSimilarity() throws {
        let result = try AudioFingerprint(from: backbeatFingerprint, duration: 46.0)

        XCTAssertThrowsError(try result.similarity(to: "Invalid")) { error in
            XCTAssertEqual(error as? AudioFingerprint.Error, AudioFingerprint.Error.invalidHash)
        }
    }

    func testAcoustIDInvalidAPIKey() throws {
        let fingerprint = try AudioFingerprint(from: backbeatFingerprint, duration: 46.0)

        let session = Session(cassetteName: "Fixtures/invalidAPIKey", testBundle: Bundle.module)
        let acoustID = AcoustID(apiKey: "zfkYWDrUqAk", timeout: 3.0, session: session)

        let lookupExpectation = expectation(description: "AcoustID invalid API key")
        acoustID.lookup(fingerprint) { response in
            switch response {
            case .failure(let error):
                XCTAssertEqual(error, AcoustID.Error.invalidApiKey)
            case .success(let results):
                XCTFail("\(results)")
            }
            lookupExpectation.fulfill()
        }

        waitForExpectations(timeout: 4.0)
    }

    func testAcoustIDInvalidFingerprint() throws {
        let fingerprint = try AudioFingerprint(from: backbeatFingerprintTest4, duration: 46.0)
        XCTAssertEqual(fingerprint.algorithm, AudioFingerprint.Algorithm.test4)

        let session = Session(cassetteName: "Fixtures/invalidFingerprint", testBundle: Bundle.module)
        let acoustID = AcoustID(apiKey: "zfkYWDrOqAk", timeout: 3.0, session: session)

        let lookupExpectation = expectation(description: "AcoustID invalid fingerprint")
        acoustID.lookup(fingerprint) { response in
            switch response {
            case .failure(let error):
                XCTAssertEqual(error, AcoustID.Error.invalidFingerprint)
            case .success(let results):
                XCTFail("\(results)")
            }
            lookupExpectation.fulfill()
        }

        waitForExpectations(timeout: 4.0)
    }

    func testAcoustIDSuccess() throws {
        let fingerprint = try AudioFingerprint(from: fireworksFingerprint, duration: 191.0)

        let session = Session(cassetteName: "Fixtures/success", testBundle: Bundle.module)
        let acoustID = AcoustID(apiKey: "zfkYWDrOqAk", timeout: 3.0, session: session)

        let lookupExpectation = expectation(description: "AcoustID successful API lookup")
        acoustID.lookup(fingerprint) { response in
            switch response {
            case .failure(let error):
                XCTFail("\(error)")
            case .success(let results):
                XCTAssertEqual(results.first?.id, "d4b1fc41-ec52-4141-90bd-009ff6c308a7")
                XCTAssertEqual(results.first?.score, 0.996269)
                XCTAssertEqual(results.first?.recordings?.first?.title, "Fireworks")
                XCTAssertEqual(results.first?.recordings?.first?.artists?.first?.name, "Alexander Nakarada")
            }
            lookupExpectation.fulfill()
        }

        waitForExpectations(timeout: 4.0)
    }
}
