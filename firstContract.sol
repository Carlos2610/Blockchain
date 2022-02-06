//SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Contract1{

    uint256 count;//variable de estado del contrato

    constructor (uint256 _c){ // constructor de contratro
        count = _c;
    }

    function setCount(uint256 _c) public{ //setter de variable de estado
        count = _c;
    }

    function getCount() public view returns(uint256){ // getter variable de estado
        return count; // funcion view no consume gas y solo lee variables, no puede escribir
    }

    function getNumber() public pure returns(uint256){
        return 34; //funcion pure no consume gas y no lee ni necesita variables de estado
    }

    






}
