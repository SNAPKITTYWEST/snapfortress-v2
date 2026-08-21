% persona-engine/persona_routing.pl
% Prolog: Quantum Persona Routing & Collapse Logic

:- module(persona_routing, [
    compile_persona/4, collapse_superposition/3,
    verify_persona_integrity/2, project_skills/4
]).

compile_persona(AST, Context, Overrides, Persona) :-
    route_context_subgraph(AST, Context, Subgraph),
    project_skills(Subgraph, Context, Overrides, Projection),
    derive_behavioral_model(AST, Context, Behavioral),
    generate_presentation(Projection, Behavioral, Context, Presentation),
    compile_constraints(AST, Context, Overrides, Constraints),
    Persona = persona{
        context: Context,
        skill_projection: Projection,
        behavioral_model: Behavioral,
        presentation_layer: Presentation,
        constraints: Constraints,
        parent_ast_hash: AST.compilationHash
    },
    verify_persona_integrity(Persona, AST).

project_skills(Subgraph, Context, Overrides, Projection) :-
    findall(S, subgraph_skill(Subgraph, S), Skills),
    maplist(compute_amplitude(Context, Overrides), Skills, Amps),
    pairs_keys_values(Pairs, Amps, Skills),
    sort(1, @>=, Pairs, Sorted),
    pairs_values(Sorted, Ranked),
    partition_by_amplitude(Ranked, Amps, Primary, Supporting, Latent),
    Projection = skill_projection{primary: Primary, supporting: Supporting, latent: Latent}.

compute_amplitude(Context, Overrides, Skill, Amp) :-
    context_relevance(Skill, Context, R),
    verification_factor(Skill, VF),
    recency_factor(Skill, RF),
    evidence_factor(Skill, EF),
    override_factor(Skill, Overrides, OF),
    Amp is min(0.95, max(0.0, R * VF * RF * EF * OF)).

verification_factor(S, 1.0)  :- skill_verification(S, machine_checked).
verification_factor(S, 0.95) :- skill_verification(S, human_verified).
verification_factor(S, 0.3)  :- skill_verification(S, unverified).
verification_factor(S, 0.0)  :- skill_verification(S, contradicted).

collapse_superposition(State, explicit_context_switch(Ctx), PID) :-
    State = superposition_state{active_personas: Active},
    select_persona_for_context(Active, Ctx, PID).
collapse_superposition(State, entropy_threshold_breach, PID) :-
    State = superposition_state{active_personas: Active},
    max_amplitude_persona(Active, PID).
collapse_superposition(State, _, PID) :-
    State = superposition_state{active_personas: Active, coherence_threshold: T},
    max_coherence_persona(Active, T, PID).

verify_persona_integrity(Persona, AST) :-
    forall(persona_skill(Persona, Name, Prof, Verif),
           (ast_skill(AST, Name, Prof, Verif), Verif \= contradicted)),
    persona_entropy(Persona, E), E =< 0.20.

context_relevance(Skill, technical_interview(Domain, Seniority), R) :-
    skill_domain(Skill, Domain), skill_proficiency(Skill, Prof),
    seniority_match(Seniority, Prof, M), R is 0.8 * M.
context_relevance(Skill, behavioral_interview(_), 0.9) :- skill_category(Skill, leadership).
context_relevance(Skill, behavioral_interview(_), 0.8) :- skill_category(Skill, communication).
context_relevance(Skill, reentry_resume, 0.9) :- transferable_skill(Skill).
context_relevance(Skill, reentry_resume, 0.7) :- gap_adjacent_skill(Skill).
