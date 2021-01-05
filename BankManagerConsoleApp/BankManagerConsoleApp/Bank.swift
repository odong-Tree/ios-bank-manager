
import Foundation

class Bank {
    private var serviceCounter: [Int : BankClerk] = [:]
    private var waitingList: [Client] = []
    private var totalVistedClientsNumber: Int = 0
    private var numberOfEmployees: Int = 1
    var endingMent: String {
            return "업무가 마감되었습니다. 오늘 업무를 처리한 고객은 총 \(calculateTotalProcessedClientsNumber())명이며, 총 업무시간은 \(calculateTotalOperatingTime())초입니다."
    }
    lazy var initialNumberOfClients: Int = 0 {
        didSet {
            self.loadWaitingList(of: initialNumberOfClients)
            self.totalVistedClientsNumber = initialNumberOfClients
        }
    }

    init() {
        self.serviceCounter = loadBankClerks(of: numberOfEmployees)
        self.waitingList = []
        self.totalVistedClientsNumber = 0
        
        NotificationCenter.default.addObserver(self, selector: #selector(abc), name: NSNotification.Name("새로운 업무 가능"), object: nil)
    }
    
    private func loadBankClerks(of number: Int) -> [Int : BankClerk] {
        guard number >= 0 else {
            print("loadBankClerks에 0 이상의 값을 입력해주세요.")
            return [:]
        }
        
        if number == 0 {
            print("업무가 가능한 은행원이 없습니다!")
            return [:]
        }
        
        for i in 1 ... number {
            let newBankClerk = BankClerk(counterNumber: i)
            serviceCounter[i - 1] = newBankClerk
        }
        return self.serviceCounter
    }
    
    private func loadWaitingList(of size: Int) {
        for i in 1...size {
            let newClient = Client(waitingNumber: i, business: .basic(requiredTime: 0.7))
            waitingList.append(newClient)
        }
        self.totalVistedClientsNumber = size
    }
    
    func serveClient() {
        guard !waitingList.isEmpty else { return }
        
        let inProcessClient = waitingList.removeFirst()
        // bankClerk가 다수일경우, assignedEmployee를 설정하는 과정을 추가해야한다.
        guard let assignedEmployee = serviceCounter[0] else { return }
        assignedEmployee.isWorking = true
        while assignedEmployee.isWorking {
            assignedEmployee.handleBusiness(of: inProcessClient)
            assignedEmployee.isWorking = false
        }
//        }
    }
    
    @objc func abc(_ noti: Notification) {
        guard let client = waitingList.first else { return }
        guard let counterNumber = noti.userInfo?["counterNumber"] as? Int else {
            return
        }
        
        waitingList.removeFirst()
        serviceCounter[counterNumber - 1]?.handleClientBusiness(client: client)
    }
}

extension Bank {
    func calculateTotalOperatingTime() -> Float {
        let longestWorkingTime = serviceCounter.map { $0.totalWorkingTime }.max() ?? 0
        let roundedNumber = round(longestWorkingTime * 100) / 100
        return roundedNumber
    }
    
    func calculateTotalProcessedClientsNumber() -> Int {
        let totalProcessedClientsNumber = serviceCounter.map { $0.totalProcessedClients }.reduce(0) { $0 + $1 }
        return totalProcessedClientsNumber
    }
}

