module NoLogin
  refine ApplicationController do
    def authenticate_user!
    end
  end
end
