import Account "account";
import Result "mo:base/Result";
import Nat "mo:base/Nat";
import HashMap "mo:base/HashMap";
import Bool "mo:base/Bool";
import Debug "mo:base/Debug";
import Principal "mo:base/Principal";
import Buffer "mo:base/Buffer";


actor class DAO()  {

    // For this level make sure to use the helpers function in Account.mo
    public type Subaccount = Blob;
    public type Result<A,B> = Result.Result<A,B>;
    public type Account = {
        owner : Principal;
        subaccount : ?Subaccount;
    };

    let tokenNameVar : Text = "DaoGovernment";
    let tokenSymbolVar : Text = "DAOG";


    let ledger = HashMap.HashMap<Account, Nat>(1, Account.accountsEqual, Account.accountsHash);

    public query func tokenName() : async Text {
        return tokenNameVar;
    };

    public query func tokenSymbol() : async Text {
        return tokenSymbolVar
    };

    public shared func mint(p: Principal, n: Nat) : async () {
        // first get the current tokens 
        // contruct your Account
        Debug.print("start print ****");
        Debug.print(debug_show(p));
        Debug.print(debug_show(n));
        let acc1 : Account = { 
            owner = p; 
            subaccount = null; 
        };

        let accVal : ?Nat = ledger.get(acc1);
        switch (accVal) {
            
            case (?accVal)    {   ignore ledger.replace(acc1, (accVal + n)); };
            case null { ledger.put(acc1, n);};
        };        

        // let member : ?Member = members.get(p);
    };

    public shared ({ caller }) func transfer(from : Account, to : Account, amount : Nat) : async Result<(), Text> {
        let fromVal : ?Nat = ledger.get(from);
        let toVal : ?Nat = ledger.get(to);

        var toFinalVal : Nat = 0;
        var fromFinalVal : Nat = 0;

        switch toVal {
            case (?toVal) { toFinalVal := toVal};
            case null { toFinalVal := 0};
        };


        switch (fromVal) {
            case (?fromVal)    {  
                if (fromVal >= amount) {
                    fromFinalVal := fromVal - amount;
                    ledger.put(to, (toFinalVal + amount));
                    ignore ledger.replace(from, fromFinalVal);
                    return(#ok);
                } else {
                    return #err("Not enought amount to transfer");
                };
            };
            case null { return #err("0 amount to transfer")};
        };         
        // return #err("Not implemented");
    };

    public query func balanceOf(account : Account) : async Nat {
        let accVal : ?Nat = ledger.get(account);
        switch accVal {
            case (?accVal) { return accVal};
            case null { return 0};
        }        
        // return 0;
    };

    public query func totalSupply() : async Nat {
        var totalTokenSupply : Nat = 0;

        for (value in ledger.vals()) {
          totalTokenSupply := totalTokenSupply + value;
        };
        return totalTokenSupply;        
        // return 0;
    };


    public query func showLedgerPrincipals() : async [Account] {
        let memberAll = Buffer.Buffer<Account>(10);
        
        for (key in ledger.keys()) {
          memberAll.add(key);
        };
        return Buffer.toArray(memberAll);
    };

    public query func showLedgerValues() : async [Nat] {
        let memberAll = Buffer.Buffer<Nat>(10);
        
        for (value in ledger.vals()) {
          memberAll.add(value);
        };
        return Buffer.toArray(memberAll);
    };

    public shared ({ caller }) func insertTest( n: Nat) : async () {
        // let p1: Principal = "c44vz-j26bp-6h4qn-ibrx2-cqlbs-agh5s-co63f-mcfsx-jzdgo-ui7dl-uae";

        let acc1 : Account = { 
            owner =  caller;
            subaccount = null; 
        };
        ledger.put(acc1, n);
        return;
    };

};