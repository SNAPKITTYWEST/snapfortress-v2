% twinmesh/subtle_logic.pl
% Prolog: Subtle Interaction Logic & Mesh Consensus
% Non-forced co-evolution through deterministic signal analysis

:- module(twinmesh_subtle, [
    subtle_response/4, should_interview/2,
    mesh_consensus/3, validate_insight/3,
    resolve_conflict/3, task_decompose/3
]).

subtle_response(Twin, Input, Context, Response) :-
    analyze_signals(Input, Twin, Signals),
    determine_strategy(Signals, Twin, Context, Strategy),
    select_template(Twin, Strategy, Template),
    fill_template_verified(Template, Twin, Signals, Response),
    verify_constraints(Response, Twin).

analyze_signals(Input, Twin, Signals) :-
    findall(Sig, (
        signal_pattern(Type, Pattern),
        sub_string(Input, _, _, _, Pattern),
        interpret_signal(Type, Twin, Sig)
    ), Signals).

signal_pattern(uncertainty, "not sure").
signal_pattern(uncertainty, "maybe").
signal_pattern(uncertainty, "i think").
signal_pattern(frustration, "stuck").
signal_pattern(frustration, "frustrat").
signal_pattern(energy,      "excited").
signal_pattern(energy,      "pumped").
signal_pattern(curiosity,   "how does").
signal_pattern(curiosity,   "what if").
signal_pattern(reflection,  "realized").
signal_pattern(reflection,  "learned").

interpret_signal(uncertainty, _, signal{type: uncertainty_expressed, confidence: 0.8, cue: curiosity_marker}).
interpret_signal(frustration, _, signal{type: frustration_detected, confidence: 0.75, cue: vulnerability_modeling}).
interpret_signal(energy,      _, signal{type: high_energy,          confidence: 0.7,  cue: depth_signal}).
interpret_signal(curiosity,   _, signal{type: curiosity_detected,   confidence: 0.8,  cue: depth_signal}).
interpret_signal(reflection,  _, signal{type: reflection_expressed, confidence: 0.75, cue: pause_invitation}).

should_interview(Context, Twin) :-
    Context.engagement > 0.7,
    Context.trust_level > 0.6,
    \+ Context.recent_interview_within_24h,
    Twin.sovereignty_settings.auto_evolution = true.

mesh_consensus(Peers, _, Consensus) :-
    maplist([P, weighted{id: P.id, weight: P.trust_score, assessment: P.assessment}]>>true, Peers, Weighted),
    aggregate_assessments(Weighted, Score),
    Consensus = consensus{peer_assessments: Weighted, consensus_score: Score}.

validate_insight(Insight, LocalGraph, Validation) :-
    ( contradicts_local(Insight, LocalGraph)
    -> Validation = validation{passed: false, entropy_delta: 0.5}
    ; corroborated_by_local(Insight, LocalGraph, _)
    -> Validation = validation{passed: true, entropy_delta: -0.02}
    ;  Validation = validation{passed: true, entropy_delta: 0.05}
    ).

resolve_conflict(Local, Peer, Resolution) :-
    ( Local.evidence_strength > Peer.evidence_strength -> Resolution = keep_local
    ; Peer.evidence_strength > Local.evidence_strength -> Resolution = adopt_peer
    ; compatible(Local, Peer) -> Resolution = merge
    ; Resolution = defer_to_operator
    ).

task_decompose(Task, Twin, Breakdown) :-
    map_task_skills(Task, Twin, Skills),
    generate_subtasks(Skills, Task, Subtasks),
    maplist(preparation_steps(Twin), Subtasks, Prep),
    ( interview_relevant(Task, Skills) -> design_prep_interview(Twin, Skills, Interview) ; Interview = none ),
    mesh_support(Twin, Skills, Support),
    Breakdown = breakdown{task: Task, subtasks: Subtasks, preparation: Prep, interview: Interview, mesh_support: Support}.
