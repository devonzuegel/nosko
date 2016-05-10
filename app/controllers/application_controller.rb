class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception
  helper_method *%i(current_user user_signed_in? correct_user?)

  private
    def current_user
      begin
        @current_user ||= User.find(session[:user_id]) if session[:user_id]
      rescue Exception => e
        nil
      end
    end

    def user_signed_in?
      !current_user.nil?
    end

    def correct_user?
      @user = User.find(params[:id])
      unless current_user == @user
        redirect_to root_url, alert: "Access denied."
      end
    end

    def authenticate_user!
      if !current_user
        redirect_to root_url, alert: 'You need to sign in for access to this page.'
      end
    end

    def flash_errors(obj)
      obj.errors.full_messages.join("\n")
    end

    def render_404
      render file: "#{Rails.root}/public/404.html", status: 404
    end
end
