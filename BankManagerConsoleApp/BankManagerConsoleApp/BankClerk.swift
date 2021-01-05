import Foundation

class BankClerk {
    var totalWorkingTime: Float = 0
    var isWorking: Bool = false
    var totalProcessedClients: Int = 0
    let counterNumber: Int
    
    init(counterNumber: Int) {
        self.counterNumber = counterNumber
    }
    
    func handleBusiness(of client: Client) {
        switch client.business {
        case .basic(let requiredTime):
            print("\(client.waitingNumber)번 고객 업무 시작")
            
            totalWorkingTime += requiredTime
            totalProcessedClients += 1
            
            print("\(client.waitingNumber)번 고객 업무 종료")
            
            NotificationCenter.default.post(name: NSNotification.Name("새로운 업무 가능"), object: nil, userInfo: ["counterNumber" : counterNumber])
        }
    }
}
