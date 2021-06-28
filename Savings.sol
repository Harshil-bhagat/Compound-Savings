pragma solidity ^0.6.12;


interface Erc20 {
    function approve(address, uint256) external returns (bool);

    function transfer(address, uint256) external returns (bool);
}

interface CEth {
    function mint() external payable; // To deposit to compound
    
    function approve(address spender , uint256 amount) external returns(bool);

    function redeemUnderlying(uint) external returns (uint); //To withdraw from compound
}

contract Savings{
    mapping (address => uint256) private _balances;
    address _cEthAddress;
    CEth cToken;
    
    event AddedValuesByDelegateCall(address a, uint256 b, bool success);
    
    constructor(address cethadd) public{
        _cEthAddress = cethadd;
         cToken = CEth(_cEthAddress);
    }
    
    fallback() external {
        revert();
    }
    
    receive() external payable {
        this.deposit();
    }
    
    function deposit() external payable returns(bool){
        _balances[msg.sender] += msg.value;
       
        address(cToken).delegatecall(abi.encodeWithSignature("mint()"));
        // cToken.mint.value(_balances[msg.sender])();
        
        return true;
    }
    
    function withdraw() external payable returns(bool){
        // CEth cToken = CEth(_cEthAddress);
        // address(cToken).delegatecall(abi.encodeWithSignature("redeemUnderlying(uint)",_balances[msg.sender]));
         _balances[msg.sender] -= msg.value;
        return true;
    }
    
    function withdrawFromContract() external payable returns(bool){
        // CEth cToken = CEth(_cEthAddress);
        address(cToken).delegatecall(abi.encodeWithSignature("mint()"));
         _balances[msg.sender] -= msg.value;
    }
    
    // function startSaving() external payable returns(bool){
    //     //require(_balances[msg.sender]>0,'Balance is Low!!...Deposit some Ether to start Saving');
    //     CEth cToken = CEth(_cEthAddress);
    //     if(address(this).balance >= _balances[msg.sender]){
    //         // amountTobeSent = address(this).balance - _balances[msg.sender];
    //     // bool isApproved = msg.sender.call(abi.encodeWithSignature("cToken.approve()"),abi.encode(address(this)),abi.encode(_balances[msg.sender]));
    //         address(cToken).delegatecall{gas : 1000000}(abi.encodeWithSignature("approve(address,uint256)",address(this),1000000000000000000));
    //         //address(cToken).call{value : _balances[msg.sender]}(abi.encodeWithSignature("mint()"));
    //         address(cToken).delegatecall.value(_balances[msg.sender])(abi.encodeWithSignature("mint()"));
    //         return true;
            
    //     }else{
    //         return false;
    //     }
    // }
    
    function myBalance() external view returns(uint256){
        return _balances[msg.sender];
    }
    
    function contractBalance() external view returns(uint256){
        return address(this).balance;
    }
}
