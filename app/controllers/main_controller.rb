class MainController < ApplicationController

	# rescue_from Exception, :with => :crap

	# def crap
	# 	flash[:error] = "Please enter a valid address."
	# 	render 'main/search_address'
	# end

	def index

	end

	def search
		@zipcode = params[:zipcode]
		@members_of_congress = Sunlight::Legislator.all_in_zipcode(@zipcode)

		if params[:address].present?
			@address = params[:address]
			@lat_long = Geocoder.coordinates(@address)
			@lat = @lat_long[0]
			@long = @lat_long[1]
			@congresspeople = Sunlight::Legislator.all_for(:latitude => @lat, :longitude => @long)
			
		else
			flash[:error] = "Please enter a valid address"
			
		end
		@district = Sunlight::District.get(:latitude => @lat, :longitude => @long)
		#head :ok
	end

	# def search
	# 	@zipcode = params[:zipcode]
	# 	@members_of_congress = Sunlight::Legislator.all_in_zipcode(@zipcode)
	# end

	# def search_address
	# 	if params[:address].present?
	# 		@address = params[:address]
	# 		@lat_long = Geocoder.coordinates(@address)
	# 		@lat = @lat_long[0]
	# 		@long = @lat_long[1]
	# 		@congresspeople = Sunlight::Legislator.all_for(:latitude => @lat, :longitude => @long)
			
	# 	else
	# 		flash[:error] = "Please enter a valid address"
			
	# 	end
	# 	#head :ok
	# end


		#@address = params[:address]
		#@congresspeople = Sunlight::Legislator.all_for(:address => "123 Fifth Ave New York, NY 10003")
		# @senior_senator = @congresspeople[:senior_senator]

	

	# def search_address
 #     begin
 #      if params[:latitude].present? && params[:longitude].present?
 #        @legislators = Sunlight::Legislator.all_for :latitude => params[:latitude], :longitude => params[:longitude]
 #      elsif params[:address].present?
 #        @legislators = Sunlight::Legislator.all_for :address => params[:address]
 #      else
 #        flash.now[:error] = "Please fill in your address."
 #        #render 'index'
 #      end
 #     rescue NoMethodError
 #        flash.now[:error] = "Please enter a valid address."
 #        #render 'index'
 #     end
 #    end




end
