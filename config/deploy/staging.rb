# server-based syntax
# ======================
# Defines a single server with a list of roles and multiple properties.
# You can define all roles on a single server, or split them:

# server "example.com", user: "deploy", roles: %w{app db web}, my_property: :my_value
# server "example.com", user: "deploy", roles: %w{app web}, other_property: :other_value
# server "db.example.com", user: "deploy", roles: %w{db}



# role-based syntax
# ==================

# Defines a role with one or multiple servers. The primary server in each
# group is considered to be the first unless any hosts have the primary
# property set. Specify the username and a domain or IP for the server.
# Don't use `:all`, it's a meta role.

#role :app, %w{ubuntu@ec2-18-234-216-166.compute-1.amazonaws.com}
#role :web, %w{ubuntu@ec2-18-234-216-166.compute-1.amazonaws.com}
#role :db,  %w{ubuntu@ec2-18-234-216-166.compute-1.amazonaws.com}

#set :user, "ubuntu"
#server "ec2-3-85-25-189.compute-1.amazonaws.com", roles: [:app, :web, :db]
# set :master_key_local_path, "/home/lucas/Documents/Memoria/new-team-maker/config/master.key"


# Configuration
# =============
# You can set any configuration variable like in config/deploy.rb
# These variables are then only loaded and set in this stage.
# For available Capistrano configuration variables see the documentation page.
# http://capistranorb.com/documentation/getting-started/configuration/
# Feel free to add new variables to customise your setup.



# Custom SSH Options
# ==================
# You may pass any option but keep in mind that net/ssh understands a
# limited set of options, consult the Net::SSH documentation.
# http://net-ssh.github.io/net-ssh/classes/Net/SSH.html#method-c-start
#
# Global options
# --------------
#set :ssh_options, {
#  keys: %w(/home/lucas/.aws/MyVM.pem),
#  forward_agent: true,
#  user: 'ubuntu'
#}
#
# The server-based syntax can be used to override options:
# ------------------------------------
set :rvm_ruby_version, '3.1.1'
set :rvm_custom_path,'/usr/share/rvm'
server "huelen.diinf.usach.cl",
   user: "imoreira",
   roles: %w{web app db},
   ssh_options: {
     user: "imoreira", # overrides user setting above
     keys: %w(/home/nahuel/.ssh/id_rsa),
     forward_agent: false,
     auth_methods: %w(publickey password)
     # password: "please use keys"
   }
