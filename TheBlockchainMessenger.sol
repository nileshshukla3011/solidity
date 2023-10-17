// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 <0.9.0;

contract TheBlockchainMessenger {
    uint256 public changeCounter;
    address public owner;
    string public theMessage;
    constructor() {
        owner = msg.sender;
    }

    function updateTheMessage(string memory _newMessage) public {
      if(msg.sender == owner ){
        theMessage = _newMessage;
           changeCounter++;
      }

    }
}
