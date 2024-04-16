class User
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
  include Devise::JWT::RevocationStrategies::JTIMatcher

  def self.primary_key
    '_id'
  end

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  field :email,              type: String, default: ""
  field :encrypted_password, type: String, default: ""

  field :reset_password_token,   type: String
  field :reset_password_sent_at, type: Time

  field :remember_created_at, type: Time
  include Mongoid::Timestamps

  field :name, type: String
  field :jti, type: String
  index({ jti: 1 }, { unique: true, name: "jti_index" })

  def update_column(attribute, value)
    send("#{attribute}=", value)
    save(validate: false)
  end

  def self.find_for_jwt_authentication(sub)
    find(sub)
  end
end
