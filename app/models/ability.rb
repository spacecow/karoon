class Ability
  include CanCan::Ability

  def initialize(user)
    can [:show,:index], Book
    can [:show,:index], Author
    can [:show,:index], Category
    can [:show,:create], Search
    can :create, LineItem
    can :destroy, Cart
    if user
      if user.role? :member
      elsif user.role? :admin
        can [:create,:update,:destroy,:create_individual], Book
        can [:create,:update,:destroy], Author
        can [:create,:update,:destroy], Category
        can [:update], Setting
        can :index, Search
        can :create, LineItem
      elsif user.role? :god
        can :manage, :all
      end 
    end
  end
end
