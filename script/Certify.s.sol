// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {Certify} from "../src/Certify.sol";

/// @notice Deploy the Certify contract with an authorized certifier address.
/// @dev Usage:
///   forge script script/Certify.s.sol:DeployCertify \
///     --sig "run(address)" <AUTHORIZED_CERTIFIER_ADDRESS> \
///     --broadcast --rpc-url <rpc>
///
///   Private key: set ETH_PRIVATE_KEY env var (not --private-key).
contract DeployCertify is Script {
    function run(address _authorizedCertifier) public returns (Certify) {
        vm.startBroadcast();
        Certify certify = new Certify(_authorizedCertifier);
        vm.stopBroadcast();

        console.log("Certify deployed at:", address(certify));
        console.log("Authorized certifier:", _authorizedCertifier);
        console.log("Schema version:", certify.SCHEMA_VERSION());
        return certify;
    }
}

/// @notice Call certify() on an already-deployed contract (for local/anvil testing).
/// @dev The broadcaster must be the authorizedCertifier of the contract.
///
/// Usage:
///   forge script script/Certify.s.sol:CertifyDirect \
///     --sig "run(address,string,bytes32,bytes32,string)" \
///     <CONTRACT> <IDENTIFIER> <CONTENT_HASH> <COMMIT_HASH> <DESCRIPTION> \
///     --broadcast --rpc-url <rpc>
contract CertifyDirect is Script {
    function run(
        address contractAddr,
        string calldata identifier,
        bytes32 contentHash,
        bytes32 commitHash,
        string calldata description
    ) public {
        vm.startBroadcast();
        Certify(contractAddr).certify(identifier, contentHash, commitHash, description);
        vm.stopBroadcast();

        console.log("Certified:", identifier);
        console.log("Content hash:");
        console.logBytes32(contentHash);
        console.log("Commit hash:");
        console.logBytes32(commitHash);
    }
}
