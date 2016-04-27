library Lotto { //Defines opeerations on single Lottery instances

  struct DecentralizedLotto { //Fully Decentralized, not very practical. Requires each participant to deposit FULL lotto amount
    uint startBlock;
    uint endBlock;
    uint revealDeadline;
    uint maxTickets;
    uint soldTickets;
    uint ticketPrice;
    uint confirmations;
    mapping(address => bytes32) hashCommits;
    mapping(address => uint) tickets;
    address[] confirmedTickets;
    address winner;
  }

  function makeHash(bytes32 secret, address sender) constant returns (bytes32){
    return sha3(secret,sender);
  }

  function buyTicket(DecentralizedLotto storage self, address buyer, uint value, uint number, bytes32 hash) {
    /*
    Depending on whether Solidity Libraries implement DELEGATECALL,
    use either a passed buyer and value or the msg object
    */
    if(block.number < self.startBlock ||
      block.number >= self.endBlock ||
      self.soldTickets+number >= self.maxTickets){
        throw;
      }

    if(value < number*self.maxTickets*self.ticketPrice) throw; // TODO: Ensure msg.value is meaningful

    self.tickets[buyer] = number;
    self.hashCommits[buyer] = hash;
    self.soldTickets += number;
  }

  function claimTicket(DecentralizedLotto storage self, address buyer, bytes32 secret){
    if (block.number > self.revealDeadline || block.number < self.endBlock) throw;
    if(sha3(secret,buyer) != self.hashCommits[buyer]) throw; // Invalid reveal

    for(uint i; i<self.tickets[buyer]; i++){
      self.confirmedTickets.push(buyer);
    }
    self.confirmations += self.tickets[buyer];

    delete self.tickets[buyer];
  }

  function processNTransaction(DecentralizedLotto storage self){
    if(block.number <= self.revealDeadline) throw;


  }

}
