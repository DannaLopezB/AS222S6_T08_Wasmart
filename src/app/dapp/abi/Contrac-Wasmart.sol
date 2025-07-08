// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Billetera {
    address public owner;

    event Recibido(address indexed desde, uint256 cantidad);
    event Enviado(address indexed hacia, uint256 cantidad);

    constructor() {
        owner = msg.sender;
    }

    // Función para recibir ETH directamente (sin llamar una función)
    receive() external payable {
        emit Recibido(msg.sender, msg.value);
    }

    // También puede recibir ETH mediante una función explícita
    function depositar() external payable {
        emit Recibido(msg.sender, msg.value);
    }

    // Función para ver el balance del contrato
    function verBalance() public view returns (uint256) {
        return address(this).balance;
    }

    // Solo el owner puede enviar ETH desde el contrato
    function enviarETH(address payable destino, uint256 cantidad) public {
        require(msg.sender == owner, "No eres el propietario");
        require(address(this).balance >= cantidad, "Fondos insuficientes");

        (bool enviado, ) = destino.call{value: cantidad}("");
        require(enviado, "Fallo en el envio");

        emit Enviado(destino, cantidad);
    }
}
