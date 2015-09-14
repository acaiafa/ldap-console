require 'spec_helper'

describe OpenLdap::App do
  def app
    OpenLdap::App
  end

  it "should land on /updateuser for a non privileged user" do
    get '/updateuser', {}, 'rack.session' => { :email => 'anthony@example.com'}
    last_response.should be_ok
  end

  it "should redirect if a non priveleged user tries to access add user" do
    get '/user', {}, 'rack.session' => { :email => 'anthony@example.com'}
    last_response.should be_redirect
  end

end
