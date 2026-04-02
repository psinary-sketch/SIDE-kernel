namespace techne_kernel
universe u

structure MechanismClass (X : Type u) (P : X -> Prop) where
  name : String
  produces : X -> Prop

structure HasSymmetry (X : Type u) where
  T : X -> X
  T_involution : forall x : X, T (T x) = x

structure Constraint (X : Type u) where
  name : String
  source : String
  machinery : String

structure IndependentConstraints (X : Type u) where
  constraints : List (Constraint X)
  has_two : constraints.length >= 2

structure ExhaustiveCatalogue (X : Type u) (P : X -> Prop) where
  classes : List (MechanismClass X P)
  covers_all : forall (x : X), P x ->
    Exists (fun C : MechanismClass X P => And (List.Mem C classes) (C.produces x))

def NoneProduces (X : Type u) (P : X -> Prop)
    (classes : List (MechanismClass X P)) (x : X) : Prop :=
  forall C : MechanismClass X P, List.Mem C classes -> Not (C.produces x)

theorem SIDE_exclusion
    {X : Type u} {P : X -> Prop} {x : X}
    (cat : ExhaustiveCatalogue X P)
    (h_none : NoneProduces X P cat.classes x) :
    Not (P x) := by
  intro h_Px
  have h := cat.covers_all x h_Px
  match h with
  | ⟨C, h_in, h_produces⟩ => exact h_none C h_in h_produces

structure KernelCertificate
    (X : Type u) (P : X -> Prop) (x : X) where
  symmetry : HasSymmetry X
  independence : IndependentConstraints X
  catalogue : ExhaustiveCatalogue X P
  no_mechanism : NoneProduces X P catalogue.classes x
  conclusion : Not (P x) :=
    SIDE_exclusion catalogue no_mechanism

example : KernelCertificate Nat (fun n => n > 100 /\ n < 50) 42 :=
  { symmetry := {
      T := fun n => n
      T_involution := fun n => rfl }
    independence := {
      constraints := [
        { name := "c1", source := "s1", machinery := "m1" },
        { name := "c2", source := "s2", machinery := "m2" } ]
      has_two := by decide }
    catalogue := {
      classes := []
      covers_all := by
        intro x h
        exact absurd h.2 (by omega) }
    no_mechanism := by
      intro C h_in
      nomatch h_in }

end techne_kernel
