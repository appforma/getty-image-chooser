(function( $ ){

  $.fn.getty_image_selector = function( options ) {  

	  // Create some defaults, extending them with any options that were provided
    var settings = $.extend( {
      'location'         : 'top',
      'background-color' : 'black',
			'url' : '/search_getty_images',
			'form-element-id' : '#image'
    }, options);
		//initialize the the popup container
		$(document.body).append('<div id="pop-up"></div>');
		//initialize the popup launcher
		$(this).click(function() {
			$('div#pop-up').show();
			$('.bg_trans').show();
		});	
		$(document.body).append('<div class="bg_trans"></div>');
		$('#pop-up').append('<a href="#" class="close_getty">X</a>');
		$('#pop-up').append('<h3><i>Enter a search term and click submit</i></h3>');
		//initialize the search form
		$('#pop-up').append('<input type="text" id="getty-search-text"/>');
		$('#pop-up').append('<input type="submit" value="submit" id="getty-search-submit"/>');
		//initialize the results panel
		$('#pop-up').append('<div id="getty-image-results"></div>');
		var parent = this;
		
		//callback for closing the popup
		$("#pop-up a.close_getty").click(function() {
			$('div#pop-up').hide();
			$('.bg_trans').hide();
		});
		
		//add a call back on the submit button
		$('#getty-search-submit').click(function(){
			$.ajax({
	      url: settings['url'] + '/' + $('#getty-search-text').val(),
	      crossDomain: true,
	      success: function(data) {
					//clear the existing data from the results panel
					$('#getty-image-results').empty();
	        //get back a json array of images from the Getty search.
	        for (var i = 0; i < data.length; i++){ 
	        	//for each image, add a listener on it
						$('#getty-image-results').append('<div id="getty-image-' + i + '" class="getty-image-holder"></div>');
						$('#getty-image-' + i + '').append('<a href="#getty-image-link' + i + '"><img src="' + data[i]['UrlThumb'] + '"/></a>');
	        }

	      },
	      dataType: "json"
	    });
		});
		
			
  };
})( jQuery );
