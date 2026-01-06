// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {Certify} from "../src/Certify.sol";

contract DeployCertify is Script {
    function run() public returns (Certify) {
        vm.startBroadcast();
        Certify certify = new Certify();
        vm.stopBroadcast();

        console.log("Certify deployed at:", address(certify));
        return certify;
    }
}

/// @notice Certify Dalek-Lite verification progress with specific metrics
/// @dev Usage: forge script script/Certify.s.sol:CertifyDalekLiteProgress \
///             --sig "run(address,string,uint256,uint256,uint256)" \
///             <contract_address> <git_commit> <total> <with_specs> <verified> \
///             --broadcast --rpc-url <rpc>
contract CertifyDalekLiteProgress is Script {
    string constant DALEK_LITE_URL = "https://beneficial-ai-foundation.github.io/dalek-lite/";

    function run(
        address certifyAddress,
        string calldata gitCommit,
        uint256 totalFunctions,
        uint256 functionsWithSpecs,
        uint256 fullyVerified
    ) public {
        Certify certify = Certify(certifyAddress);

        console.log("Certifying Dalek-Lite progress:");
        console.log("  Git commit:", gitCommit);
        console.log("  Total functions:", totalFunctions);
        console.log("  Functions with specs:", functionsWithSpecs);
        console.log("  Fully verified:", fullyVerified);

        vm.startBroadcast();
        certify.certifyVerificationProgress(
            DALEK_LITE_URL,
            gitCommit,
            totalFunctions,
            functionsWithSpecs,
            fullyVerified
        );
        vm.stopBroadcast();
    }
}

/// @notice Certify website content hash
contract CertifyWebsiteContent is Script {
    function run(
        address certifyAddress,
        string calldata url,
        bytes32 contentHash,
        string calldata description
    ) public {
        Certify certify = Certify(certifyAddress);

        console.log("Certifying website:");
        console.log("  URL:", url);
        console.log("  Description:", description);

        vm.startBroadcast();
        certify.certifyWebsite(url, contentHash, description);
        vm.stopBroadcast();
    }
}

