class Ability
  include CanCan::Ability

  def initialize(user)
    can [:show,:index], Book
    can [:show,:index], Author
    if user
      if user.role? :admin
        can [:create,:update,:destroy], Book
        can [:create,:update,:destroy], Author
      elsif user.role? :god
        can :manage, :all
      end 
    end
  end
end
