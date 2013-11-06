				
				function doForm(filetype) {
				var url=unescape('ViewAction?wrapper=false');
      			var target=unescape('theoutput');
      			var target1=unescape('theoutput1');
      			    var submitUrl = url;
      			    var form = document.forms['parameter-form'];
      			    var elements = form.elements;
      			    var i;
      			    for( i=0; i<elements.length; i++ ) {
      			      if( elements[i].type == 'select-one' || elements[i].type == 'text' || elements[i].type == 'hidden') {
      			        
                                var name=elements[ i ].name;
                                var value=elements[ i ].value;                                
                                
                                submitUrl += '&' + name + '=' + escape( value );
                                
      			      } else if( elements[i].type == 'radio' ) {
      			      	if( elements[i].checked ) {
      			          submitUrl += '&' + elements[ i ].name + '=' + escape( elements[ i ].value );
      			      	}
      			      } else if( elements[i].type == 'checkbox' ) {
      			      	if( elements[i].checked ) {
      				      submitUrl += '&' + elements[i].name + "=" + escape( elements[i].value );
      			      	}
      			      } else if( elements[i].type == 'select-multiple' ) {
      				    var options = elements[i].options;
      				    var j;
      				    for( j=0; j!=options.length; j++ ) {
      				      if( options[j].selected ) {
      	  			        submitUrl += '&' + elements[i].name + '=' + escape( options[ j ].value );
      				      }
      				    }
      				  }
      			    }
					submitUrl += '&' + 'output' + '=' + filetype;
					//alert(submitUrl);
					
      			    if( target == '' ) {
      				    document.location.href=submitUrl;

      				} else { 
      					window.open( submitUrl, target );
      					             
      				}
      			    return false;
      			  }
				  
				  function setDefaultValueOfList(domId,index) {
      			  	var obj = document.getElementById(domId);
      			  	obj.selectedIndex = index;
      			  }
				  
				  function doChartToTarget(chartTarget,singleMode,chartWidth,chartHeight) {
						var url=unescape('ViewAction?wrapper=false');
		      			var target=unescape(chartTarget);		      			
		      			    var submitUrl = url;
		      			    var form = document.forms['parameter-form'];
		      			    var elements = form.elements;
		      			    var i;
		      			    for( i=0; i<elements.length; i++ ) {
		      			      if( elements[i].type == 'select-one' || elements[i].type == 'text' || elements[i].type == 'hidden') {
		      			        
		                                var name=elements[ i ].name;
		                                var value=elements[ i ].value;                                
		                                
		                                submitUrl += '&' + name + '=' + escape( value );
		                                
		      			      } else if( elements[i].type == 'radio' ) {
		      			      	if( elements[i].checked ) {
		      			          submitUrl += '&' + elements[ i ].name + '=' + escape( elements[ i ].value );
		      			      	}
		      			      } else if( elements[i].type == 'checkbox' ) {
		      			      	if( elements[i].checked ) {
		      				      submitUrl += '&' + elements[i].name + "=" + escape( elements[i].value );
		      			      	}
		      			      } else if( elements[i].type == 'select-multiple' ) {
		      				    var options = elements[i].options;
		      				    var j;
		      				    for( j=0; j!=options.length; j++ ) {
		      				      if( options[j].selected ) {
		      	  			        submitUrl += '&' + elements[i].name + '=' + escape( options[ j ].value );
		      				      }
		      				    }
		      				  }
		      			    }
							submitUrl += '&chartSingleMode='+singleMode + '&chartWidth=' + chartWidth+'&chartHeight='+chartHeight;
//							alert(submitUrl);
							
		      			    if( target == '' ) {
		      				    document.location.href=submitUrl;

		      				} else { 
		      					window.open( submitUrl, target );
		      					             
		      				}
		      			    return false;
		      			  }