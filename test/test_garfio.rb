require File.expand_path("../lib/garfio", File.dirname(__FILE__))

class User
  extend Garfio

  def initialize
    @@sum = 0
  end

  def send_greeting
    @@sum += 1
  end

  def register_user(n = 2)
    @@sum += n
  end

  def send_mail
    @@sum += 3
  end

  def some_method(n = 4)
    @@sum += n
  end

  def some_other_method(n = 5)
    @@sum += n
  end

  def get_sum
    @@sum
  end
end

scope do
  test "hook before" do
    u = Class.new(User) do
        set_hook :register_user do
          before :send_greeting
        end
      end
    u_instance = u.new
    u_instance.register_user

    assert_equal 3, u_instance.get_sum
  end

  test "hook after" do
    u = Class.new(User) do
        set_hook :register_user do
          after :send_mail
        end
      end
    u_instance = u.new
    u_instance.register_user

    assert_equal 5, u_instance.get_sum
  end

  test "hook before and after" do
    u = Class.new(User) do
        set_hook :register_user do
          before :send_greeting
          after :send_mail
        end
      end
    u_instance = u.new
    u_instance.register_user

    assert_equal 6, u_instance.get_sum
  end

  test "respecting the sending variable" do
    u = Class.new(User) do
        set_hook :register_user do
          before :send_greeting
          after :send_mail
        end
      end
    u_instance = u.new
    u_instance.register_user(10)

    assert_equal 14, u_instance.get_sum
  end

  test "sending a block in before" do
    u = Class.new(User) do
        set_hook :register_user do
          before { some_method }
        end
      end
    u_instance = u.new
    u_instance.register_user

    assert_equal 6, u_instance.get_sum
  end

  test "sending a complex block in before" do
    u = Class.new(User) do
        set_hook :register_user do
          before do
            some_method 5
            some_other_method 8
          end
        end
      end
    u_instance = u.new
    u_instance.register_user

    assert_equal 15, u_instance.get_sum
  end

  test "sending a block in after" do
    u = Class.new(User) do
        set_hook :register_user do
          after { some_method }
        end
      end
    u_instance = u.new
    u_instance.register_user

    assert_equal 6, u_instance.get_sum
  end

  test "sending a complex block in after" do
    u = Class.new(User) do
        set_hook :register_user do
          after do
            some_method 5
            some_other_method 8
          end
        end
      end
    u_instance = u.new
    u_instance.register_user

    assert_equal 15, u_instance.get_sum
  end

  test "hook method return a value" do
    u = Class.new(User) do
        set_hook :register_user do
          after do
            some_method 5
            some_other_method 8
          end
        end
      end
    u_instance = u.new
    assert_equal 2, u_instance.register_user
  end
end