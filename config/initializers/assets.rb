# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )

#Precompiled applications CSS and JS

Rails.application.config.assets.precompile += %w( bootstrap.css )
Rails.application.config.assets.precompile += %w( bootstrap.min.css )
Rails.application.config.assets.precompile += %w( bootstrap.js )
Rails.application.config.assets.precompile += %w( jquery-1.11.0.js)
Rails.application.config.assets.precompile += %w( masonry/jquery.masonry.js )
Rails.application.config.assets.precompile += %w( bootstrap.min.js )
Rails.application.config.assets.precompile += %w( jquery.easing.min.js )


#Precompiled CSS and JS for pages/home
Rails.application.config.assets.precompile += %w( owl.carousel.css )
Rails.application.config.assets.precompile += %w( owl.theme.css )
Rails.application.config.assets.precompile += %w( style.css )   
Rails.application.config.assets.precompile += %w( responsive.css )
Rails.application.config.assets.precompile += %w( sign-up.css ) 
Rails.application.config.assets.precompile += %w( log-in.css )
Rails.application.config.assets.precompile += %w( edit.css )
Rails.application.config.assets.precompile += %w( modernizr.custom.js )
Rails.application.config.assets.precompile += %w( jquery.1.11.1.js )
Rails.application.config.assets.precompile += %w( bootstrap.js )
Rails.application.config.assets.precompile += %w( SmoothScroll.js )
Rails.application.config.assets.precompile += %w( jquery.isotope.js )   
Rails.application.config.assets.precompile += %w( owl.carousel.js ) 
Rails.application.config.assets.precompile += %w( main.js )