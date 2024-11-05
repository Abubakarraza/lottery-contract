// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Lottery {
    address public manager;
    address payable[] public participants;

    constructor() {
        manager = msg.sender;
    }

    receive() external payable {
        require(msg.value == 1 ether);
        participants.push(payable(msg.sender));
    }

    function getBalance() public view returns (uint256) {
        require(msg.sender == manager);
        return address(this).balance;
    }

    function random() public view returns (uint256) {
        return
            uint256(
                keccak256(
                    abi.encodePacked(
                        block.prevrandao,
                        block.timestamp,
                        participants.length
                    )
                )
            );
    }

    function selectWinner() public {
        // must be manager to execute the select winner function
        require(msg.sender == manager);
        // participant lenght must be equal or greater then 3
        require(participants.length >= 3);
        // generate random number
        uint256 r = random();
        address payable winner;
        // get random index
        uint256 index = r % participants.length;
        // select winner
        winner = participants[index];
        // transfer ether
        winner.transfer(getBalance());
        // reset the participant array
        participants = new address payable[](0);
    }
}
