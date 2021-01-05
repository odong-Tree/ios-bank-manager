//
//  BankManager.swift
//  Created by yagom.
//  Copyright © yagom academy. All rights reserved.
//
import Foundation

class BankManager {
    var bank = Bank()
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(abc), name: NSNotification.Name("새로운 업무 가능"), object: nil)
    }
    
    func openBank(bankClerkNumber: Int) {
        guard bankClerkNumber >= 1 else {
            print("bankClerkNumber에 1보다 큰 값을 입력해주세요.")
            return
        }
        
        setUpBankClerk(bankClerkNumber)
        visitClients(newClientsNumber: Int.random(in: 10...30))
        
        for _ in 1...bankClerkNumber {
            assignCounter()
        }
        
        closeBank()
    }
    
    func closeBank() {
        print("업무가 마감되었습니다. 오늘 업무를 처리한 고객은 총 \(calculateTotalProcessedClientsNumber())명이며, 총 업무시간은 \(calculateTotalOperatingTime())초입니다.")
    }
    
    func setUpBankClerk(_ bankClerkNumber: Int) {
        for i in 1...bankClerkNumber {
            bank.serviceCounter[i - 1] = BankClerk(counterNumber: i)
        }
    }
    
    func visitClients(newClientsNumber: Int) {
        guard newClientsNumber >= 0 else {
            print("newClientsNumber에 0 이상의 값을 입력해주세요.")
            return
        }
        
        if newClientsNumber == 0 {
            print("방문 고객이 없습니다!")
            return
        }
        
        for _ in 1...newClientsNumber {
            bank.totalVistedClientsNumber += 1
            let client = Client(waitingNumber: bank.totalVistedClientsNumber, business: .basic)
            
            bank.waitingList.append(client)
        }
    }
    
    @objc func abc(_ noti: Notification) {
        guard let client = bank.waitingList.first else { return }
        guard let counterNumber = noti.userInfo?["counterNumber"] as? Int else {
            return
        }
        
        bank.waitingList.removeFirst()
        bank.serviceCounter[counterNumber - 1]?.handleClientBusiness(client: client)
        }
    
    func assignCounter() {
        for bankClerk in bank.serviceCounter.values {
            guard let client = bank.waitingList.first  else {
                return
            }
            
            if bankClerk.isWorking == false {
                bank.waitingList.removeFirst()
                bankClerk.handleClientBusiness(client: client)
            }
        }
    }
}

// MARK: 마감
extension BankManager {
    func calculateTotalOperatingTime() -> Float {
        let longestWorkingTime = bank.serviceCounter.map { $0.value.totalWorkingTime }.max() ?? 0
        let roundedNumber = round(longestWorkingTime * 100) / 100
        return roundedNumber
    }
    
    func calculateTotalProcessedClientsNumber() -> Int {
        let totalProcessedClientsNumber = bank.serviceCounter.map { $0.value.totalClient }.reduce(0) { $0 + $1 }
        return totalProcessedClientsNumber
    }
}

