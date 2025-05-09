// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title Wasmart Wallet Contract
/// @notice Este contrato simula una billetera que permite recibir y enviar ETH.
/// @dev Este contrato permite realizar depósitos y transferencias de ETH. Cualquier usuario puede interactuar con él para enviar fondos.
///
/// @custom:created-by Danna Lopez
contract Wasmart {

    /// @notice Evento emitido cuando se recibe ETH en el contrato.
    /// @param sender La dirección del que envió los fondos.
    /// @param amount La cantidad de ETH recibida.
    event Received(address indexed sender, uint amount);

    /// @notice Evento emitido cuando se envía ETH desde el contrato.
    /// @param to La dirección a la que se envían los fondos.
    /// @param amount La cantidad de ETH enviada.
    event Sent(address indexed to, uint amount);

    /// @notice Recibe ETH en el contrato. Este método permite que el contrato acepte ETH de cualquier dirección.
    /// @dev Este método es necesario para recibir fondos sin ninguna función específica.
    receive() external payable {
        emit Received(msg.sender, msg.value);
    }

    /// @notice Método opcional para recibir ETH con datos. 
    /// @dev Si los usuarios envían ETH junto con datos, este fallback lo recibirá.
    fallback() external payable {
        emit Received(msg.sender, msg.value);
    }

    /// @notice Permite ver el balance actual de ETH en el contrato.
    /// @return El saldo en ETH del contrato.
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }

    /// @notice Permite enviar ETH desde el contrato a otra cuenta.
    /// @dev La dirección que recibe los fondos y la cantidad son parámetros. Esta función sólo funciona si el contrato tiene suficiente balance.
    /// @param _to La dirección a la que se enviarán los fondos.
    /// @param _amount La cantidad de ETH a enviar.
    /// @return success Un valor booleano que indica si la transferencia fue exitosa.
    function sendTo(address payable _to, uint _amount) public returns (bool success) {
        require(address(this).balance >= _amount, "Fondos insuficientes");
        (success, ) = _to.call{value: _amount}("");
        require(success, "Fallo al enviar ETH");
        emit Sent(_to, _amount);
    }
}