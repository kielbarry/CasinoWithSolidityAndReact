pragma solidity ^0.4.17;

contract Casino {
	address owner;


	uint minimumBet;
	uint totalBet;
	uint numberOfBets;
	uint maxAmountOfBets = 100;
	address[] players;

	struct Player {
		uint amountBet;
		uint numberSelected;
	}

	mapping(address => Player) playerInfo;

	function Casino(uint _minimumBet) public {
		owner = msg.sender;
		if(_minimumBet != 0) _minimumBet = _minimumBet;
	}

	function kill() public {
		if(msg.sender == owner) {
			selfdestruct(owner);
		}
	}

	function bet(uint number) public payable {
		require(checkPlayerExists(msg.sender) == false);
		require(number >= 1 && number <= 10);
		require(msg.value >= minimumBet);
		playerInfo[msg.sender].amountBet = msg.value;
		playerInfo[msg.sender].numberSelected = number;
		numberOfBets += 1;
		players.push(msg.sender);
		totalBet += msg.value;
		if (numberOfBets >= maxAmountOfBets) generateNumberWinner();
	}


	function checkPlayerExists(address player) public constant returns (bool) {
		for (uint i = 0; i < players.length; i++) {
			if(players[i] == player) return true;
		}
		return false;
	}

	function generateNumberWinner() public {
		uint numberGenerated = block.number % 10 + 1;
		distributePrizes(numberGenerated);
	}

	function distributePrizes(uint numberWinner) public {
		address[100] memory winners;
		uint count = 0;

		for (uint i = 0; i < players.length; i++) {
			address playerAddress = players[i];
			if(playerInfo[playerAddress].numberSelected == numberWinner) {
				winners[count] = playerAddress;
				count++;
			}
			delete playerInfo[playerAddress];
		}
		players.length = 0;
		uint winnerEtherAmount = totalBet;
		for(uint j = 0; j < count; j ++) {
			if(winners[j] != address(0)) {
				winners[j].transfer(winnerEtherAmount);
			}
		}
		resetData();
	}


	function resetData() public {
		players.length = 0;
		totalBet = 0;
		numberOfBets = 0;
	}


	function() public payable {}
}














