class Ability
  include CanCan::Ability

  def initialize(user)
    can :index, Book
    if user
      if user.role? :admin
        can [:create,:update], Book
      elsif user.role? :god
        can :manage, :all
      end 
    end
  end
end
