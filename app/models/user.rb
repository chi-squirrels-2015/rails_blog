class User < ActiveRecord::Base
  has_many :posts

  validates :email, presence: true
  validates :email, uniqueness: true
  validates :password, presence: true

  validate :valid_email_address

  def valid_email_address
      unless /\w+@\w+.\w{2,}/.match(self.email)
        errors.add :email, "#{self.email} is not a valid email address."
        return
      end
  end

  def password
    @password ||= BCrypt::Password.new(password_hash)
  end

  def password=(new_password)
    @password = BCrypt::Password.create(new_password)
    self.password_hash = @password
  end

  def self.authenticate(email, password)
    user = Student.find_by_email(email)
    return user if user && (user.password == password)
    nil # either invalid email or wrong password
  end
end
