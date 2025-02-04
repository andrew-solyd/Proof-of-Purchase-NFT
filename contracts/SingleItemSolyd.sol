// SPDX-License-Identifier: SOLYD

pragma solidity ^0.8.0;

contract SingleItemSolyd {

	// ➡️ Initialization ➡️
	address owner;
	constructor ()  {
       owner = msg.sender;
   	}
	// set up contract states
	bool private locked = false;
	bool private live = false;
	string private stopGameReason = "NA";
	uint private launchTimestamp;
	uint stopTimestamp;
	// set up contract terms
	string contractName;
	string shopOrigin;
	string shopName;
	uint itemId;
	string itemName;
	string itemHandle;
	uint checkoutVariantId;
	string image;
	string escrowPaymentOrderId;
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
		uint timeStamp;
		uint orderNumber;
		uint shopOrderId;
		uint itemCount;
		uint pricePaid;
	}
	mapping (uint => PurchaseLedger) purchaseId;
		// maps orderNumbers to purchaseledger ids for lookup
	mapping (uint => uint) orderNumber;
	// set up player ledger 
	uint players = 0;
	struct PlayerLedger {
		uint purchaseLedgerId;
		address walletOx;
	}
	mapping (uint => PlayerLedger) playerId;
	mapping (uint => uint[]) playerNFTs;
	// set up payout ledger
	uint payments = 0;
	struct PayoutLedger {
		uint timeStamp;
		uint purchaseLedgerId;
		string payoutMethod;
		string	payoutConfirmation;
		uint payoutAmount;
	}
	mapping (uint => PayoutLedger) payoutId;
	// ➡️ Contract Functions ➡️
	// write metadata
	function writeMetaData(string memory _contractName, string memory _itemHandle, string memory _shopOrigin, string memory _shopName, uint _itemId, string memory _itemName, uint _checkoutVariantId, string memory _image) public {
		require(msg.sender == owner);
		contractName = _contractName;
		shopOrigin = _shopOrigin;
		shopName = _shopName;
		itemId = _itemId;
		itemName = _itemName;
		itemHandle = _itemHandle;
		checkoutVariantId = _checkoutVariantId;
		image = _image;
	}
	// write terms and lock contract
	function writeContractTerms(uint _itemPrice, uint _maxItems, uint _maxCashbackPercent, uint _promoCashbackPercent, uint _gameLevels, uint _gameExpires, string memory _escrowPaymentOrderId) public {
		require(msg.sender == owner);
		if (locked == false) {
			launchTimestamp = block.timestamp;
			itemPrice = _itemPrice;
			maxItems = _maxItems;
			maxCashbackPercent = _maxCashbackPercent;
			promoCashbackPercent = _promoCashbackPercent;
			gameLevels = _gameLevels;
			gameExpires = _gameExpires;
			escrowPaymentOrderId = _escrowPaymentOrderId;
			locked = true;
			live = true;
		}
	}
	// stop game
	function stopGame(string memory _stopGameReason) public {
		require(msg.sender == owner);
		if (live == true) { 
			live = false;
			stopGameReason = _stopGameReason;
			stopTimestamp = block.timestamp;
		}
	}
	// get game status
	function gameStatus() public view returns (uint, bool, uint, uint, uint, uint, uint, uint, uint, uint, string memory) {

		return (launchTimestamp, live, itemsSold, itemPrice, maxItems, maxCashbackPercent, promoCashbackPercent, gameLevels, gameExpires, stopTimestamp, stopGameReason);
	}
	function gameMetaData() public view returns (string memory, string memory, string memory, uint, string memory, string memory, uint, string memory) {
		return (contractName, shopOrigin, shopName, itemId, itemName, itemHandle, checkoutVariantId, image);
	}
	// get paypal orderId
	function getEscrowPaymentOrderId() public view returns (string memory) {
		return escrowPaymentOrderId;
	}
	// ➡️ Purchase Ledger Functions ➡️
	// new purchase write to PurchaseLedger returns purchase id 
	function writePurchase(uint _timeStamp, uint _orderNumber, uint _shopOrderId, uint _itemCount, uint _pricePaid) public {
		require(msg.sender == owner);
		// check game is live
		if ( live ) {
		// check for duplicate orders
			bool dupe = false;
			for (uint i = 0; i < purchases; i++) {
				if ( purchaseId[i].orderNumber == _orderNumber ) { dupe = true; }
			}
			if ( !dupe ) {
				uint id = purchases++;
				orderNumber[_orderNumber] = id;
				// check for max 
				if ( itemsSold + _itemCount >= maxItems) {				
					live = false;
					stopGameReason = 'MAXED';
					stopTimestamp = block.timestamp;
					uint itemCountAdjusted = maxItems - itemsSold;
					uint pricePaidAdjusted = itemCountAdjusted * itemPrice;
					purchaseId[id] = PurchaseLedger(_timeStamp, _orderNumber, _shopOrderId, itemCountAdjusted, pricePaidAdjusted);
					itemsSold = maxItems;
				} else {
					itemsSold += _itemCount;
					purchaseId[id] = PurchaseLedger(_timeStamp, _orderNumber, _shopOrderId, _itemCount, _pricePaid);
				}
			}
		}
	}
	// get full purchase ledger 
	function purchaseLedger() public view returns (uint[] memory, uint[] memory, uint[] memory, uint[] memory, uint[] memory) {
		uint[] memory timeStamp_ = new uint[](purchases);
		uint[] memory orderNumber_ = new uint[](purchases);
		uint[] memory shopOrderId_ = new uint[](purchases);
		uint[] memory itemCount_ = new uint[](purchases);
		uint[] memory pricePaid_ = new uint[](purchases);
		for (uint i = 0; i < purchases; i++) {
			PurchaseLedger memory entry = purchaseId[i];
			timeStamp_[i] = entry.timeStamp;
			orderNumber_[i] = entry.orderNumber;
			shopOrderId_[i] = entry.shopOrderId;
			itemCount_[i] = entry.itemCount;
			pricePaid_[i] = entry.pricePaid;
		}
		return(timeStamp_, orderNumber_, shopOrderId_, itemCount_, pricePaid_);
	}
	// ➡️ Player Ledger Functions ➡️
	//link wallet to player ledger return player id, new player for every new nft minted
	function newPlayer(uint _orderNumber, address _wallet0x, uint[] memory _nft) public {
		require(msg.sender == owner);
		// Test checking for dupes
		uint purchaseLedgerId_ = orderNumber[_orderNumber];
		bool dupe = false;
		// Test checking for dupes
		for (uint i = 0; i < players; i++) {
			if ( playerId[i].purchaseLedgerId == purchaseLedgerId_ ) { dupe = true; }
		}
		if ( purchaseId[purchaseLedgerId_].orderNumber != 0 && !dupe ) {
			uint id = players++;
			playerId[id] = PlayerLedger(purchaseLedgerId_, _wallet0x);
			playerNFTs[id] = _nft;
		} 
	}
	// get full player ledger
	function playerLedger() public view returns (uint[] memory, address[] memory) {
		uint[] memory orderNumber_ = new uint[](players);
		address[] memory wallet0x_ = new address[](players);
		
		for (uint i = 0; i < players; i++) {
			PlayerLedger memory entry = playerId[i];
			orderNumber_[i] = purchaseId[entry.purchaseLedgerId].orderNumber;
			wallet0x_[i] = entry.walletOx;
		}

		return (orderNumber_, wallet0x_);
	}
	function getPlayerNFTs(uint _id) public view returns (uint[] memory) {
		return playerNFTs[_id];
	}
	// ➡️ Payout Functions ➡️
	//write payout return payout id
	function writePayout(uint _timeStamp, uint _orderNumber, string memory _payoutMethod, string memory _payoutConfirmation, uint _payoutAmount) public {
		require(msg.sender == owner);
		uint purchaseLedgerId_ = orderNumber[_orderNumber];
		bool dupe = false;
		for (uint i = 0; i < payments; i++) {
			if ( payoutId[i].purchaseLedgerId == purchaseLedgerId_ ) { dupe = true; }
		}
		if ( purchaseId[purchaseLedgerId_].orderNumber != 0 && !dupe) {
			uint id = payments++;
			payoutId[id] = PayoutLedger(_timeStamp, purchaseLedgerId_, _payoutMethod, _payoutConfirmation, _payoutAmount);
		}
	} //
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
	// get full payout ledger
	function payoutLedger() public view returns (uint[] memory, uint[] memory, string[] memory, string[] memory, uint[] memory) {

		uint[] memory timeStamp_ = new uint[](payments);
		uint[] memory orderNumber_ = new uint[](payments);
		string[] memory payoutMedthod_ = new string[](payments);
		string[] memory payoutConfirmation_ = new string[](payments);
		uint[] memory payoutAmount_ = new uint[](payments);

		for (uint i = 0; i < payments; i++) {
			timeStamp_[i]=payoutId[i].timeStamp;
			orderNumber_[i] = purchaseId[payoutId[i].purchaseLedgerId].orderNumber;
			payoutMedthod_[i] = payoutId[i].payoutMethod;
			payoutConfirmation_[i] = payoutId[i].payoutConfirmation;
			payoutAmount_[i] = payoutId[i].payoutAmount;
		}

		return(timeStamp_, orderNumber_, payoutMedthod_, payoutConfirmation_, payoutAmount_);
	}

}