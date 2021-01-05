
import Foundation

class BankClerk {
    var totalWorkingTime: Float = 0
    var isWorking: Bool = false
    var totalClient: Int = 0
    let counterNumber: Int
    
    init(counterNumber: Int) {
        self.counterNumber = counterNumber
    }
    
    func handleClientBusiness(client: Client) {
        switchStatus(waitingNumber: client.waitingNumber)
        
        if client.business == .basic {
            totalWorkingTime += 0.7
            totalClient += 1
        } else {
            print("죄송합니다! 제가 처리할 수 없는 업무군요 ㅠ")
        }
        
        switchStatus(waitingNumber: client.waitingNumber)
    }
    
    private func switchStatus(waitingNumber: Int) {
        switch isWorking {
        case true:
            print("\(waitingNumber)번 고객 업무 완료")
            isWorking = false
            NotificationCenter.default.post(name: NSNotification.Name("새로운 업무 가능"), object: nil, userInfo: ["counterNumber" : counterNumber])
        case false:
            print("\(waitingNumber)번 고객 업무 시작")
            isWorking = true
        }
    }
}
