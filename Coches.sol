//SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

//ver como suceden transacciones entre contratos

contract Banco{

    address owner;//para almacenar y gestionar direcciones

    //todos los contratos pueden crear sus propios modificadores
    //de funciones para mejorar su seguridad

    modifier onlyOwner(){
        require(msg.sender == owner);
        //comprueba que la persona que invoca el contrato es la que está haciendo la operacion
        //al inicializarse en el constructor
        _;
    }

    //el saldo "balance" pertenece al contrato, no al propietario

    constructor() payable{
        owner = msg.sender;
    }

    //funcion de reasignacion de propietario para vender smart contract
    //cualquiera podria lamar a esta funcion y hacerse propietario !!brecha de seguridad!!
    function newOwner(address _newOwner) public onlyOwner{
        //debe de poseerse autoridad, solo el dueño puede otorgar la propiedad, para eso usamos Onlyowner
        owner  = _newOwner;
    }

    function getOwner() public view returns(address){
        return owner;
    }

    function getBalance() public view returns(uint256){
        return address(this).balance;
    }
    
    //funcion que recibe dinero  -> incrementa el balance de smart contract
    function incrementBalance(uint256 amount) payable public{ //payable significa que recibe saldo
        //Con require se asegura que lo que se solicita (msg.value) es lo que recibe la funcion como parametro
        require(msg.value == amount);//medida de seguridad, se revierte la operacion
    }

    //funcion que da dinero ->withdraw(transferir)
    //al ser una funcion publica cualquiera que la conozca podria llamarla
    function withdrawBalance() public onlyOwner{

        //sender hace referencia a la direccion de origen que invoca esta funcion
        //cuenta de propiedad externa del usuario que llama a la funcion en el contrato

        payable(msg.sender).transfer(address(this).balance);

        //esta sentencia indica que a el usuario que invoca esta funcion, se le transfiere
        //todo el balance del contrato
        
    }

    

    //funcion anonima para que cuando ninguna de las funciones funciona
    //function() payable public{
        //no debe usarse ya que los usuarios perderian dinero
    //}

}