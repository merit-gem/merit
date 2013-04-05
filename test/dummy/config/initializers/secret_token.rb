# Be sure to restart your server when you modify this file.

# Your secret key for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.

if Rails.version < '4'
  Dummy::Application.config.secret_token = 'f00fe8e4404331c84a9f1d877217c57399e0429ed948843f5d0b5db642cb2ab2c1dc28a17ef7daeecf64b1a4f2b61f7ae4886ab993fb0d7cf65d7b64ba5fbcb1'
else
  Dummy::Application.config.secret_key_base = 'f00fe8e4404331c84a9f1d877217c57399e0429ed948843f5d0b5db642cb2ab2c1dc28a17ef7daeecf64b1a4f2b61f7ae4886ab993fb0d7cf65d7b64ba5fbcb1'
end
