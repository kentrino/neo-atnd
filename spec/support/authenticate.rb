def login!(user)
  ApplicationController.any_instance.stub(:current_user).and_return(user)
  ApplicationController.any_instance.stub(:logged_in?).and_return(true)
end

def logout
  ApplicationController.any_instance.stub(:current_user).and_return(nil)
  ApplicationController.any_instance.stub(:logged_in?).and_return(false)
end
