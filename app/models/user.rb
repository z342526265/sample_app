# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  email      :string(255)
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class User < ActiveRecord::Base
  attr_accessible :email, :name,:password,:password_confirmation
  
  #加入密码验证机制
  has_secure_password

  #attr_accessor :password,:password_confirmation

  validates :name,:email,presence: true
  validates :name,length: {maximum: 30}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email,format: {with: VALID_EMAIL_REGEX},uniqueness:{case_sensitive:false}
  validates :password,presence:true,length:{minimum: 6}
  validates :password_confirmation,presence:true




  before_save do |user|
    #保存前全部转换成小写字母
    user.email.downcase!
  end

    #创建记忆权标
  before_save :create_remember_token

private
    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
end
