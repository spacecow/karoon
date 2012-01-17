class Ability
  include CanCan::Ability

  def initialize(user)
    can [:show,:index], Book
    can [:show,:index], Author
    can [:show,:index], Category
    can [:show,:create], Search
    if user
      if user.role? :admin
        can [:create,:update,:destroy,:create_individual], Book
        can [:create,:update,:destroy], Author
        can [:create,:update,:destroy], Category
        can [:update], Setting
      elsif user.role? :god
        can :manage, :all
      end 
    end
  end
end
