//SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Loteria{
    //paga un precio para jugar y el ganador recibe 
    //la mitad del balance si gana y mitad el propietario
    //si no gana se suma al balance


    address internal owner;//propietario del contrato
    uint256 internal num;//numero que se posee
    uint256 public winnerNum;//numero ganador
    uint256 public price;//precio de jugar
    bool public game;//activo/desactivo juego(contrato)
    address public winner;//direccion ganadora(user)

    //para inicializar el contrato debe pagarse una cantidad, como dueño se le ingresa
    constructor(uint256 winNum, uint256 _price) payable{
        owner = msg.sender;
        num = 0;
        winnerNum = winNum;
        price = _price;
        game = true;
    }

    function checkWinnerNumber(uint256 _n) private view returns(bool){
        if(_n == winnerNum){
            return true;
        }else{
            return false;
        }
    }

    function numeroRandom() private view returns(uint256){
        //keccak256 es un algoritmo de codificación hash

        //los algoritmos de codificación hash tienen por característica
        //cambiar completamente con cualquier variación de las variables de entrada

        //la funcion abi.encode codifica serializando anteriormente, creando
        //un array de bytes que son pasados al metodo de codificación

        //una vez conocidos estos conceptos, la variable num se incrementará
        //a medida que se producen intentos fallidos de usuario
        // la variable now se refiere al tiempo de minado de bloque
        //a la funcion

        //de esta manera generamos un numero aleatorio de 0 al 9.
        return uint256(keccak256(abi.encode(block.timestamp,msg.sender,num)))%10;

        //!PUEDE SER HACKEADO

    }


    function participate() external payable returns(bool result, uint256 number){
        //se comprueba si el contrato esta activo
        // y si se paga el precio para participar
        require(game == true);
        require(msg.value == price);

        //se genera un numero aleatorio para el usuario
        uint256 numUser = numeroRandom();

        //se comprueba si ese numero es el ganador
        bool correct = checkWinnerNumber(numUser);


        if(correct==true){
            game = false;
            payable(msg.sender).transfer(address(this).balance/2);
            winner = msg.sender;
            result = true;
            number = numUser;
        }else{
            num++;
            result = false;
            number = numUser;
        }

    }

    function seePrice() public view returns(uint256){
        return address(this).balance - (num * (price/2));
    }

    function withdrawContractBalance() external returns(uint256){
        require(msg.sender == owner); // podriamos hacer un modifier onlyOwner
        require(game == false); // comprobar que el juego haya acabado

        //nos transferimos el balance restante que es la mitad de lo que habia 
        //antes de que terminara el juego
        payable(msg.sender).transfer(address(this).balance);
        return address(this).balance;

    }
    
}