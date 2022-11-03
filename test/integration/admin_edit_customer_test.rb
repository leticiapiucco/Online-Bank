require 'test_helper'

class AdminEditCustomerTest < ActionDispatch::IntegrationTest
  def setup
    load "#{Rails.root}/db/seeds.rb"
  end
  test "admin edit a customer" do
    post admin_login_url, params: { session: {email: "admin1@gmail.com",
       password: '12345678'}}
    assert is_admin_logged_in?
    get '/customers/20000/edit'
    assert_template 'customers/edit'
    put '/customers/20000', params: {customer:  {customerNumber: 41228637263,
      forename: "amy", surname: 'smith', email: 'mary@gmail.com',
      phone: "44123451234", dob: "10/11/1996", password: "12345678",
      password_confirmation: '12345678'}}
    assert_redirected_to customers_path
    assert Customer.find_by(id:20000).forename == "amy"
  end

  test "admin cannot do invalid edit of a customer" do
    post admin_login_url, params: { session: {email: "admin1@gmail.com",
       password: '12345678'}}
    assert is_admin_logged_in?
    get '/customers/20000/edit'
    assert_template 'customers/edit'
    put '/customers/20000', params: {customer:  {customerNumber: 41228637263,
      forename: "", surname: 'smith', email: 'mary@gmail.com',
      phone: "44123451234", dob: "10/11/1996", password: "12345678",
      password_confirmation: '12345678'}}
    assert_response :success
    assert_template 'customers/edit'
  end

end
