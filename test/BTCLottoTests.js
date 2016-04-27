contract('BTCLotto',function(accounts){
  it("should fetch current BTC block height", function(done){
    var lotto = BTCLotto.deployed();

    lotto.firstRoll.call().then(function(blockHeight){
      assert.isAbove(blockHeight.valueOf(),1,"Bitcoin Chain isn't connected");
    }).then(done).catch(done);
  });
});
