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

	address owner;
	mapping(bytes32 => Swap) swaps;

	event Initiated(address _initiator, 
		address _participant,
		uint _refundtime,
		bytes32 _hashedsecret,
		uint _refundtime);



	function AswapEtherToBTC(){

		owner = msg.sender;
	}

	function initiateSwap(address _participant, bytes32 _secret,uint _refundtime) payable{

		bytes32 _hashedsecret = keccak256(_secret);
		swaps[_hashedsecret].initiator = msg.sender;
		swaps[_hashedsecret].participant = _participant;
		swaps[_hashedsecret].value = msg.value; 
		swaps[_hashedsecret].secret = _secret;
		swaps[_hashedsecret].hashedsecret = _hashedsecret;
		swaps[_hashedsecret].inittime = block.timestamp;
		swaps[_hashedsecret].refundtime = _refundtime;
		owner.transfer(msg.value);
	}

	function participate(address _initiator, bytes32 _hashedsecret, uint _refundtime) payable {

		swaps[_hashedsecret].initiator = _initiator;
		swaps[_hashedsecret].participant = msg.sender;
		swaps[_hashedsecret].value = msg.value;
		swaps[_hashedsecret].hashedsecret = _hashedsecret;
		swaps[_hashedsecret].inittime = block.timestamp;
		swaps[_hashedsecret].refundtime = _refundtime;
		owner.transfer(msg.value);
	}

	modifier isParticipant(bytes32 _hashedsecret){

		require(swaps[_hashedsecret].participant == msg.sender);
		_;
	}

	modifier isInitiator(bytes32 _initaiator){

		require(swaps[_hashedsecret].initiator == msg.sender);
		_;
	}

	modifier isRefundable(bytes32 _hashedsecret) {
		require(swaps[_hashedsecret].initiator == msg.sender);
		require(block.timestamp > swaps[_hashedsecret].refundtime);
		require(swaps[_hashedsecret].emptied = false);
		_;
	}

	function redeemFund(bytes32 _secret, bytes32 _hashedsecret) isParticipant{
		require(block.timestamp < swaps[_hashedsecret].refundtime);
		//require(swaps[_hashedsecret].participant == msg.sender);
		require(keccak256(_secret) == _hashedsecret);
		swaps[_hashedsecret].participant.transfer(swaps[_hashedsecret].value)
	}

	function refund(bytes32 _hashedsecret) isRefundable{
		//require(swaps[_hashedsecret].initiator == msg.sender);
		swaps[_hashedsecret].emptied = true;
		swaps[_hashedsecret].initiator.transfer(swaps[_hashedsecret].value);

	}

	function () payable public{}


}