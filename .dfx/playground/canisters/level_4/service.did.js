export const idlFactory = ({ IDL }) => {
  const Member = IDL.Record({ 'age' : IDL.Nat, 'name' : IDL.Text });
  const Result = IDL.Variant({ 'ok' : IDL.Null, 'err' : IDL.Text });
  const ProposalContent__1 = IDL.Variant({
    'AddGoal' : IDL.Text,
    'ChangeManifesto' : IDL.Text,
  });
  const ProposalId__1 = IDL.Nat64;
  const Result_2 = IDL.Variant({ 'ok' : ProposalId__1, 'err' : IDL.Text });
  const ProposalStatus = IDL.Variant({
    'Open' : IDL.Null,
    'Rejected' : IDL.Null,
    'Accepted' : IDL.Null,
  });
  const Time = IDL.Int;
  const ProposalContent = IDL.Variant({
    'AddGoal' : IDL.Text,
    'ChangeManifesto' : IDL.Text,
  });
  const Vote = IDL.Record({
    'member' : IDL.Principal,
    'votingPower' : IDL.Nat,
    'yesOrNo' : IDL.Bool,
  });
  const Proposal = IDL.Record({
    'id' : IDL.Nat64,
    'status' : ProposalStatus,
    'created' : Time,
    'creator' : IDL.Principal,
    'content' : ProposalContent,
    'votes' : IDL.Vec(Vote),
    'voteScore' : IDL.Int,
    'executed' : IDL.Opt(Time),
  });
  const Result_1 = IDL.Variant({ 'ok' : Member, 'err' : IDL.Text });
  const Subaccount = IDL.Vec(IDL.Nat8);
  const Account = IDL.Record({
    'owner' : IDL.Principal,
    'subaccount' : IDL.Opt(Subaccount),
  });
  const ProposalId = IDL.Nat64;
  const DAO = IDL.Service({
    '_burn' : IDL.Func([IDL.Principal, IDL.Nat], [], ['oneway']),
    'addGoal' : IDL.Func([IDL.Text], [], []),
    'addMember' : IDL.Func([Member], [Result], []),
    'balanceOf' : IDL.Func([IDL.Principal], [IDL.Nat], ['query']),
    'burn' : IDL.Func([IDL.Principal, IDL.Nat], [Result], []),
    'createProposal' : IDL.Func([ProposalContent__1], [Result_2], []),
    'getAllLedgerPrincipals' : IDL.Func(
        [],
        [IDL.Vec(IDL.Principal)],
        ['query'],
      ),
    'getAllLedgerVals' : IDL.Func([], [IDL.Vec(IDL.Nat)], ['query']),
    'getAllMembers' : IDL.Func([], [IDL.Vec(Member)], ['query']),
    'getAllProposals' : IDL.Func([], [IDL.Vec(Proposal)], ['query']),
    'getGoals' : IDL.Func([], [IDL.Vec(IDL.Text)], ['query']),
    'getManifesto' : IDL.Func([], [IDL.Text], ['query']),
    'getMember' : IDL.Func([IDL.Principal], [Result_1], ['query']),
    'getName' : IDL.Func([], [IDL.Text], ['query']),
    'getProposal' : IDL.Func([IDL.Nat64], [IDL.Opt(Proposal)], ['query']),
    'mint' : IDL.Func([IDL.Principal, IDL.Nat], [Result], []),
    'numberOfMembers' : IDL.Func([], [IDL.Nat], ['query']),
    'removeMember' : IDL.Func([], [Result], []),
    'setManifesto' : IDL.Func([IDL.Text], [], []),
    'tokenName' : IDL.Func([], [IDL.Text], ['query']),
    'tokenSymbol' : IDL.Func([], [IDL.Text], ['query']),
    'totalSupply' : IDL.Func([], [IDL.Nat], ['query']),
    'transfer' : IDL.Func([Account, Account, IDL.Nat], [Result], []),
    'updateMember' : IDL.Func([Member], [Result], []),
    'voteProposal' : IDL.Func([ProposalId, IDL.Bool], [Result], []),
    'whoami' : IDL.Func([], [IDL.Principal], ['query']),
  });
  return DAO;
};
export const init = ({ IDL }) => { return []; };
