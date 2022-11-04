//SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract unblockedResume {

    struct student {
        
        string name;
        string addr ;
        uint phNo ;
        string email;
        bool conf;
        }

    struct education_school {

        string school;
        uint school_percent;
        uint entry_yr;
        uint exit_yr;
        address schoolId;
        bool conf;
    }

    struct education_coll {

        string coll;
        uint coll_percent;
        uint entry_yr;
        uint exit_yr;
        address collId;
        bool conf;
    }

    struct professional_exp{

        string comp_name;
        string position;
        uint join_yr;
        uint exit_yr;
        address compId;
        bool conf;

    }
    

    mapping(address => student) public stu;

    mapping(address => education_school) public eduschool;

    mapping(address => education_coll) public coll;

    mapping(address => professional_exp) public comp;


     function setDetails(address _add , string memory _name , string memory _addr , uint _phNo , string memory _email) public {

        stu[_add].name = _name;
        stu[_add].addr = _addr;
        stu[_add].phNo = _phNo;
        stu[_add].email = _email;
    }

    function setSchool(address _add , string memory _school , uint _school_percent , uint _entry_yr , uint _exit_yr ,address _schoolId) public {

        eduschool[_add].school = _school;
        eduschool[_add].school_percent = _school_percent;
        eduschool[_add].entry_yr = _entry_yr;
        eduschool[_add].exit_yr = _exit_yr;
        eduschool[_add].schoolId = _schoolId;
    }

    function setcoll(address _addr , string memory _coll , uint _coll_percent , uint _entry_yr , uint _exit_yr , address _collId) public {
        coll[_addr].coll = _coll;
        coll[_addr].coll_percent = _coll_percent;
        coll[_addr].entry_yr = _entry_yr;
        coll[_addr].exit_yr = _exit_yr;
        coll[_addr].collId = _collId;
    }

    function setProfExp(address _addr , string memory _comp_name , string memory _position , uint _join_yr , uint _exit_yr , address _compId) public {
        comp[_addr].comp_name = _comp_name ;
        comp[_addr].position = _position ;
        comp[_addr].join_yr = _join_yr ;
        comp[_addr].exit_yr = _exit_yr ;
        comp[_addr].compId = _compId ;
    }


    function confirmSchooldata(address _stuScl) public {

        require(msg.sender == eduschool[_stuScl].schoolId , "You are not authorised");
        eduschool[_stuScl].conf = true;
    }

    function confirmColldata(address _stucoll) public {

        require(msg.sender == coll[_stucoll].collId , "You are not authorised");
        coll[_stucoll].conf = true;
    }

     function confirmProff(address _compId) public {

        require(msg.sender == comp[_compId].compId , "You are not authorised");
        comp[_compId].conf = true;
    }

    function jobEligibility(address _addr) public returns(string memory){

        if ((eduschool[_addr].conf = true) && (coll[_addr].conf = true) && (comp[_addr].conf = true))
        {
            return "You are eligible for a Job.";
        }
        else {
            return "You are not eligiblefor a job.";
        }
    }


}
