module AuthFeaturesHelper
  def sign_up_as(name, email)
    visit new_user_url
    fill_in "user[email]", with: email
    fill_in "user[name]", with: name
    fill_in "user[password]", with: "Password"
    click_button "Sign Up"
  end

  def sign_up_as_hello_world
    sign_up_as("hello_world", "hello@world.com")
  end

  def login_as(email, password)
    visit new_session_url
    fill_in "user[email]", with: email
    fill_in "user[password]", with: password
    click_button "Log In"
  end
  
  def login_as_hello_world
    login_as("hello@world.com", "Password")
  end
  
  def sign_up_as_demo
    visit new_user_url
    fill_in "user[email]", with: "demo@demo.com"
    fill_in "user[name]", with: "demo"
    fill_in "user[password]", with: "demodemo"
    click_button "Sign Up"
  end
  
  def login_as_demo
    visit new_session_url
    click_button "Log In with a Demo Account"
  end
end