
struct Bank {
    var serviceCounter: [Int : BankClerk] = [:]
    var waitingList: [Client] = []
    var totalVistedClientsNumber: Int = 0
}

