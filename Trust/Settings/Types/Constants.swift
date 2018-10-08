// Copyright DApps Platform Inc. All rights reserved.

import Foundation

public struct Constants {
    public static let keychainKeyPrefix = "trustwallet"
    public static let keychainTestsKeyPrefix = "trustwallet-tests"

    // social
    public static let website = "https://www.definer.org"
    public static let twitterUsername = "DeFinerOrg"
    public static let defaultTelegramUsername = "DeFinerEnglish"
    public static let facebookUsername = "trustwalletapp"

    public static var localizedTelegramUsernames = ["ru": "trustwallet_ru", "vi": "trustwallet_vn", "es": "trustwallet_es", "zh": "trustwallet_cn", "ja": "trustwallet_jp", "de": "trustwallet_de", "fr": "trustwallet_fr"]

    // support
    //public static let supportEmail = "support@trustwalletapp.com"
    public static let supportEmail = "admin@definer.org"

    //public static let dappsBrowserURL = "https://dapps.trustwalletapp.com/"
    public static let dappsBrowserURL = "https://app.definer.org/"
    //public static let dappsOpenSea = "https://opensea.io"
    public static let dappsOpenSea = "https://rinkeby.opensea.io"
    public static let dappsRinkebyOpenSea = "https://rinkeby.opensea.io"

    public static let images = "https://trustwalletapp.com/images"

    public static let trustAPI = URL(string: "https://public.trustwalletapp.com")!
}

public struct UnitConfiguration {
    public static let gasPriceUnit: EthereumUnit = .gwei
    public static let gasFeeUnit: EthereumUnit = .ether
}

public struct URLSchemes {
    public static let trust = "app://"
    public static let browser = trust + "browser"
}
