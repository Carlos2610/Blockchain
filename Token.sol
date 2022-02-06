//SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Token{
    string public name;
    string public symbol;

    uint8 public decimals;
    uint256 public totalSuply;

    mapping(address => uint256) public balanceOf;
    //mapeo de claves con addresses de users y cantidad de tokens como valor

    //mapping pueden tener otros mappings dentro
    //la direccion como clave wallet usa un objeto (valor) que tiene
    //una address que pueden determinan que cantidad puede manejar -> tokens(uint256) 
    mapping(address => mapping(address => uint256)) public allowance;

    //El evento escucha las operaciones que suceden en el programa
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    constructor(){
        name ="InBlindersToken";
        symbol = "IBT";
        decimals = 18;
        totalSuply = 1000000 * (uint256(10)**decimals);
        balanceOf[msg.sender] = totalSuply; // inicialmente yo soy el propietario de todos los tokens
    }


    function transfer(address _to, uint256 _value) public returns(bool success){
        require(balanceOf[msg.sender] >= _value);
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;

        //quitamos el saldo del que envia y lo añadimos a la wallet destino
        emit Transfer(msg.sender,_to,_value);
        return true;

    }

    //funcion para que otras address gestionen en nuestros/otras wallets los fondos (para transferir a otras wallets)
    function approve(address _spender, uint256 _value) public returns(bool success){
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender,_spender,_value);
        return true;
    }

    //Este metodo dará el transerirá, previamente comprobando el permiso 
    //al address que lo invoque, a manejar una cantidad
    //de tokens de una wallet "from"
    function transferFrom(address _from, address _to, uint256 _value) public returns(bool success){
        //comprobamos que el saldo de la cartera desde la cual se emiten
        //los tokens tiene el valor que le hemos indicado
        require(balanceOf[_from] >= _value);
        //También comprobamos que el que desea enviar tiene permiso para gestionar
        //tokens a la cartera destino, es decir, añadir esos tokens
        require(allowance[_from][msg.sender] >= _value);

        //Equilibramos saldos
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;

        //Debemos de restar la cantidad de tokens que podia 
        //manejar la cuenta del mapa de allowance
        allowance[_from][msg.sender] -= _value;

        emit Transfer(_from,_to,_value);

        return true;
    }

}