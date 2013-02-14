class User < ActiveRecord::Base
  attr_accessible :email, :name, :password, :password_confirmation
  validates :name,  :presence => true
  validates :email, :presence => true, :uniqueness => true, :format => { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :on => :create }
  acts_as_authentic do |c|
  	c.login_field = :email          # email is the login field
    c.validate_login_field = false
  end

  def deliver_password_reset_instructions!
    reset_perishable_token!
    Notifier.password_reset_instructions(self).deliver
  end
  def deliver_verification_instructions!
    reset_perishable_token!
    Notifier.verification_instructions(self).deliver
  end
  def verify!
      self.verified = true
      self.save
  end
  
end
