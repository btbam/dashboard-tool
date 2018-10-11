class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:upgrade]

  def upgrade
    render template: 'pages/upgrade'
  end
end
