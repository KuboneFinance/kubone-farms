
// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.6.12;

import "./Token.sol";

contract Presale is Ownable {
    address payable preSaleOwner;
    address me = address(this);
    
    // *** Config ***
    uint startPresale = 1620147600;             // unix timestamp for presale to go live
    uint256 liquidityTokenAmount = 20000 ether; // 20,000 token to liquidity - 40% of FTM - list @ 5 FTM per
    uint256 presaleTokenAmount = 50000 ether;   // 50,000 token presale - 250,000 FTM presale - 100,000 FTM soft cap
    uint256 pricePresale = 50;                  // 5 FTM PER TKN - $4
    uint256 multiplierPresale = 10;             // change to multiply above price rate
    uint256 maxPerWallet = 1000 ether;          // Max 1,000 FTM per Wallet
    // --- Config ---

    KuboneToken token; // the kubone token
    mapping(address => bool) public isWHITELIST;
    mapping(address => uint256) public amtWHITELIST;
    bool whiteListOver = false;
    
    event EmergencyERC20Drain(address indexed tokenAddress, address indexed user, uint256 amount);
    
    constructor() public {
        preSaleOwner = msg.sender;
        //token = new KuboneToken(preSaleOwner);
        
        // mint presaleTokenAmount token to presale
        //token.mint(me, presaleTokenAmount);
        
        // mint liquidityTokenAmount token to deployer for liquidity pool setup
        //token.mint(preSaleOwner, liquidityTokenAmount);

        // setup whitelists
        isWHITELIST[msg.sender] = true;
        amtWHITELIST[msg.sender] = 0;
        
        // transfer ownership & operator of token back to deployer
        //token.transferOwnership(preSaleOwner);
        //token.transferOperator(preSaleOwner);
    }

    receive() external payable {
        require(startPresale <= now, "Presale has not yet started");
        require(isWHITELIST[msg.sender] || whiteListOver, "You are not whitelisted!");
        uint amount = msg.value / pricePresale * multiplierPresale;
        require(amount <= token.balanceOf(address(this)), "Insufficient token balance in ICO");
        require((amount + amtWHITELIST[msg.sender]) <= (maxPerWallet / pricePresale * multiplierPresale), "Over Max Per Wallet");
        amtWHITELIST[msg.sender] = amtWHITELIST[msg.sender] + amount;
        token.transfer(msg.sender, amount);
    }
    
    function manualGetETH() public payable onlyOwner {
        preSaleOwner.transfer(address(this).balance);
    }
    
    function getLeftTokens() public onlyOwner {
        token.transfer(preSaleOwner, token.balanceOf(address(this)));
    }
    
    function batchAddWhitelisted(address[] memory addrs) public onlyOwner {
        for(uint i=0;i<addrs.length;i++) {
            isWHITELIST[addrs[i]] = true;
            amtWHITELIST[addrs[i]] = 0;
        }
    }

    function endWhiteListPhase() public onlyOwner {
        whiteListOver = true;
    }

    function setupToken(address _token) public onlyOwner {
        token = KuboneToken(_token);
    }
    
    // This will ONLY be used if someone accidentally sends incorrect (not FTM) tokens to the contract.
    // This way the funds can be recovered.
    function emergencyERC20Drain(BEP20 _token, uint amount) external onlyOwner {
        emit EmergencyERC20Drain(address(_token), preSaleOwner, amount);
        _token.transfer(preSaleOwner, amount);
    }
    
    
    function getStart() public view returns (uint) {
        return startPresale - now;
    }
    function tokenAddress() public view returns (address){
        return address(token);
    }
    function presaleBalance() public view returns(uint){
        return token.balanceOf(address(this));
    }
}