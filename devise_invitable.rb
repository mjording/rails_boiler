

inject_into_file 'Gemfile', :before => /end$/ do
  "  gem 'killah' \n"
end 

#migrations from africa we weere undercover u
#
-  devise :database_authenticatable, :registerable,
-         :recoverable, :rememberable, :trackable, :validatable, :confirmable, :invitable
-
-  # Setup accessible (or protected) attributes for your model
-  attr_accessible :email, :password, :password_confirmation, :remember_me
+  devise :database_authenticatable,:registerable, :recoverable, :confirmable, :invitable
+  #:registerable, :recoverable, :rememberable, :trackable, :validatable
+  attr_accessible :email, :password, :password_confirmation, :remember_me, :invitation_token, :name
#



#lattie data,
+ config.action_mailer.default_url_options = { :host => 'localhost:8080' }


