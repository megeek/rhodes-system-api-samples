require 'rho/rhocontroller'

class GeoLocationController < Rho::RhoController
  @layout = 'GeoLocation/layout'
  
  def index
    puts "GeoLocation index controller"
    set_geoview_notification( url_for(:action => :geo_viewcallback), "", 2)  if System::get_property('platform') == 'Blackberry'
    render :back => '/app'
  end
  
  def geo_viewcallback
    puts "geo_viewcallback : #{@params}"
    
    WebView.refresh if @params['known_position'].to_i != 0 && @params['status'] =='ok'
  end
  
  def show 
    render :action => :show
  end

  def showmap
     puts @params.inspect
     #pin color
     if @params['latitude'].to_i == 0 and @params['longitude'].to_i == 0
       @params['latitude'] = '37.349691'
       @params['longitude'] = '-121.983261'
     end
     
     region = [@params['latitude'], @params['longitude'], 0.2, 0.2]     
     #region = {:center => @params['latitude'] + ',' + @params['longitude'], :radius => 0.2}

     myannotations = []

     myannotations <<   {:street_address => "Cupertino, CA 95014", :title => "Cupertino", :subtitle => "zip: 95014", :url => "/app/GeoLocation/show?city=Cupertino"}

     myannotations << {:street_address => "Santa Clara, CA 95051", :title => "Santa Clara", :subtitle => "zip: 95051", :url => "/app/GeoLocation/show?city=Santa%20Clara"}

     #  add annotation with customized image :
     myannotations << {:latitude => '60.0270', :longitude => '30.299', :title => "Original Location", :subtitle => "orig test", :url => "/app/GeoLocation/show?city=Original Location"}	
     myannotations << {:latitude => '60.0270', :longitude => '30.33', :title => "Red Location", :subtitle => "red test", :url => "/app/GeoLocation/show?city=Red Location", :image => '/public/images/marker_red.png', :image_x_offset => 8, :image_y_offset => 32 }	
     myannotations << {:latitude => '60.0270', :longitude => '30.36', :title => "Green Location", :subtitle => "green test", :url => "/app/GeoLocation/show?city=Green Location", :image => '/public/images/marker_green.png', :image_x_offset => 8, :image_y_offset => 32 }	
     myannotations << {:latitude => '60.0270', :longitude => '30.39', :title => "Blue Location", :subtitle => "blue test", :url => "/app/GeoLocation/show?city=Blue Location", :image => '/public/images/marker_blue.png', :image_x_offset => 8, :image_y_offset => 32 }	

    map_params = {
          :provider => @params['provider'],
          :settings => {:map_type => "roadmap", :region => region,
                        :zoom_enabled => true, :scroll_enabled => true, :shows_user_location => true, :api_key => '0jDNua8T4Teq0RHDk6_C708_Iiv45ys9ZL6bEhw'},
          :annotations => myannotations
     }

     puts map_params.inspect            
     MapView.create map_params
     redirect :action => :index
  end


  def showmap_250
     puts @params.inspect
     #pin color
     if @params['latitude'].to_i == 0 and @params['longitude'].to_i == 0
       @params['latitude'] = '37.349691'
       @params['longitude'] = '-121.983261'
     end
     
     region = [@params['latitude'], @params['longitude'], 0.2, 0.2]     
     #region = {:center => @params['latitude'] + ',' + @params['longitude'], :radius => 0.2}

     myannotations = []
     250.times do |j|
          annotation = {:latitude => @params['latitude'], :longitude => @params['longitude'], :title => "Current location", :subtitle => "test", :url => "/app/GeoLocation/show?city=Current Location"}	
          myannotations << annotation
     end

     myannotations <<   {:street_address => "Cupertino, CA 95014", :title => "Cupertino", :subtitle => "zip: 95014", :url => "/app/GeoLocation/show?city=Cupertino"}
     myannotations << {:street_address => "Santa Clara, CA 95051", :title => "Santa Clara", :subtitle => "zip: 95051", :url => "/app/GeoLocation/show?city=Santa%20Clara"}

     map_params = {
          :provider => @params['provider'],
          :settings => {:map_type => "roadmap", :region => region,
                        :zoom_enabled => true, :scroll_enabled => true, :shows_user_location => true, :api_key => '0jDNua8T4Teq0RHDk6_C708_Iiv45ys9ZL6bEhw'},
          :annotations => myannotations
     }

     puts map_params.inspect            
     MapView.create map_params
     redirect :action => :index
  end



def showmap_coding
     puts @params.inspect
     #pin color
     region = {:center => 'NG10 3XL', :radius => 0.2}

    # Build up the parameters for the call
    map_params = {
        :provider => @params['provider'],
        # General settings for the map, type, viewable area, zoom, scrolling etc.
        # We center on the user, with 0.2 degrees view
        :settings => {:map_type => "roadmap",:region => region,
            :zoom_enabled => true,:scroll_enabled => true,:shows_user_location => false
        }#,
        # This annotation shows the user, give the marker a title, and a link directly to that user
        #:annotations => [{
        #    :title => "TEST",
        #    :subtitle => "TEST"
        #}]
    }

     puts map_params.inspect            
     MapView.create map_params
     redirect :action => :index
  end        
end
