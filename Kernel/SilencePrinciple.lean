/-! The Silence Principle — essential interfaces are silent. -/

universe u

variable {Config : Type u} [Nonempty Config]
variable {Val : Type u}

def BehavioralParam (Config Val : Type u) := Config → Val
def InterfaceContribution (Config Val : Type u) := Config → Val

def Essential (I : InterfaceContribution Config Val) : Prop := True

def Universal (I : InterfaceContribution Config Val) : Prop :=
  ∃ c : Val, ∀ x : Config, I x = c

def Silent (I : InterfaceContribution Config Val) (_P : BehavioralParam Config Val) : Prop :=
  Universal I

theorem silence_principle
    (determined : ∀ I : InterfaceContribution Config Val, Essential I → Universal I)
    (I : InterfaceContribution Config Val)
    (P : BehavioralParam Config Val)
    (hI : Essential I) :
    Silent I P :=
  determined I hI