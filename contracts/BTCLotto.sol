contract BTCRelay{
  function getBlockHash(uint) returns(uint);
}

contract BTCLotto {
  BTCRelay relay;
  address owner;
  mapping(bytes32 => bool) tickets;
  uint ticketPrice;
  enum Phase {Buy, Roll, Claim}
  Phase lottoPhase = Phase.Buy;
  uint[7]  rewards = [0,1,5,500,6000,14000,19000];
  uint[6] public winningNumbers;
  uint firstRoll;


  function BTCLotto(address _relay, uint price){ //with default prizes, tickets are .2 ETH
    relay = BTCRelay(_relay);
    owner = msg.sender;
    ticketPrice = price;
    firstRoll = block.number + 5760; // One day from now
  }

/*
  function setLimit  (uint limit) public {
    if(msg.sender != owner) throw;
    perBlockETHLimit = limit;
  }
  */

  function buyTicket(bytes32 hash) public {
    if(block.number >= firstRoll) lottoPhase = Phase.Roll;
    if(msg.value < ticketPrice || lottoPhase != Phase.Buy) throw;
    tickets[hash] = true;
    msg.sender.send(msg.value-ticketPrice);
  }

  function claimTicket  (uint[6] numbers, address buyer, uint nonce) public{
    getAllRolls();
    if(lottoPhase != Phase.Claim) throw;
    bytes32 hash = sha3(numbers,buyer,nonce);
    if(!tickets[hash]) throw;
    uint8 matches;
    for(uint i; i<6; i++){
      for(uint j; j<6; j++){
        if(numbers[i] == winningNumbers[j]) matches++;
      }
    }
    buyer.send(ticketPrice*rewards[matches]);
    tickets[hash] = false;
  }

  function getRoll  (uint dieNumber) public returns  (uint) {
    if(dieNumber >= 6) throw;
    uint hash = relay.getBlockHash(firstRoll+dieNumber);
    if(hash == 0) return 0;
    winningNumbers[dieNumber] = hash%52+1;
    return winningNumbers[dieNumber];
  }

  function getAllRolls(){
    if (lottoPhase != Phase.Roll) return;

    for(uint i; i<6; i++){
      if(winningNumbers[i] == 0){
        if(getRoll(i)==0) return;
      }
    }
    lottoPhase = Phase.Claim;
  }
}
