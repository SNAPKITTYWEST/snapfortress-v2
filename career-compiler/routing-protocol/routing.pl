% routing-protocol/routing.pl
% Prolog: Deterministic Agent Swarm Traversal Logic

:- module(routing_protocol, [route/3, traverse/4, compress/4, validate_feedback/3]).

route(AstRoot, mock_interview_coach, Plan) :-
    findall(Node, (
        ast_node(AstRoot, Node),
        node_type(Node, professional_milestone),
        ( has_attribute(Node, verification_status, unverified)
        ; has_attribute(Node, metric_density, Low), Low < 0.3
        )
    ), Nodes),
    Plan = route_plan{destination: mock_interview_coach, target_nodes: Nodes, compression: 0.8}.

route(AstRoot, reentry_fabricator, Plan) :-
    findall(Node, (
        ast_node(AstRoot, Node),
        ( node_type(Node, skill_primitive)
        ; (node_type(Node, professional_milestone), transferable_skill(Node))
        )
    ), Nodes),
    Plan = route_plan{destination: reentry_fabricator, target_nodes: Nodes, compression: 0.7}.

traverse(AstRoot, query_spec{target_types: Types, filters: Filters, depth: Depth}, _, Results) :-
    constrained_walk(AstRoot, Types, Filters, Depth, 0, [], Results).

constrained_walk(_, _, _, Max, D, Acc, Acc) :- D > Max, !.
constrained_walk(Node, Types, Filters, Max, D, Acc, Results) :-
    D =< Max,
    ( node_type(Node, T), member(T, Types), satisfies_filters(Node, Filters) -> NewAcc = [Node|Acc] ; NewAcc = Acc ),
    children(Node, Children), Next is D + 1,
    foldl([C, A, R]>>(constrained_walk(C, Types, Filters, Max, Next, A, R)), Children, NewAcc, Results).

compress(AstRoot, Target, Ratio, Output) :-
    route(AstRoot, Target, Plan),
    Plan = route_plan{target_nodes: Nodes, compression: _},
    length(Nodes, Total), K is max(1, round(Total * Ratio)),
    length(Selected, K), append(Selected, _, Nodes),
    Output = compressed{nodes: Selected, target: Target, ratio: Ratio}.

validate_feedback(CoachOutput, AstRoot, Verdict) :-
    parse_claims(CoachOutput, Claims),
    maplist(check_claim(AstRoot), Claims, Results),
    ( forall(member(R, Results), R = pass) -> Verdict = pass ; Verdict = flag(Results) ).

check_claim(AstRoot, claim{type: skill_assertion, target: T, assertion: A}, Result) :-
    ( ast_has_skill(AstRoot, T, L), proficiency_meets(L, A) -> Result = pass ; Result = flag(skill_mismatch(T, A)) ).
check_claim(_, _, flag(unknown)).
