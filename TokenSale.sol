//SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

//declaramos una interfaz para poder comunicarse
//entre contracts y asi  utilizar las funciones 
//declaradas en el contrato original del token
interface Token{
    function decimals() external view returns(uint8);
    function balanceOf(address _address) external view returns(uint256);
    function transfer(address _to, uint256 _value) external returns (bool success);

}

contract TokenSale{
    address owner;
    uint256 price;
    Token tokenContract;
    uint256 tokensSold;

    event Sold(address buyer, uint256 amount);

    constructor(uint256 _price, address _contractAddress) {
        owner = msg.sender;
        price = _price;
        tokenContract = Token(_contractAddress);

    }

    //pueden existir brechas de seguridad para evitarlos se puede usar
    //librerias pero copiamos en este caso la funcion

    function mul(uint256 a, uint256 b) internal pure returns(uint256){
        if(a==0){
            return 0;
        }

        uint256 c = a*b;
        require(c/a == b);
        return c;
    }

    //funciones para comprar y para liquidacion de la venta para el dueño

    function buy(uint256 _nTokens) public payable {
        //se comprueba que el valor (supongo € o $) tiene que ser igual al precio del token * la cantidad
        // 300€ = 2(precio)*150(tokens)
        require(msg.value == mul(price,_nTokens));

        //se escala la cantidad de tokens *10 elevado a los decimales establecidos
        //para asi hacerlo acorde a la cantidad de decimales con los que
        //se ha estructurado nuestro token
        uint256 scaledAmount = mul(_nTokens,uint256(10)**tokenContract.decimals());

        //se comprueba que la cantidad de tokens que hay en el token inicialmente
        //añadidos por el propietario que hace el deploy, es mayor o igual que lo 
        //que se desea comprar
        require(tokenContract.balanceOf(address(this)) >= scaledAmount);
        tokensSold += _nTokens;

        require(tokenContract.transfer(msg.sender, scaledAmount));

        emit Sold(msg.sender, _nTokens);

    }

    //esta funcion hace que se dé de baja el contrato de ventas 
    //y se le transfiere al propietario la cantidad de balance del contrato
    function endSale() public payable{
        require(msg.sender == owner);
        require(tokenContract.transfer(owner,tokenContract.balanceOf(address(this))));

        payable(msg.sender).transfer(address(this).balance);
    }



}