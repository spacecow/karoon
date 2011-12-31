class Ability
  include CanCan::Ability

  def initialize(user)
    can :index, Book
    if user
      if user.role? :admin
        can :create, Book
      end
    end
  end
end
