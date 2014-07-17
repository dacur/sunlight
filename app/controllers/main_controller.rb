class MainController < ApplicationController

	require 'json'
	require 'open-uri'

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

	def money
		@first = params[:first_name]
		@last = params[:last_name]
		@politician = JSON.load(open("http://transparencydata.org/api/1.0/entities.json?apikey=7b60678075d742c5848887153c965088&search=#{@first}+#{@last}&type=politician"))
			if @politician.empty?
				@politician = "Enter a politician's name."
			else
				@year = params[:year]
				@pol_id = @politician[0]["id"]
				@breakdown = JSON.load(open("http://transparencydata.com/api/1.0/aggregates/pol/#{@pol_id}/contributors/type_breakdown.json?cycle=#{@year}&apikey=7b60678075d742c5848887153c965088"))
			    	if (@breakdown["Individuals"]).nil? 
			    		@individuals_money = 0
			    		@individuals = 0
			    	else 
			    		@individuals_money = (@breakdown["Individuals"][1]).to_f 
			    		@individuals = @breakdown["Individuals"][0]
			    	end
			    	if (@breakdown["PACs"]).nil?
			    		@pacs_money = 0
			    		@pacs = 0
			    	else
			    		@pacs_money = (@breakdown["PACs"][1]).to_f
			    		@pacs = @breakdown["PACs"][0]
			    	end
		    	#@pacs = "$" + @breakdown["PACs"][1] + " from " + @breakdown["PACs"][0] + " PACs"
		    	#@total_money = (@breakdown["Individuals"][1]).to_f  + (@breakdown["PACs"][1]).to_f
		    	@total_money = @individuals_money + @pacs_money
		    	@local_breakdown = JSON.load(open("http://transparencydata.com/api/1.0/aggregates/pol/#{@pol_id}/contributors/local_breakdown.json?cycle=#{@year}&apikey=7b60678075d742c5848887153c965088"))
		    		@instate = (@local_breakdown["In-State"][1]).to_f
		    		@out_of_state = (@local_breakdown["Out-of-State"][1]).to_f
		    	@top_contributors = JSON.load(open("http://transparencydata.com/api/1.0/aggregates/pol/#{@pol_id}/contributors.json?cycle=#{@year}&limit=10&apikey=7b60678075d742c5848887153c965088"))
	    	end

	end

	def stats
	
	    @top = JSON.load(open("http://transparencydata.com/api/1.0/aggregates/pols/top_10000.json?cycle=2012&apikey=7b60678075d742c5848887153c965088"))
		@total = 0
			i = 0
			for i in 0..9999
				@total += @top[i]["amount"].to_i
			end
	    
	    @top10total = 0
	    	x = 0
			for x in 0..9
				@top10total += @top[x]["amount"].to_i
			end

	end


	
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
