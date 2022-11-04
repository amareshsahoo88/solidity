//SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract unblockedResume {

    struct student {

        string name;
        string addr ;
        uint phNo ;
        string email;
        
        }

    struct education_school {

        string school;
        uint school_percent;
        uint entry_yr;
        uint exit_yr;
        address schoolId;
    }

    struct education_coll {

        string coll;
        uint coll_percent;
        uint entry_yr;
        uint exit_yr;
        address collId;
    }

    struct professional_exp{

        string comp_name;
        string position;
        uint join_yr;
        uint exit_yr;
        address compId;

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




}