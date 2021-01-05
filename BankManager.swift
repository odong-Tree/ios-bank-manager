//
//  BankManager.swift
//  Created by yagom.
//  Copyright © yagom academy. All rights reserved.
//
import Foundation


struct BankManager {
    private var bank: Bank
    private lazy var randomNumber: Int = 0
    
    init() {
        self.bank = Bank()
    }
    
    mutating func openBank() {
        print("은행개점")
        self.generateNumberOfClients()
        bank.serveClient()
        //bankClerk가 다수일 경우 어떤 bankClerk가 고객을 응대하는지에 대한 과정을 담아서 serve를 수정해야한다.
        print(bank.endingMent)
    }
    
    func closeBank() {
        print("종료")
    }
    
    func showMenu() {
        print(" 1 : 은행개점 \n 2 : 종료\n 입력 :", terminator: " ")
    }
    
    private mutating func generateNumberOfClients() {
        let randomNumberOfClients = Int.random(in: 10...30)
        bank.initialNumberOfClients = randomNumberOfClients
    }
}


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
        
//        closeBank()
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

