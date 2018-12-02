// Copyright DApps Platform Inc. All rights reserved.

import Foundation
import Alamofire
import PromiseKit

struct ContractData {
    
    let address: String?
    let apr: Int?
    let borrowAmount: Double?
    let borrowerAddr: String?
    let collateralAmount: Double?
    let collateralApproved: Bool?
    let contractType: String?
    let currentState: Int?
    let daysPerInstallment: Int?
    let etherWithdrawable: Bool?
    let fundAddr: String?
    let fundLabel: String?
    let installmentPay: Double?
    let installmentsLeft: Int?
    let loanId: String?
    let loanType: String?
    let name: String?
    let ownerAddr: String?
    let startTime: Int?
    let tokenAddr: String?
    let tokenLabel: String?
    let totalLoanTerm: Int?
    
    init(_ dict: [String: Any]) {
        address = dict["address"] as? String
        apr = dict["apr"] as? Int
        borrowAmount = dict["borrowAmount"] as? Double
        borrowerAddr = dict["borrowerAddr"] as? String
        collateralAmount = dict["collateralAmount"] as? Double
        collateralApproved = dict["collateralApproved"] as? Bool
        contractType = dict["contractType"] as? String
        currentState = dict["currentState"] as? Int
        daysPerInstallment = dict["daysPerInstallment"] as? Int
        etherWithdrawable = dict["etherWithdrawable"] as? Bool
        fundAddr = dict["fundAddr"] as? String
        fundLabel = dict["fundLabel"] as? String
        installmentPay = dict["installmentPay"] as? Double
        installmentsLeft = dict["installmentsLeft"] as? Int
        loanId = dict["loanId"] as? String
        loanType = dict["loanType"] as? String
        name = dict["name"] as? String
        ownerAddr = dict["ownerAddr"] as? String
        startTime = dict["startTime"] as? Int
        tokenAddr = dict["tokenAddr"] as? String
        tokenLabel = dict["tokenLabel"] as? String
        totalLoanTerm = dict["totalLoanTerm"] as? Int
    }
    
    func toDictionary() -> [String: Any] {
        var jsonDict = [String: Any]()
        jsonDict["address"] = address
        jsonDict["apr"] = apr
        jsonDict["borrowAmount"] = borrowAmount
        jsonDict["borrowerAddr"] = borrowerAddr
        jsonDict["collateralAmount"] = collateralAmount
        jsonDict["collateralApproved"] = collateralApproved
        jsonDict["contractType"] = contractType
        jsonDict["currentState"] = currentState
        jsonDict["daysPerInstallment"] = daysPerInstallment
        jsonDict["etherWithdrawable"] = etherWithdrawable
        jsonDict["fundAddr"] = fundAddr
        jsonDict["fundLabel"] = fundLabel
        jsonDict["installmentPay"] = installmentPay
        jsonDict["installmentsLeft"] = installmentsLeft
        jsonDict["loanId"] = loanId
        jsonDict["loanType"] = loanType
        jsonDict["name"] = name
        jsonDict["ownerAddr"] = ownerAddr
        jsonDict["startTime"] = startTime
        jsonDict["tokenAddr"] = tokenAddr
        jsonDict["tokenLabel"] = tokenLabel
        jsonDict["totalLoanTerm"] = totalLoanTerm
        return jsonDict
    }
    
}

struct ResourceData {
    
    let createTime: String?
    var data: ContractData? = nil
    let modifyTime: String?
    let modifyTimestamp: String?
    let status: Int?
    
    init(_ dict: [String: Any]) {
        createTime = dict["create_time"] as? String
        
        if let dataDict = dict["data"] as? [String: Any] {
            data = ContractData(dataDict)
        }
        modifyTime = dict["modify_time"] as? String
        modifyTimestamp = dict["modify_timestamp"] as? String
        status = dict["status"] as? Int
    }
    
    func toDictionary() -> [String: Any] {
        var jsonDict = [String: Any]()
        jsonDict["create_time"] = createTime
        jsonDict["data"] = data?.toDictionary()
        jsonDict["modify_time"] = modifyTime
        jsonDict["modify_timestamp"] = modifyTimestamp
        jsonDict["status"] = status
        return jsonDict
    }
    
}

struct ContractClass {
    
    var data: [ResourceData]? = nil
    
    init(_ dict: [String: Any]) {
        
        if let dataDictArray = dict["data"] as? [[String: Any]] {
            data = dataDictArray.map { ResourceData($0) }
        }
    }
    
    func toDictionary() -> [String: Any] {
        var jsonDict = [String: Any]()
        jsonDict["data"] = data?.map { $0.toDictionary() }
        return jsonDict
    }
    
}

class DefinerApi {
    
    func getAccount (account : String) {
        let apiEndpoint: String = "https://app.definer.org/definer/api/v1.0/accounts/" + account.localizedLowercase
        Alamofire.request(apiEndpoint)
            .responseJSON { response in
                // check for errors
                guard response.result.error == nil else {
                    // got an error in getting the data, need to handle it
                    print("error calling GET on account")
                    print(response.result.error!)
                    return
                }
                // make sure we got some JSON since that's what we expect
                guard let json = response.result.value as? [String: Any] else {
                    print("didn't get todo object as JSON from API")
                    if let error = response.result.error {
                        print("Error: \(error)")
                    }
                    return
                }
                // get and print the title
                let accountStatus : String = json["status"] as! String
                let accountData = json["data"] as? [String: Any]
                guard let accountEmail = accountData!["email"] as? String else {
                    print("Could not get email from JSON")
                    return
                }
                print("DefinerApi: The email is: " + accountEmail)
        }
    }
    
    func getContracts() -> Promise<ContractClass> {
        return Promise { seal in
            Alamofire.request("https://app.definer.org/definer/api/v1.0/contracts")
                .validate()
                .responseJSON { response in
                    switch response.result {
                    case .success(let json):
                        guard let json = json  as? [String: Any] else {
                            return seal.reject(AFError.responseValidationFailed(reason: .dataFileNil))
                        }
                        // make sure we got some JSON since that's what we expect
                        guard let jsonText = response.result.value as? [String: Any] else {
                            print("didn't get todo object as JSON from API")
                            if let error = response.result.error {
                                print("Error: \(error)")
                            }
                            return seal.reject(AFError.responseValidationFailed(reason: .dataFileNil))
                        }
                        seal.fulfill(ContractClass(jsonText))
                    case .failure(let error):
                        seal.reject(error)
                    }
            }
        }
    }
}
