# Feature: Sign out
#   As a user
#   I want to sign out
#   So I can protect my account from unauthorized access
feature 'Sign out', :omniauth do

  # Scenario: User signs out successfully
  #   Given I am signed in
  #   When I sign out
  #   Then I see a signed out message
  scenario 'user signs out successfully' do
    signin
    click_link 'Sign out'
    expect(page).to have_content 'Signed out'
  end

  scenario 'user signs out successfully', :focus, js: true do
    signin
    find('#user-menu-dropdown').click
    sleep 1
    ap all("ul.dropdown-menu > li")
    click_link 'Sign out'
    expect(page).to have_content 'Signed out'
  end

  it 'should test it with js:true!'
    # all("ul.dropdown-menu > li")
    # expect(page).to have_link('Sign out', visible: false)
    # page.find('#signout').click
    # find('#user-menu-dropdown').click
    # signin
    # click_link 'Sign out'
end