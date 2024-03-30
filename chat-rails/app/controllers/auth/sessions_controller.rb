class Auth::SessionsController < DeviseTokenAuth::SessionsController

    private

        def resource_params
            params.require(:session).permit(:name, :email, :password, :password_confirmation)
        end
end
