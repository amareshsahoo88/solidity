//SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

contract Voting {
    //Declaring structure of citizen
    struct citizen{
        
        string citiName;
        string fathName;
        uint age;
        address addr;
        uint vote;
    }
    //declaring structure of candidates
    struct candidate {

        string candName;
        string partyName;
        uint voted;

    }
    //initializing deployer as the admin
    address admin = msg.sender;

    //uint[] public arr ;
    
    //using fucntion modifier for restricting access to admin
    modifier onlyAdmin{
        require(msg.sender == admin,"This authority only belongs to the admin");
        _;
    }
    //Mapping the citizen and candidates to the structure

    mapping(uint=>citizen) public citi ;
    mapping(uint=>candidate) public candi;

    //Function to add new citizen to the voter list

    function addNewCitizen(uint _citiNo , string memory _citiName , string memory _fathName, uint _age ,address _addr , uint _vote) public onlyAdmin {
        
        citi[_citiNo] = citizen(_citiName , _fathName , _age , _addr , _vote);
    }
    //Adding Candidates to the list 
    function addNewcandidate(uint _candNo , string memory _candName , string memory _partyName , uint _voted) public onlyAdmin {
        candi[_candNo] = candidate(_candName ,_partyName , _voted);
    }
    //using function to view the candidates
    function viewCandi(uint _candNo) public view returns(string memory , string memory){
        return (candi[_candNo].candName , candi[_candNo].partyName);

    }
    //Using function to view citizens
    function viewCitizen(uint _citiNo) public view returns(string memory ,string memory , uint , address){

        return(citi[_citiNo].citiName , citi[_citiNo].fathName , citi[_citiNo].age , citi[_citiNo].addr);

    }   
    //Function for Voting 
    function voting(uint _citi , uint _candNo) public returns(string memory){
        if(citi[_citi].vote <1){
            candi[_candNo].voted++ ;
            citi[_citi].vote++ ;
            return "You Have voted";

        }
        else return "You have already voted";

    }
    //Function for declaring the winner
    function declareWinner() public view returns(string memory){

        if (candi[1].voted >  candi[2].voted) {
            if (candi[1].voted >  candi[3].voted){
                return " candidate 1 is the winner ";
            }
        }
        else if (candi[2].voted >  candi[1].voted) {
            if (candi[2].voted >  candi[3].voted){
                return " candidate 2 is the winner ";
            } 
        }   
        else if (candi[3].voted >  candi[1].voted) {
            if (candi[3].voted >  candi[3].voted){
                return " candidate 3 is the winner ";
            }    

        }
    }

    }