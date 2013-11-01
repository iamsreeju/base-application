class User < ActiveRecord::Base
	rolify
	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable and :omniauthable
  	devise :invitable, :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:facebook, :google_oauth2, :twitter]

  	# attr_accessible :provider, :uid, :name, :email, :password

 	def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
		user = User.where(:provider => auth.provider, :uid => auth.uid).first
		unless user
			user = User.new(name:auth.extra.raw_info.name,
			    provider:auth.provider, uid:auth.uid, email:auth.info.email, 
			    password:Devise.friendly_token[0,20])
			user.save(validate: false)
		end
		user
	end

	def self.find_for_google_oauth2(access_token, signed_in_resource=nil)
		data = access_token.info
		user = User.where(:email => data["email"]).first

		unless user
		    user = User.new(name: data["name"], email: data["email"],
		         password: Devise.friendly_token[0,20]
		        )
		    user.save(validate: false)
		end
	    user
	end

	def self.find_for_twitter(auth, signed_in_resource=nil)
		user = User.where(:provider => auth.provider, :uid => auth.uid).first
		unless user
			user = User.new(name:auth.info.name, provider:auth.provider, 
				uid:auth.uid, password:Devise.friendly_token[0,20])
			user.save(validate: false)
		end
	    user
	end
	
end
