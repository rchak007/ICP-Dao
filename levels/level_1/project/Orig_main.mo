import Buffer "mo:base/Buffer";
import Text "mo:base/Text";

actor class DAO() {

    let name : Text = "The Government Dao";
    var manifesto : Text = "this Dao will represent the Goverment and functions will run in an automated decentralized way using ICP blockchain";
    var goals = Buffer.Buffer<Text>(10);


    public shared query func getName() : async Text {
        return name;
    };

    public shared query func getManifesto() : async Text {
        return manifesto;
    };

    public func setManifesto(newManifesto : Text) : async () {
        manifesto := newManifesto;
        return();
    };

    public func addGoal(newGoal : Text) : async () {
        goals.add(newGoal);
        return();
    };

    public shared query func getGoals() : async [Text] {
        
        return Buffer.toArray(goals);
    };
};
