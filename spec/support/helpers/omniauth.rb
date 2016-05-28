module Omniauth

  module Mock
    def auth_mock
      OmniAuth.config.mock_auth[:facebook] = {
        "credentials" => {
          "expires"      => true,
          "expires_at"   => 1469592721,
          "token"        => "mock_token"
        },
        "extra" => {
          "raw_info" => {
            "email"      => "devonzuegel@gmail.com",
            "id"         => "10153644150393443",
            "name"       => "Devon Marisa Zuegel"
          }
        },
        "info" => {
          "email"        => "devonzuegel@gmail.com",
          "image"        => "http://graph.facebook.com/10153644150393443/picture",
          "name"         => "Devon Marisa Zuegel"
        },
        "provider" => "facebook",
        "uid"      => "10153644150393443"
      }

      OmniAuth.config.mock_auth[:twitter] = {
        'provider' => 'twitter',
        'uid'      => '123545',
        'info'     => {
          'name' => 'mockuser'
        },
        'credentials' => {
          'token'  => 'mock_token',
          'secret' => 'mock_secret'
        }
      }
    end
  end

  module SessionHelpers
    def signin
      visit root_path
      expect(page).to have_content("Sign in")
      auth_mock
      click_link "Sign in"
    end
  end

end
