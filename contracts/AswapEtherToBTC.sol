pragma solidity 0.4.18;


contract AswapEtherToBTC{

	struct Swap{

		address initiator;
		address participant;
		uint256 value;
		bytes32 secret;
		bytes32 hashedsecret;
		uint inittime;
		uint refundtime;
		bool emptied;

	}                                                                                                                                        

	address public owner;
	mapping(bytes32 => Swap) swaps;

	event Initiated(address _initiator, 
		address _participant,
		bytes32 _hashedsecret,
		uint _refundtime);

	event Participate(address _participant,
		address _initiator,
		bytes32 _hashedsecret,
		uint _refundtime);

	event RedeemEvent(address _msender, 
		uint256 _mvalue, 
		bytes32 _secret, 
		bytes32 _hashedsecret);

	event RefundEvent(address _msender,
		uint256 _refundvalue);
	
	function AswapEtherToBTC() public{

		owner = msg.sender;
		
	}

	function initiateSwap(address _participant, bytes32 _secret,uint _refundtime) public payable{

		bytes32 _hashedsecret = keccak256(_secret);
		swaps[_hashedsecret].initiator = msg.sender;
		swaps[_hashedsecret].participant = _participant;
		swaps[_hashedsecret].value = msg.value; 
		swaps[_hashedsecret].secret = _secret;
		swaps[_hashedsecret].hashedsecret = _hashedsecret;
		swaps[_hashedsecret].inittime = block.timestamp;
		swaps[_hashedsecret].refundtime = _refundtime;
		swaps[_hashedsecret].emptied = false;
		owner.transfer(msg.value);
		Initiated(msg.sender,_participant,_hashedsecret,_refundtime);
	}

	function participate(address _initiator, bytes32 _hashedsecret, uint _refundtime) public payable {

		swaps[_hashedsecret].initiator = _initiator;
		swaps[_hashedsecret].participant = msg.sender;
		swaps[_hashedsecret].value = msg.value;
		swaps[_hashedsecret].hashedsecret = _hashedsecret;
		swaps[_hashedsecret].inittime = block.timestamp;
		swaps[_hashedsecret].refundtime = _refundtime;
		owner.transfer(msg.value);
		Participate(msg.sender,_initiator, _hashedsecret,_refundtime);
	}
	
	modifier isRefundable(bytes32 _hashedsecret) {
		require(swaps[_hashedsecret].initiator == msg.sender);
		require(block.timestamp > swaps[_hashedsecret].refundtime);  
		require(swaps[_hashedsecret].emptied == false);
		_;
	}

	modifier isRedeemable(bytes32 _hashedsecret){

		require(swaps[_hashedsecret].participant == msg.sender);
		require(block.timestamp <= swaps[_hashedsecret].refundtime); 
		require(swaps[_hashedsecret].emptied == false);
		_;
	}

	function redeemFund(bytes32 _secret, bytes32 _hashedsecret) isRedeemable(_hashedsecret) public payable{
		require(keccak256(_secret) == _hashedsecret);
		require(swaps[_hashedsecret].value == msg.value);
		swaps[_hashedsecret].emptied = true;
		RedeemEvent(msg.sender,msg.value,_secret,_hashedsecret);
		swaps[_hashedsecret].participant.transfer(msg.value);
	}

	function refund(bytes32 _hashedsecret) isRefundable(_hashedsecret) public payable{
		require(swaps[_hashedsecret].value == msg.value);
		swaps[_hashedsecret].emptied = true;
		RefundEvent(msg.sender,msg.value);
		swaps[_hashedsecret].initiator.transfer(msg.value);
		
	}

	//function () payable public{}


}