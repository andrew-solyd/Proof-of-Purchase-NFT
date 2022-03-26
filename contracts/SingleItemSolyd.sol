// SPDX-License-Identifier: SOLYD

pragma solidity ^0.8.0;

contract SingleItemSolyd {

	// ➡️ Initialization ➡️
	// set up contract states
	bool private locked = false;
	bool private live = false;
	uint private launchTimestamp; 
	// set up contract terms
	uint itemPrice;
	uint maxItems;
	uint maxCashbackPercent;
	uint promoCashbackPercent;
	uint gameLevels;
	uint gameExpires;
	// set up purchase ledger
	uint purchases = 0;
	uint itemsSold = 0;
	struct PurchaseLedger {
		uint id;
		uint timeStamp;
		uint orderNumber;
		uint itemCount;
		uint pricePaid;
	}
	mapping (uint => PurchaseLedger) purchaseId;
	mapping (uint => PurchaseLedger) orderNumber;
	// set up player ledger 
	uint players = 0;
	struct PlayerLedger {
		uint purchaseLedgerId;
		address walletOx;
		uint nftTokenId;
	}
	mapping (uint => PlayerLedger) playerId;
	// set up payout ledger
	uint payments = 0;
	struct PayoutLedger {
		uint purchaseLedgerId;
		uint amount;
	}
	mapping (uint => PayoutLedger) payoutId;
	// ➡️ Contract Functions ➡️
	// write terms and lock contract
	function writeContracTerms (uint _launchTimestamp, uint _itemPrice, uint _maxItems, uint _maxCashbackPercent, uint _promoCashbackPercent, uint _gameLevels, uint _gameExpires) public {

		if (locked == false) {
			launchTimestamp = _launchTimestamp;
			itemPrice = _itemPrice;
			maxItems = _maxItems;
			maxCashbackPercent = _maxCashbackPercent;
			promoCashbackPercent = _promoCashbackPercent;
			gameLevels = _gameLevels;
			gameExpires = _gameExpires;
			locked = true;
		}
	}
	// stop contract
	function stopContract () public {
		if (live == true) { live = false; }
	}
	// get game status
	function gameStatus () public view returns (uint, bool, uint, uint, uint, uint, uint, uint, uint) {

		return (launchTimestamp, live, itemsSold, itemPrice, maxItems, maxCashbackPercent, promoCashbackPercent, gameLevels, gameExpires);
	}
	// ➡️ Purchase Ledger Functions ➡️
	// new purchase write to PurchaseLedger returns purchase id 
	function writePurchase(uint _timeStamp, uint _orderNumber, uint _itemCount, uint _pricePaid) public returns (uint) {

		// Check if order already is in ledger
		if ( orderNumber[_orderNumber].orderNumber != 0 ){
		// Check for max items  
			if ( itemsSold <= maxItems ) {
				uint id = purchases++;
				itemsSold = itemsSold + _itemCount;
				purchaseId[id] = PurchaseLedger(id, _timeStamp, _orderNumber, _itemCount, _pricePaid);
				orderNumber[_orderNumber] = PurchaseLedger(id, _timeStamp, _orderNumber, _itemCount, _pricePaid);

				return id;
			} else { return 0;}
		} else { return 0;}
	}
	// get full purchase ledger 
	function purchaseLedger() public view returns (uint[] memory, uint[] memory, uint[] memory, uint[] memory) {
		
		uint[] memory timeStamp_;
		uint[] memory orderNumber_;
		uint[] memory itemCount_;
		uint[] memory pricePaid_;

		for (uint i = 0; i < purchases; i++) {
			PurchaseLedger memory entry = purchaseId[i];
			timeStamp_[i] = entry.timeStamp;
			orderNumber_[i] = entry.orderNumber;
			itemCount_[i] = entry.itemCount;
			pricePaid_[i] = entry.pricePaid;
		}

		return(timeStamp_, orderNumber_, itemCount_, pricePaid_);
	}
	// ➡️ Player Ledger Functions ➡️
	//link wallet to player ledger return player id, new player for every new nft minted
	function newPlayer(uint _orderNumber, address _wallet0x, uint _nft) public returns (uint) {

		uint purchaseId_ = orderNumber[_orderNumber].id;
		
		if ( purchaseId_ != 0) {
			uint id = players++;
			playerId[id] = PlayerLedger(purchaseId_, _wallet0x, _nft);
			return id; 
		} else {
			return 0;
		}
	}
	// get full player ledger
	function playerLedger() public view returns (address[] memory, uint[] memory) {

		address[] memory wallet0x_ = new address[](players);
		uint[] memory nftTokenIds_ = new uint[](players);

		for (uint i = 0; i < players; i++) {
			PlayerLedger memory entry = playerId[i];
			wallet0x_[i] = entry.walletOx;
			nftTokenIds_[i] = entry.nftTokenId;
		}

		return(wallet0x_, nftTokenIds_);
	}
	// ➡️ Payout Functions ➡️
	//write payout return payout id
	function writePayout(uint _orderNumber, uint _amount ) public returns (uint) {

		uint purchaseId_ = orderNumber[_orderNumber].id;
		if ( purchaseId_ != 0) {
			uint id = payments++;
			payoutId[id] = PayoutLedger(purchaseId_, _amount);
			return id; 
		} else {
			return 0;
		}
	} 
	// get unpaid purchase ids 
	function notPaidoutPurchases() private view returns (uint[] memory) {

		uint[] memory notPaidoutPurchaseIds = new uint[](purchases);

		for (uint i = 0; i < purchases; i++) {
			for (uint j = 0; j < payments; j++) {
				if (payoutId[j].purchaseLedgerId != i) {
					notPaidoutPurchaseIds[i] = i;
				} 
			}
		}

		return (notPaidoutPurchaseIds);
	}
	// get unpaid player ids - use this to verify payouts
	function notPaidoutPlayers() public view returns (address[] memory, uint[] memory) {

		address[] memory wallets_ = new address[](players);
		uint[] memory pricePaid_ = new uint[](players);
		uint[] memory notPaidoutPurchaseIds_ = notPaidoutPurchases();

		for (uint i = 0; i < notPaidoutPurchaseIds_.length; i++) {
			if (notPaidoutPurchaseIds_[i] != 0){
				for (uint j = 0; j < players; j++) {
					if (playerId[j].purchaseLedgerId == i) {
						wallets_[j] = playerId[j].walletOx;
						pricePaid_[j] = (purchaseId[i].pricePaid);
					}
				}
			}
		}

		return (wallets_, pricePaid_);
	}
	// get full payout ledger
	function payoutLedger() public view returns (uint[] memory, uint[] memory) {

		uint[] memory orderNumber_ = new uint[](payments);
		uint[] memory amount_ = new uint[](payments);

		for (uint i = 0; i < payments; i++) {
			orderNumber_[i] = purchaseId[payoutId[i].purchaseLedgerId].orderNumber;
			amount_[i] = payoutId[i].amount;
		}

		return(orderNumber_, amount_);
	}

}




