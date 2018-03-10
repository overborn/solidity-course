pragma solidity 0.4.19;
contract DebtContract {
    address public owner = msg.sender;
    mapping (address => uint) public debts; 
    mapping (address => uint) public debt_requests;
    event Message(string _msg, address _adr);
    modifier onlyByOwner() {
        require(msg.sender == owner);
        _;
    }
    function requestMoney(uint _amount) public returns(bool) {
        if (debt_requests[msg.sender] != 0) {
            Message("You've already requested money", msg.sender);
            return false;
        }
        uint new_amount = debts[msg.sender] + _amount;
        if (new_amount < _amount || new_amount < debts[msg.sender]) {
            Message("You borrowed or want to too much", msg.sender);
            return false;
        }
        debt_requests[msg.sender] = _amount;
        Message("request was sent", msg.sender);
        return true;
    }
    function confirmRequest(address _lender) public onlyByOwner returns(bool) {
        if (debt_requests[_lender] == 0) {
            Message("No requests for following address", _lender);
            return false;
        }
        uint _amount = debt_requests[_lender];
        debts[_lender] += _amount;
        debt_requests[_lender] = 0;
        return true;
    }
    function deleteRequest(address _lender) public onlyByOwner returns(bool) {
        if (debt_requests[_lender] == 0) {
            Message("No requests for following address", _lender);
            return false;
        }
        debt_requests[_lender] = 0;
        Message("request was deleted", _lender);
        return true;
    }
    function returnLoan(address _lender, uint _amount) public onlyByOwner returns(bool) {
        if (_amount > debts[_lender]) {
            debts[_lender] = 0;
            Message("thank you for tips", _lender);
        } else {
            debts[_lender] -= _amount;
        }
        return true;
    }
}