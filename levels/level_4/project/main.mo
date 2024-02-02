// import Account "account";
import Array "mo:base/Array";
import Result "mo:base/Result";
import TrieMap "mo:base/TrieMap";
import Buffer "mo:base/Buffer";
import HashMap "mo:base/HashMap";
import Iter "mo:base/Iter";
import Principal "mo:base/Principal";
import Nat "mo:base/Nat";
import Hash "mo:base/Hash";
import Trie "mo:base/Trie";
import Option "mo:base/Option";
import Int "mo:base/Int";
import Time "mo:base/Time";
import Nat64 "mo:base/Nat64";

import Types "types";

actor class DAO() {


    /////////////////
    //   TYPES    //
    ///////////////
    type Member = Types.Member;
    type Result<Ok, Err> = Types.Result<Ok, Err>;
    type HashMap<K, V> = Types.HashMap<K, V>;
    type Proposal = Types.Proposal;
    type ProposalContent = Types.ProposalContent;
    type ProposalId = Types.ProposalId;
    type Vote = Types.Vote;    

    // To implement the voting logic in this level you need to make use of the code implemented in previous levels.
    // That's why we bring back the code of the previous levels here.

    // For the logic of this level we need to bring back all the previous levels

    ///////////////
    // LEVEL #1 //
    /////////////

    let name : Text = "Motoko Bootcamp DAO";
    var manifesto : Text = "Empower the next wave of builders to make the Web3 revolution a reality";

    let goals : Buffer.Buffer<Text> = Buffer.Buffer<Text>(0);

    public shared query func getName() : async Text {
        return name;
    };

    public shared query func getManifesto() : async Text {
        return manifesto;   
    };

    public func setManifesto(newManifesto : Text) : async () {
        manifesto := newManifesto;
        return;
    };

    public func addGoal(newGoal : Text) : async () {
        goals.add(newGoal);
        return;
    };

    public shared query func getGoals() : async [Text] {
        return Buffer.toArray(goals);
    };

    ///////////////
    // LEVEL #2 //
    /////////////

    // public type Member = {     // definedin types.mo
    //     name : Text;
    //     age : Nat;
    // };
    // public type Result<A, B> = Result.Result<A, B>;
    // public type HashMap<A, B> = HashMap.HashMap<A, B>;

    let members : HashMap<Principal, Member> = HashMap.HashMap<Principal, Member>(0, Principal.equal, Principal.hash);

    public shared ({ caller }) func addMember(member : Member) : async Result<(), Text> {
        switch (members.get(caller)) {
            case (?member) {
                return #err("Already a member");
            };
            case (null) {
                members.put(caller, member);
                return #ok(());
            };
        };
    };

    public shared ({ caller }) func updateMember(member : Member) : async Result<(), Text> {
        switch (members.get(caller)) {
            case (?member) {
                members.put(caller, member);
                return #ok(());
            };
            case (null) {
                return #err("Not a member");
            };
        };
    };

    public shared ({ caller }) func removeMember() : async Result<(), Text> {
        switch (members.get(caller)) {
            case (?member) {
                members.delete(caller);
                return #ok(());
            };
            case (null) {
                return #err("Not a member");
            };
        };
    };

    public query func getMember(p : Principal) : async Result<Member, Text> {
        switch (members.get(p)) {
            case (?member) {
                return #ok(member);
            };
            case (null) {
                return #err("Not a member");
            };
        };
    };

    private func _getMember(p : Principal) : Result<Member, Text> {
        switch (members.get(p)) {
            case (?member) {
                return #ok(member);
            };
            case (null) {
                return #err("Not a member");
            };
        };
    };



    public query func getAllMembers() : async [Member] {
        return Iter.toArray(members.vals());
    };

    public query func numberOfMembers() : async Nat {
        return members.size();
    };

    ///////////////
    // LEVEL #3 //
    /////////////

    public type Subaccount = Blob;
    public type Account = {
        owner : Principal;
        subaccount : ?Subaccount;
    };

    let nameToken = "Motoko Bootcamp Token";
    let symbolToken = "MBT";

    // let ledger : TrieMap.TrieMap<Account, Nat> = TrieMap.TrieMap(Account.accountsEqual, Account.accountsHash);
    let ledger = HashMap.HashMap<Principal, Nat>(0, Principal.equal, Principal.hash);


    public query func getAllLedgerPrincipals() : async [Principal] {
        return Iter.toArray(ledger.keys());
    };

    public query func getAllLedgerVals() : async [Nat] {
        return Iter.toArray(ledger.vals());
    };


    public query func tokenName() : async Text {
        return nameToken;
    };

    public query func tokenSymbol() : async Text {
        return symbolToken;
    };

    // public func mint(owner : Principal, amount : Nat) : async () {
    //     let defaultAccount = { owner = owner; subaccount = null };
    //     switch (ledger.get(defaultAccount)) {
    //         case (null) {
    //             ledger.put(defaultAccount, amount);
    //         };
    //         case (?some) {
    //             ledger.put(defaultAccount, some + amount);
    //         };
    //     };
    //     return;
    // };

    public func mint(owner : Principal, amount : Nat) : async Result<(), Text> {
        let balance = Option.get(ledger.get(owner), 0);
        ledger.put(owner, balance + amount);
        return #ok();
    };

    public shared ({ caller }) func transfer(from : Account, to : Account, amount : Nat) : async Result<(), Text> {
        let fromBalance = switch (ledger.get(from.owner)) {
            case (null) { 0 };
            case (?some) { some };
        };
        if (fromBalance < amount) {
            return #err("Not enough balance");
        };
        let toBalance = switch (ledger.get(to.owner)) {
            case (null) { 0 };
            case (?some) { some };
        };
        ledger.put(from.owner, fromBalance - amount);
        ledger.put(to.owner, toBalance + amount);
        return #ok();
    };

    // public query func balanceOf(account : Account) : async Nat {
    //     return switch (ledger.get(account)) {
    //         case (null) { 0 };
    //         case (?some) { some };
    //     };
    // };

    public query func balanceOf(owner : Principal) : async Nat {
        // return (Option.get(ledger.get(owner), 0));
        return switch (ledger.get(owner)) {
            case (null) { 0 };
            case (?some) {some};
        }
    };


    func _balanceOf(account : Account) : Nat {
        return switch (ledger.get(account.owner)) {
            case (null) { 0 };
            case (?some) { some };
        };
    };

    public query func totalSupply() : async Nat {
        var total = 0;
        for (balance in ledger.vals()) {
            total += balance;
        };
        return total;
    };

    // burn the specified amount from the defaultAccount of the specified principal
    // @trap if the defaultAccount has less token than the burned Amount
    // func _burnTokens(caller : Principal, burnAmount : Nat) {
    //     let defaultAccount = { owner = caller; subaccount = null };
    //     switch (ledger.get(defaultAccount)) {
    //         case (null) { return };
    //         case (?some) { ledger.put(defaultAccount, some - burnAmount) };
    //     };
    // };

    public func burn(owner : Principal, amount : Nat) : async Result<(), Text> {
        let balance = Option.get(ledger.get(owner), 0);
        if (balance < amount) {
            return #err("Insufficient balance to burn");
        };
        ledger.put(owner, balance - amount);
        return #ok();
    };    

    public func _burn(owner : Principal, amount : Nat) : () {
        let balance = Option.get(ledger.get(owner), 0);
        if (balance < amount) {
            return ();
        };
        ledger.put(owner, balance - amount);
        return ();
    }; 


    ///////////////
    // LEVEL #4 //
    /////////////

    public type Status = {
        #Open;
        #Accepted;
        #Rejected;
    };

    // public type Proposal = {
    //     id : Nat;
    //     status : Status;
    //     manifest : Text;
    //     votes : Int;
    //     voters : [Principal];
    // };

    public type CreateProposalOk = Nat;

    public type CreateProposalErr = {
        #NotDAOMember;
        #NotEnoughTokens;
    };

    public type CreateProposalResult = Result<CreateProposalOk, CreateProposalErr>;

    public type VoteOk = {
        #ProposalAccepted;
        #ProposalRefused;
        #ProposalOpen;
    };

    public type VoteErr = {
        #NotDAOMember;
        #ProposalNotFound;
        #NotEnoughTokens;
        #AlreadyVoted;
        #ProposalEnded;
    };

    public type VoteResult = Result<VoteOk, VoteErr>;

    var nextProposalId : Nat64 = 0;

// Custom hash function for Nat64 (if needed)
    // func hashNat64(n : Nat64) : Hash.Hash {
    //     // Implement a suitable hash function for Nat64
    //     // For simplicity, using Hash.hash here
    //     return Hash.hash(Nat64.toText(n));
    // };

    // let proposals = TrieMap.TrieMap<Nat64, Proposal>(Nat64.equal, hashNat64);
    // let proposals = TrieMap.TrieMap<Nat64, Proposal>(Nat64.equal, Hash.hash);
    let proposals = HashMap.HashMap<ProposalId, Proposal>(0, Nat64.equal, Nat64.toNat32);
    // let proposals = HashMap.HashMap<Nat64, Proposal>(0, Nat64.equal, Nat.hash);

    public shared ({ caller }) func createProposal(content : ProposalContent) : async Result<ProposalId, Text> {
        
        // we need to check caller is part of dao which is hashmap
        //    we will use the function - getMember to check that.
        //    if not error and stop.
        // we also will check if this member has Token only then move forward.
        //    we will use balance function to check this.
        // first we need to get Proposal id; we can use nextProposal id for the start of it.
        // Also initialize the status with open to begin with
        // we also will initialize vote to 1 
        

        // Check if caller is Dao Member
        let daoMember = _getMember(caller: Principal);
        var propStatus : Types.ProposalStatus = #Open;
        switch (daoMember) {
            case (#ok(member)) {
                // move on to next check. NUmber of tokens at least 1.
                let defaultCallerAccount = { owner = caller; subaccount = null };
                // let callerTokenBalance = _balanceOf(defaultCallerAccount);
                let callerTokenBalance = _balanceOf(defaultCallerAccount);
                if (callerTokenBalance > 0) {
                    // now we are good to create the proposal
                    let propId : Nat64 = nextProposalId;
                    nextProposalId := nextProposalId + 1;
                    propStatus := #Open;


                    // let propManifest : ProposalContent = { #ChangeManifesto = manifest };
                    let propManifest : ProposalContent = content;

                    let propVotes : Int = callerTokenBalance; // Intialize Vote to token balance
                    let propVoters : [Principal] = [caller];

                    if (propVotes >= 100) {
                        propStatus := #Accepted;
                    } else if (propVotes <= -100) {
                        propStatus := #Rejected;
                    };
                    var createdn : ?Time.Time = null;
                    let currentTime = Time.now();
                    let vote1 : Vote = {
                        member = caller;
                        votingPower = callerTokenBalance;
                        yesOrNo = true;
                    };


                    let proposal = {
                        id : Nat64 = propId; 
                        status : Types.ProposalStatus = propStatus;
                        content : ProposalContent = propManifest;
                        creator : Principal = caller;
                        created : Time.Time = currentTime;
                        executed : ?Time.Time = null;
                        voteScore : Int = propVotes;
                        votes : [Vote] = [vote1];
                    };
                    proposals.put(propId, proposal);
                    // _burnTokens(caller, 1);  // burn 1 token whenever vote is successful
                    _burn(caller, 1);  // burn 1 token whenever vote is successful
                    return #ok(propId);
                } else {
                    return #err("NotEnoughTokens");
                }
                
            };
            case (#err(error)) {
                return #err("NotDAOMember");
            };

        }
        // return #err(#NotImplemented);



    };

    public query func getProposal(id : Nat64) : async ?Proposal {
        switch(proposals.get(id)) {
            case(null) { return null };
            case(?proposal) { return ?proposal;  };
            
        };
        // return null;
    };


    public query func getAllProposals() : async [Proposal]{

        return Iter.toArray(proposals.vals());

    };

    public shared ({ caller }) func voteProposal(proposalId : Types.ProposalId, yesOrNo : Bool) : async Result<(), Text> {
    // public shared ({ caller }) func voteProposal(id : Nat, vote : Bool) : async VoteResult {
        
        // we need to check caller is part of dao which is hashmap
        //    we will use the function - getMember to check that.
        //    if not error and stop.
        // we also will check if this member has Token only then move forward.
        //    we will use balance function to check this.
        // we also need to check if the proposal id exists
        //    we can do get for proposals from hashMap
        // check the status of the proposal - 
        // first we need to get Proposal id; we can use nextProposal id for the start of it.
        // Also initialize the status with open to begin with
        // we also will initialize vote to 1 

        // Check if caller is Dao Member
        let daoMember = _getMember(caller: Principal);
        switch (daoMember) {
            case (#ok(member)) {
                // move on to next check. NUmber of tokens at least 1.
                let defaultCallerAccount = { owner = caller; subaccount = null };
                // let callerTokenBalance = _balanceOf(defaultCallerAccount);
                let callerTokenBalance = _balanceOf(defaultCallerAccount);
                if (callerTokenBalance > 0) {
                    // now check if proposal exists
                    switch (proposals.get(proposalId)) {
                        case(null) { return #err("ProposalNotFound");};
                        case(?proposal) {
                                let propStatus = proposal.status;
                                switch (propStatus) {
                                    case(#Open) { 
                                        // check that not being voted twice 
                                        // Use Array.find to check if the Principal exists
                                        // let found = Array.find<Principal>(proposal.votes.member, func (item : Principal) : Bool {
                                        //     return item == caller;
                                        // });

                                        let found = Array.find<Vote>(proposal.votes, func (vote : Vote) : Bool {
                                            return vote.member == caller;
                                        });

                                        if (found != null) { return #err("AlreadyVoted"); };

                                        // now we are good to vote & update the proposal
                                        let propId : Nat64 = proposalId;
                                        // nextProposalId := nextProposalId + 1;
                                        var propStatus : Status = #Open;
                                        var voteStatus : VoteOk = #ProposalOpen;

                                        let propManifest : ProposalContent = proposal.content;
                                        var propVotes: Int = 0;
                                        // vote will increase votes by total tokens they have
                                        if (yesOrNo) {
                                            propVotes := (proposal.voteScore + callerTokenBalance); 
                                        }  else {
                                            propVotes := (proposal.voteScore - callerTokenBalance); 
                                        };
                                        let propPrincipal = caller;
                                        let vote1 : Vote = {
                                            member = caller;
                                            votingPower = callerTokenBalance;
                                            yesOrNo = yesOrNo;
                                        };

                                        var propVoters : [Vote] = (proposal.votes);
                                        propVoters := Array.append<Vote>(propVoters, [vote1]);
                                        // also if we reach 100 votes + or - we close the voting as Accepted or Rejected , otherwise leave it Open>=
                                        if (propVotes >= 100) {
                                            propStatus := #Accepted;
                                            voteStatus := #ProposalAccepted;
                                        } else if (propVotes <= -100) {
                                            propStatus := #Rejected;
                                            voteStatus := #ProposalRefused;
                                        };
                                        var createdn : ?Time.Time = null;
                                        let currentTime = Time.now();


                                        let proposalFinal  = {
                                            id : Nat64 = propId; 
                                            status : Types.ProposalStatus = propStatus;
                                            // manifest = propManifest;
                                            content : Types.ProposalContent = propManifest;
                                            creator : Principal = caller;
                                            created :Time.Time= currentTime;
                                            executed : ?Time.Time = null;
                                            voteScore : Int = propVotes;
                                            votes : [Vote] = propVoters;
                                        };
                                        proposals.put(propId, proposalFinal);
                                        // _burnTokens(caller, 1);  // burn 1 token whenever vote is successful
                                        _burn(caller, 1);  // burn 1 token whenever vote is successful
                                        // return #ok(voteStatus);
                                        return #ok();
                                    };
                                    case(#Accepted) {return #err("ProposalEnded")};
                                    case(#Rejected) {return #err("ProposalEnded")};
                                };
                        };
                    };

                } else {
                    return #err("NotEnoughTokens");
                }
                
            };
            case (#err(error)) {
                return #err("NotDAOMember");
            };

        };


    };


    /// DO NOT REMOVE - Used for local testing
    public shared query ({ caller }) func whoami() : async Principal {
        return caller;
    }

};
