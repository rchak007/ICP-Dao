import type { Principal } from '@dfinity/principal';
import type { ActorMethod } from '@dfinity/agent';

export interface Account {
  'owner' : Principal,
  'subaccount' : [] | [Subaccount],
}
export interface DAO {
  '_burn' : ActorMethod<[Principal, bigint], undefined>,
  'addGoal' : ActorMethod<[string], undefined>,
  'addMember' : ActorMethod<[Member], Result>,
  'balanceOf' : ActorMethod<[Principal], bigint>,
  'burn' : ActorMethod<[Principal, bigint], Result>,
  'createProposal' : ActorMethod<[ProposalContent__1], Result_2>,
  'getAllLedgerPrincipals' : ActorMethod<[], Array<Principal>>,
  'getAllLedgerVals' : ActorMethod<[], Array<bigint>>,
  'getAllMembers' : ActorMethod<[], Array<Member>>,
  'getAllProposals' : ActorMethod<[], Array<Proposal>>,
  'getGoals' : ActorMethod<[], Array<string>>,
  'getManifesto' : ActorMethod<[], string>,
  'getMember' : ActorMethod<[Principal], Result_1>,
  'getName' : ActorMethod<[], string>,
  'getProposal' : ActorMethod<[bigint], [] | [Proposal]>,
  'mint' : ActorMethod<[Principal, bigint], Result>,
  'numberOfMembers' : ActorMethod<[], bigint>,
  'removeMember' : ActorMethod<[], Result>,
  'setManifesto' : ActorMethod<[string], undefined>,
  'tokenName' : ActorMethod<[], string>,
  'tokenSymbol' : ActorMethod<[], string>,
  'totalSupply' : ActorMethod<[], bigint>,
  'transfer' : ActorMethod<[Account, Account, bigint], Result>,
  'updateMember' : ActorMethod<[Member], Result>,
  'voteProposal' : ActorMethod<[ProposalId, boolean], Result>,
  'whoami' : ActorMethod<[], Principal>,
}
export interface Member { 'age' : bigint, 'name' : string }
export interface Proposal {
  'id' : bigint,
  'status' : ProposalStatus,
  'created' : Time,
  'creator' : Principal,
  'content' : ProposalContent,
  'votes' : Array<Vote>,
  'voteScore' : bigint,
  'executed' : [] | [Time],
}
export type ProposalContent = { 'AddGoal' : string } |
  { 'ChangeManifesto' : string };
export type ProposalContent__1 = { 'AddGoal' : string } |
  { 'ChangeManifesto' : string };
export type ProposalId = bigint;
export type ProposalId__1 = bigint;
export type ProposalStatus = { 'Open' : null } |
  { 'Rejected' : null } |
  { 'Accepted' : null };
export type Result = { 'ok' : null } |
  { 'err' : string };
export type Result_1 = { 'ok' : Member } |
  { 'err' : string };
export type Result_2 = { 'ok' : ProposalId__1 } |
  { 'err' : string };
export type Subaccount = Uint8Array | number[];
export type Time = bigint;
export interface Vote {
  'member' : Principal,
  'votingPower' : bigint,
  'yesOrNo' : boolean,
}
export interface _SERVICE extends DAO {}
