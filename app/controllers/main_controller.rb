class MainController < ApplicationController

def index
	@zipcode = params[:zipcode]
	@members_of_congress = Sunlight::Legislator.all_in_zipcode(@zipcode)
end

def search
	@zipcode = params[:zipcode]
	@members_of_congress = Sunlight::Legislator.all_in_zipcode(@zipcode)

end







end
