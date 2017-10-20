pragma solidity ^0.4.15;

contract VoteToken{
    
    /*
    VoteToken is a token for voting on proposals where each voter's voting power
    corresponds to their portion of the total supply.
    */
    
    string public name;
    string public symbol;
    uint8 public decimals = 18;
    uint256 public totalSupply;
    
    mapping(address=>uint256) public balanceOf;
    mapping(address=>Voter) public voters;
    
    /* Initializes contract with initial supply tokens to the creator of the contract */
    function MyToken(uint256 initialSupply, string tokenName, string tokenSymbol, uint8 decimalUnits) {
        balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
        name = tokenName;                                   // Set the name for display purposes
        symbol = tokenSymbol;                               // Set the symbol for display purposes
        decimals = decimalUnits;                            // Amount of decimals for display purposes
    }
    
    event Transfer(address indexed from, address indexed to, uint256 value);
    
    /* Send coins */
    function transfer(address _to, uint256 _value) {
        require(balanceOf[msg.sender] >= _value);           // Check if the sender has enough
        require(balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
        balanceOf[msg.sender] -= _value;                    // Subtract from the sender
        balanceOf[_to] += _value;                           // Add the same to the recipient
        voters[msg.sender].reputation = balanceOf[msg.sender]/totalSupply; //update sender reputation
        voters[_to].reputation = balanceOf[_to]/totalSupply;
        /* Notify anyone listening that this transfer took place */
        Transfer(msg.sender, _to, _value);
    }
    
    
    struct Voter{
        mapping(uint256=>bool)voted;
        string name;
        uint256 reputation;
    }
    
    struct Proposal{
        uint256 weight;
    }
    mapping(uint256=>Proposal) proposals;
    uint256 count = 0;
    function createPost(){
        proposals[count]=Proposal({weight:0});
        count+=1;
    }
    
    function vote(uint256 id){
        Voter storage voter = voters[msg.sender];
        if(!voter.voted[id]){
            proposals[id].weight+=voters[msg.sender].reputation;
        }
    }
    
    
    
}