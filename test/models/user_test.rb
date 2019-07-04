require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "01 user valid check" do
    user = User.new(
          name: "tane5",
          email: "tane5@tane.com",
          password: "12345678",
          password_confirmation: "12345678" 
          )
    assert user.valid?
  end

  test "02 invalid without a name " do
    user = User.new(
          email: "tane5@tane.com",
          password: "12345678",
          password_confirmation: "12345678" 
          )
    refute user.valid?
    assert_not_nil user.errors[:name]
  end

  test "03 invalid without an email" do
    user = User.new(
          name: "tane5",
          
          password: "12345678",
          password_confirmation: "12345678" 
          )
    refute user.valid?
    assert_not_nil user.errors[:email]
  end

  test "04 invalid without a password" do
    user = User.new(
          name: "tane5",
          email: "tane5@tane.com",
          password: "",
          password_confirmation: "12345678" 
          )
    refute user.valid?
    assert_not_nil user.errors[:password]
  end

  test "05 invalid without a password_confirmation" do
    user = User.new(
          name: "tane5",
          email: "tane5@tane.com",
          password: "12345678",
          password_confirmation: "" 
          )
    refute user.valid?
    assert_not_nil user.errors[:password_confirmation]
  end

  test "06 valid with the same name and the same password" do
    user = User.new(
          name: "test_admin",
          email: "unittest@unit.test",
          password: "secret",
          password_confirmation: "secret" 
          )
    assert user.valid?
  end

  test "07 invalid with an existing email" do
    user = User.new(
          name: "usertest7",
          email: "test1@example.com",
          password: "12345678",
          password_confirmation: "12345678" 
          )
    refute user.valid?
    assert_not_nil user.errors[:email]
  end

  test "08 check invalid formed email" do
    user = User.new(
          name: "tane5",
          email: "tane5.tane.com",
          password: "12345678",
          password_confirmation: "12345678" 
          )
    refute user.valid?
    assert_not_nil user.errors[:email]  
  end

  test "09 check invalid password less than 6" do
    user = User.new(
          name: "tane5",
          email: "tane5@tane.com",
          password: "12345",
          password_confirmation: "12345" 
         )
    refute user.valid?
    assert_not_nil user.errors[:password]  
  end

  test "10 check invalid password more than 20" do
    user = User.new(
          name: "tane5",
          email: "tane5@tane.com",
          password: "123456789012345678901",
          password_confirmation: "123456789012345678901" 
          )
    refute user.valid?
    # puts user.errors[:password]
    # puts user.errors[:password_confirmation]
    assert_not_nil user.errors[:password]  
  end
end
