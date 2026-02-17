// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test, Vm} from "forge-std/Test.sol";
import {Certify} from "../src/Certify.sol";

contract CertifyTest is Test {
    Certify certify;
    address authorized = makeAddr("authorized");
    address unauthorized = makeAddr("unauthorized");

    event Certified(
        bytes32 indexed identifierHash,
        bytes32 indexed contentHash,
        address indexed sender,
        string identifier,
        bytes32 commitHash,
        string description,
        uint8 schemaVersion,
        uint256 timestamp
    );

    function setUp() public {
        certify = new Certify(authorized);
    }

    // ---------------------------------------------------------------
    // Access control
    // ---------------------------------------------------------------

    function testAuthorizedCanCertify() public {
        string memory id = "owner/repo";
        bytes32 contentHash = keccak256("content");
        bytes32 commitHash = bytes32(uint256(0xabc123));
        string memory desc = "72/72 verified";

        vm.prank(authorized);
        vm.expectEmit(true, true, true, true);
        emit Certified(keccak256(bytes(id)), contentHash, authorized, id, commitHash, desc, 2, block.timestamp);
        certify.certify(id, contentHash, commitHash, desc);
    }

    function testUnauthorizedReverts() public {
        vm.prank(unauthorized);
        vm.expectRevert(abi.encodeWithSelector(Certify.UnauthorizedCertifier.selector, unauthorized, authorized));
        certify.certify("owner/repo", bytes32(0), bytes32(0), "test");
    }

    // ---------------------------------------------------------------
    // Event fields
    // ---------------------------------------------------------------

    function testEventFieldsAreCorrect() public {
        string memory id = "beneficial-ai-foundation/pmemlog";
        bytes32 contentHash = keccak256("results+specs+proofs");
        bytes32 commitHash = bytes32(uint256(0xdeadbeef));
        string memory desc = "BAIF Certification: 72/72 verified";

        uint256 expectedTime = 1700000000;
        vm.warp(expectedTime);

        vm.recordLogs();
        vm.prank(authorized);
        certify.certify(id, contentHash, commitHash, desc);

        Vm.Log[] memory logs = vm.getRecordedLogs();
        assertEq(logs.length, 1);

        // Decode non-indexed data fields
        (string memory logId, bytes32 logCommit, string memory logDesc, uint8 logVersion, uint256 logTimestamp) =
            abi.decode(logs[0].data, (string, bytes32, string, uint8, uint256));

        assertEq(logId, id);
        assertEq(logCommit, commitHash);
        assertEq(logDesc, desc);
        assertEq(logVersion, 2);
        assertEq(logTimestamp, expectedTime);

        // Verify indexed topics
        assertEq(logs[0].topics[1], keccak256(bytes(id)));
        assertEq(logs[0].topics[2], contentHash);
    }

    // ---------------------------------------------------------------
    // Schema version and constructor
    // ---------------------------------------------------------------

    function testSchemaVersion() public view {
        assertEq(certify.SCHEMA_VERSION(), 2);
    }

    function testAuthorizedCertifierIsSet() public view {
        assertEq(certify.AUTHORIZED_CERTIFIER(), authorized);
    }

    // ---------------------------------------------------------------
    // Pure helper functions
    // ---------------------------------------------------------------

    function testHashIdentifier() public view {
        string memory id = "owner/repo";
        assertEq(certify.hashIdentifier(id), keccak256(bytes(id)));
    }

    function testHashContent() public view {
        bytes memory content = hex"deadbeef";
        assertEq(certify.hashContent(content), keccak256(content));
    }
}
