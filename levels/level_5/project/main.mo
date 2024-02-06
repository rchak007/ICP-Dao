import Result "mo:base/Result";
import HashMap "mo:base/HashMap";
import TrieMap "mo:base/TrieMap";
import Principal "mo:base/Principal";
import Text "mo:base/Text";
import Account "account";
import Buffer "mo:base/Buffer";
import Iter "mo:base/Iter";
import Blob "mo:base/Blob";
import Debug "mo:base/Debug";
import Http "http";
actor class DAO()  {

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

    func _getName() : Text {
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

    public type Member = {
        name : Text;
        age : Nat;
    };
    public type Result<A, B> = Result.Result<A, B>;
    public type HashMap<A, B> = HashMap.HashMap<A, B>;

    let dao : HashMap<Principal, Member> = HashMap.HashMap<Principal, Member>(0, Principal.equal, Principal.hash);

    public shared ({ caller }) func addMember(member : Member) : async Result<(), Text> {
        switch (dao.get(caller)) {
            case (?member) {
                return #err("Already a member");
            };
            case (null) {
                dao.put(caller, member);
                return #ok(());
            };
        };
    };

    public shared ({ caller }) func updateMember(member : Member) : async Result<(), Text> {
        switch (dao.get(caller)) {
            case (?member) {
                dao.put(caller, member);
                return #ok(());
            };
            case (null) {
                return #err("Not a member");
            };
        };
    };

    public shared ({ caller }) func removeMember() : async Result<(), Text> {
        switch (dao.get(caller)) {
            case (?member) {
                dao.delete(caller);
                return #ok(());
            };
            case (null) {
                return #err("Not a member");
            };
        };
    };

    public query func getMember(p : Principal) : async Result<Member, Text> {
        switch (dao.get(p)) {
            case (?member) {
                return #ok(member);
            };
            case (null) {
                return #err("Not a member");
            };
        };
    };

    public query func getAllMembers() : async [Member] {
        return Iter.toArray(dao.vals());
    };

    public query func numberOfMembers() : async Nat {
        return dao.size();
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

    let ledger : TrieMap.TrieMap<Account, Nat> = TrieMap.TrieMap(Account.accountsEqual, Account.accountsHash);

    public query func tokenName() : async Text {
        return nameToken;
    };

    public query func tokenSymbol() : async Text {
        return symbolToken;
    };

    public func mint(owner : Principal, amount : Nat) : async () {
        let defaultAccount = { owner = owner; subaccount = null };
        switch (ledger.get(defaultAccount)) {
            case (null) {
                ledger.put(defaultAccount, amount);
            };
            case (?some) {
                ledger.put(defaultAccount, some + amount);
            };
        };
        return;
    };

    public shared ({ caller }) func transfer(from : Account, to : Account, amount : Nat) : async Result<(), Text> {
        let fromBalance = switch (ledger.get(from)) {
            case (null) { 0 };
            case (?some) { some };
        };
        if (fromBalance < amount) {
            return #err("Not enough balance");
        };
        let toBalance = switch (ledger.get(to)) {
            case (null) { 0 };
            case (?some) { some };
        };
        ledger.put(from, fromBalance - amount);
        ledger.put(to, toBalance + amount);
        return #ok();
    };

    public query func balanceOf(account : Account) : async Nat {
        return switch (ledger.get(account)) {
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

    ///////////////
    // LEVEL #4 //
    /////////////

    public type Status = {
        #Open;
        #Accepted;
        #Rejected;
    };

    public type Proposal = {
        id : Nat;
        status : Status;
        manifest : Text;
        votes : Int;
        voters : [Principal];
    };

    public type CreateProposalOk = Nat;

    public type CreateProposalErr = {
        #NotDAOMember;
        #NotEnoughTokens;
        #NotImplemented; // This is just a placeholder - can be removed once you start Level 4
    };

    public type createProposalResult = Result<CreateProposalOk, CreateProposalErr>;

    public type VoteOk = {
        #ProposalAccepted;
        #ProposalRefused;
        #ProposalOpen;
    };

    public type VoteErr = {
        #ProposalNotFound;
        #AlreadyVoted;
        #ProposalEnded;
        #NotImplemented; // This is just a placeholder - can be removed once you start Level 4
    };

    public type voteResult = Result<VoteOk, VoteErr>;

    public shared ({ caller }) func createProposal(manifest : Text) : async createProposalResult {
        return #err(#NotImplemented);
    };

    public query func getProposal(id : Nat) : async ?Proposal {
        return null;
    };

    public shared ({ caller }) func vote(id : Nat, vote : Bool) : async voteResult {
        return #err(#NotImplemented);
    };

    ///////////////
    // LEVEL #5 //
    /////////////

    let logo : Text = "<?xml version='1.0' encoding='UTF-8'?>
<svg xmlns='http://www.w3.org/2000/svg' id='Layer_1' data-name='Layer 1' viewBox='0 0 24 24'>
  <path d='m3.5,20c1.103,0,2-.897,2-2s-.897-2-2-2-2,.897-2,2,.897,2,2,2Zm0-3c.551,0,1,.448,1,1s-.449,1-1,1-1-.448-1-1,.449-1,1-1Zm6.5,1c0,1.103.897,2,2,2s2-.897,2-2-.897-2-2-2-2,.897-2,2Zm3,0c0,.552-.449,1-1,1s-1-.448-1-1,.449-1,1-1,1,.448,1,1Zm-1-14c1.103,0,2-.897,2-2s-.897-2-2-2-2,.897-2,2,.897,2,2,2Zm0-3c.551,0,1,.448,1,1s-.449,1-1,1-1-.448-1-1,.449-1,1-1Zm6.5,17c0,1.103.897,2,2,2s2-.897,2-2-.897-2-2-2-2,.897-2,2Zm3,0c0,.552-.449,1-1,1s-1-.448-1-1,.449-1,1-1,1,.448,1,1ZM4,14h-1v-2c0-1.103.897-2,2-2h14c1.103,0,2,.897,2,2v2h-1v-2c0-.552-.449-1-1-1h-6.5v3h-1v-3h-6.5c-.551,0-1,.448-1,1v2Zm3,9v1h-1v-1c0-.552-.449-1-1-1h-3c-.551,0-1,.448-1,1v1H0v-1c0-1.103.897-2,2-2h3c1.103,0,2,.897,2,2Zm17,0v1h-1v-1c0-.552-.449-1-1-1h-3c-.551,0-1,.448-1,1v1h-1v-1c0-1.103.897-2,2-2h3c1.103,0,2,.897,2,2Zm-8.5,0v1h-1v-1c0-.552-.449-1-1-1h-3c-.551,0-1,.448-1,1v1h-1v-1c0-1.103.897-2,2-2h3c1.103,0,2,.897,2,2Zm-6-15h-1v-1c0-1.103.897-2,2-2h3c1.103,0,2,.897,2,2v1h-1v-1c0-.552-.449-1-1-1h-3c-.551,0-1,.448-1,1v1Z'/>
</svg>";


    func _getWebpage() : Text {
        var webpage = "<style>" #
        "body { text-align: center; font-family: Arial, sans-serif; background-color: #f0f8ff; color: #333; }" #
        "h1 { font-size: 3em; margin-bottom: 10px; }" #
        "hr { margin-top: 20px; margin-bottom: 20px; }" #
        "em { font-style: italic; display: block; margin-bottom: 20px; }" #
        "ul { list-style-type: none; padding: 0; }" #
        "li { margin: 10px 0; }" #
        "li:before { content: '👉 '; }" #
        "svg { max-width: 150px; height: auto; display: block; margin: 20px auto; }" #
        "h2 { text-decoration: underline; }" #
        "</style>";

        webpage := webpage # "<div><h1>" # name # "</h1></div>";
        webpage := webpage # "<em>" # manifesto # "</em>";
        webpage := webpage # "<div>" # logo # "</div>";
        webpage := webpage # "<hr>";
        webpage := webpage # "<h2>Our goals:</h2>";
        webpage := webpage # "<ul>";
        for (goal in goals.vals()) {
            webpage := webpage # "<li>" # goal # "</li>";
        };
        webpage := webpage # "</ul>";
        return webpage;
    };

    public type DAOStats = {
        name : Text;
        manifesto : Text;
        goals : [Text];
        member : [Text];
        logo : Text;
        numberOfMembers : Nat;
    };
    public type HttpRequest = Http.Request;
    public type HttpResponse = Http.Response;

    public query func http_request(request : HttpRequest) : async HttpResponse {
        return ({
            // status_code = 404;
            status_code = 200 : Nat16;  // 200 means everything is correct.
            // headers = [];
            headers = [("Content-Type", "text/html; charset=UTF-8")];  // return HTML page
            // body = Blob.fromArray([]);
            body = Text.encodeUtf8(_getWebpage());
            streaming_strategy = null;
        });
    };

    func _getMembers() : [Text] {
        let buffer = Buffer.Buffer<Text>(0);
        for (member in dao.vals()){
            buffer.add(member.name);
        };
        return Buffer.toArray(buffer);
    };



    public query func getStats() : async DAOStats {
        return ({
            name = name;
            manifesto = manifesto;
            goals = Buffer.toArray(goals);
            member = _getMembers();
            // logo = "";
            logo = logo;
            numberOfMembers = dao.size();
            // numberOfMembers = _getMembers().size(); will also work
        });
    };

};
