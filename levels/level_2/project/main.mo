import Result "mo:base/Result";
import HashMap "mo:base/HashMap";
import Principal "mo:base/Principal";   
import Buffer "mo:base/Buffer";

actor class DAO() = this {

    public type Member = {
        name : Text;
        age : Nat;
    };
    public type Result<A, B> = Result.Result<A, B>;
    public type HashMap<A, B> = HashMap.HashMap<A, B>;

    let members = HashMap.HashMap<Principal, Member>(1, Principal.equal, Principal.hash);
    // type Result<Ok, Err> = {#ok : Ok; #err : Err};

    public shared ({ caller }) func addMember(member : Member) : async Result<(), Text> {
        if(Principal.isAnonymous(caller)){
            // We don't want to register the anonymous identity
            return(#err("Anonymous call not allowed"));
        };        
        switch (members.get(caller)) {
            case null {     members.put(caller, member);
                            return #ok(); };
            case _ { return(#err("Member already exists"))}
        };
    };

    public shared ({ caller }) func updateMember(member : Member) : async Result<(), Text> {

        let memberOld : ?Member = members.get(caller);
        if (memberOld == null ) {
            return(#err("Member does not exist to update"));
        } else {
            ignore members.replace(caller, member);  // replace with new member info
            return(#ok());
        }
        // return #err("Not implemented");
    };

    public shared ({ caller }) func removeMember() : async Result<(), Text> {
        let memberOld : ?Member = members.get(caller);
        if (memberOld == null ) {
            return(#err("Member does not exist to remove"));
        } else {
            members.delete(caller);  // replace with new member info
            return(#ok());
        }
        // return #err("Not implemented");
    };

    public query func getMember(p : Principal) : async Result<Member, Text> {
        // return #err("Not implemented");
        let member : ?Member = members.get(p);
        // if (member == null ) {
        //     return(#err("Member does not exist"));
        // } else if (member != null) {
        //     return(#ok(member)); 
        // };

        switch (member) {
            
            case (?member)    {   return #ok(member); };
            case null { return(#err("Member does not exist"))};
        };
    };

    public query func getAllMembers() : async [Member] {
        let memberAll = Buffer.Buffer<Member>(10);
        // buffer.add(1);
        // Buffer.toArray(buffer) // => [0, 1, 2, 3]
        for (value in members.vals()) {
          memberAll.add(value);
        };
        return Buffer.toArray(memberAll);
    };

    public query func numberOfMembers() : async Nat {
        return members.size()
    };

    public query func getAllPrincipals() : async [Principal] {
        let memberAll = Buffer.Buffer<Principal>(10);
        // buffer.add(1);
        // Buffer.toArray(buffer) // => [0, 1, 2, 3]
        for (key in members.keys()) {
          memberAll.add(key);
        };
        return Buffer.toArray(memberAll);
    };


};