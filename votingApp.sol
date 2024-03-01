// SPDX-License-Identifier: MIT
pragma solidity >0.7.0 <0.9.0;

contract voting{

    struct Pemilih {
        uint weight;        // weight is acumulated by delegation
        bool voted;         // if true , orang ini sudah memilih
        address delegate;   // person delegated to
        uint vote;          // memilih salah satu index paslon 
    }

    struct Proposal {       // paslon
        string nama;        // nama paslon
        uint votedCount;    // jumlah suara
    }

    address public ketuaPemilu;

    mapping (address => Pemilih) public voters;

    Proposal[] public proposals;
 
    constructor (string[] memory namaProposal) {
        ketuaPemilu = msg.sender;
        voters[ketuaPemilu].weight = 1;

        for (uint i = 0 ; i < namaProposal.length; i++) {
            proposals.push(Proposal({
                nama : namaProposal[i],
                votedCount : 0
            }));
        }
    }

    function addresYangIkutPemilu(address voter ) public  {
        require(
            msg.sender == ketuaPemilu,
            "hanya ketua pemilu yang dapat memberikan akses"
        );
        require(
            !voters[voter].voted,
            "pemilih ini sudah ikut vote sebelumnya"
        );
        require(
            voters[voter].weight == 0);
            voters[voter].weight = 1;
    }


    function vote(uint proposal) public {
        Pemilih storage sender = voters[msg.sender];
        require(
            sender.weight != 0,
            "pemilih tidak ada hak untuk memilih"
        );
        require(
            !sender.voted,
            "sudah memilih"
        );
        sender.voted = true;
        sender.vote = proposal;

        proposals[proposal].votedCount += sender.weight;
    }

    function pemenangProposal() public view returns(uint winingproposal) {
        uint winingVotedCount = 0;
        for (uint p = 0; p < proposals.length; p++) {
            if (proposals[p].votedCount > winingVotedCount ) {
                winingVotedCount = proposals[p].votedCount;
                winingproposal = p;
            }
        }
    }

    function pemenangVoting() public view returns(string memory winerName) {
        winerName = proposals[pemenangProposal()].nama;
    }

}