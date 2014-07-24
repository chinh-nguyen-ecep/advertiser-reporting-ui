  <jsp:include page="../../ApiHeader.jsp" />
      	     <!-- Modal -->
	<div class="modal fade bs-example-modal-lg" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
	  <div class="modal-dialog" style="width: 750px;">
	    <div class="modal-content" >
	      <div class="modal-header">
	        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
	        <h4 class="modal-title" id="myModalLabel">API Request</h4>
	      </div>
	      <div class="modal-body" style="max-height: none;">
	        <form id="apiSubmitForm" role="form" >
		      <div class="form-group">
		        <label for="exampleInputUrl">URL</label>
		        <input type="text" name="exampleInputUrl" class="form-control" id="exampleInputUrl" >
		      </div>
		     <div class="form-group">
		        <label for="exampleInputEmail1">JSON Response</label>
		        <pre class="pre" ><code id="apiResult" ></code></pre>
		      </div>
		      <div class="form-group">
		        <label for="exampleInputEmail1">SQL Query</label>
		        <pre class="preQuery"><code id="sqlQuery" ></code></pre>
		      </div>
		    </form>
	      </div>
	      <div class="modal-footer">
	        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
	        <button id="sendRequestBt" type="button" class="btn btn-primary">Send request</button>
	      </div>
	    </div>
	  </div>
	</div>
      <div id="index_container" class='container' style="margin-top: 100px;">
         <div class='content'>
            <nav>
               <ul class='breadcrumb'>
                  <li>
                     <a href="../../api/v1/overview">API Overview</a>
                  </li>
                  <li class='active'>overview</li>
               </ul>
            </nav>
            <ul class='nav nav-tabs'>
               <li class='active'><a href="#usage" data-toggle="tab">Usage</a></li>
               <li><a href="#examples" data-toggle="tab">Examples</a></li>
               <li><a href="#dimensions" data-toggle="tab">Dimensions</a></li>
               <li><a href="#measures" data-toggle="tab">Measures</a></li>
               <li><a href="#constraints" data-toggle="tab">Constraints</a></li>
               <li style="display: none;"><a href="#lookups" data-toggle="tab">Lookups</a></li>
            </ul>
            <div class='tab-content'>
               <div class='tab-pane active' id='usage'>
                  <h2>REST API</h2>
                  <p>
                     A report request must be of the following form:
                  </p>
                  <pre id="apiUrl">GET http://api.vervemobile.com/v1/advertiser/6-overview-internal/data.<var>format</var>?<var>parameters</var></pre>
                  <h4>Placeholder <var>format</var> may be either:</h4>
                  <dl>
                     <dt><var>json</var></dt>
                     <dd>Returns the report JSON encoded</dd>
                     <dt><var>csv</var></dt>
                     <dd>Returns the report as CSV (UTF8 encoded)</dd>
                  </dl>
                  <h4>Parameters are optional key-value pairs. Accepted keys are:</h4>
                  <dl>
                     <dt>
                        <var>select</var>
                     </dt>
                     <dd>
                        Measures to display; Default: <var>ALL</var>
                     </dd>
                     <dt>
                        <var>by</var>
                     </dt>
                     <dd>
                        Dimensions to display; Default: <var>ALL</var>
                     </dd>
                     <dt>
                        <var>where</var>
                     </dt>
                     <dd>
                        Constraints to apply; Default: <var>ALL</var>
                     </dd>
                     <dt><var>order</var></dt>
                     <dd>
                        The attribute to order by; Default: <var>NONE</var>
                     </dd>
                     <dt><var>limit</var></dt>
                     <dd>
                        Limits to the result to <var>n</var> records; Default: <var>100</var>
                     </dd>
                     <dt><var>page</var></dt>
                     <dd>
                        Alternative to <var>offset</var>, for record pagination; Default: <var>1</var>
                     </dd>
                  </dl>
               </div>
               <div class='tab-pane' id='examples'>
                  <h2>Examples</h2>
                  <h4>Using <var>select</var></h4>
                  <pre id="selectExample"></pre>
                  <h4>Using <var>by</var></h4>
                  <pre id="byExample"></pre>
                  <h4>Using <var>where</var></h4>
                  <pre id="whereExample"></pre>
                  <h4>Using <var>order</var></h4>
                  <pre id="orderExample"></pre>
               </div>
               <div class='tab-pane' id='dimensions'>
                  <h2>Dimensions</h2>
                  <table class='table table-striped table-bordered'>
                     <thead>
                        <th class='buttons' colspan='3'></th>
                        <tr>
                           <th>Name</th>
                           <th>Description</th>
                           <th>Type</th>
                        </tr>
                     </thead>
                     <tbody id="dimensions-body">
                      
                     </tbody>
                  </table>
               </div>
               <div class='tab-pane' id='measures'>
                  <h2>Measures</h2>
                  <table class='table table-striped table-bordered'>
                     <thead>
                        <tr>
                           <th class='buttons' colspan='3'></th>
                        </tr>
                        <tr>
                           <th>Name</th>
                           <th>Description</th>
                           <th>Type</th>
                        </tr>
                     </thead>
                     <tbody id="measures-body">
                       
                     </tbody>
                  </table>
               </div>
               <div class='tab-pane' id='constraints'>
                  <h2>Constraints</h2>
                  <table class='table table-striped table-bordered'>
                     <thead>
                        <tr>
                           <th class='buttons' colspan='3'></th>
                        <tr>
                           <th>Parameter</th>
                           <th>Type</th>
                           <th>Example value</th>
                        </tr>
                        </tr>
                     </thead>
                     <tbody id="constrains-body">
                        <tr>
                           <td>
                              <var>channel_id.in</var>
                           </td>
                           <td>
                              <span class='label integer'>integer</span>
                           </td>
                           <td>
                              <code>2|3|5|10</code>
                           </td>
                        </tr>
                        <tr>
                           <td>
                              <var>created_at.between</var>
                           </td>
                           <td>
                              <span class='label date'>date</span>
                           </td>
                           <td>
                              <code>2013-07-23..2013-07-23</code>
                           </td>
                        </tr>
                        <tr>
                           <td>
                              <var>date.between</var>
                           </td>
                           <td>
                              <span class='label date'>date</span>
                           </td>
                           <td>
                              <code>2013-07-23..2013-07-23</code>
                           </td>
                        </tr>
                        <tr>
                           <td>
                              <var>flight_id.in</var>
                           </td>
                           <td>
                              <span class='label integer'>integer</span>
                           </td>
                           <td>
                              <code>1|2|8</code>
                           </td>
                        </tr>
                        <tr>
                           <td>
                              <var>flight_start_date.between</var>
                           </td>
                           <td>
                              <span class='label date'>date</span>
                           </td>
                           <td>
                              <code>2013-07-23..2013-07-23</code>
                           </td>
                        </tr>
                        <tr>
                           <td>
                              <var>network_id.in</var>
                           </td>
                           <td>
                              <span class='label integer'>integer</span>
                           </td>
                           <td>
                              <code>3|10</code>
                           </td>
                        </tr>
                        <tr>
                           <td>
                              <var>order_id.in</var>
                           </td>
                           <td>
                              <span class='label integer'>integer</span>
                           </td>
                           <td>
                              <code>2|8</code>
                           </td>
                        </tr>
                        <tr>
                           <td>
                              <var>organization_id.in</var>
                           </td>
                           <td>
                              <span class='label integer'>integer</span>
                           </td>
                           <td>
                              <code>3|7|8|9</code>
                           </td>
                        </tr>
                        <tr>
                           <td>
                              <var>publisher_id.in</var>
                           </td>
                           <td>
                              <span class='label integer'>integer</span>
                           </td>
                           <td>
                              <code>2|6|7|9</code>
                           </td>
                        </tr>
                     </tbody>
                  </table>
               </div>
               <div class='tab-pane' id='lookups'>
                  <h2>Lookups</h2>
                  <table class='table table-striped table-bordered'>
                     <thead>
                        <tr>
                           <th class='buttons' colspan='4'></th>
                        </tr>
                        <tr>
                           <th>Name</th>
                           <th>Endpoint</th>
                        </tr>
                     </thead>
                     <tbody>
                        <tr>
                           <td><a href="lookups?dim=publisher">adNetworks</a></td>
                           <td>
                              <var>lookups?dim=publisher</var>
                           </td>
                        </tr>
                     </tbody>
                  </table>
               </div>
            </div>
         </div>
      </div>
            <jsp:include page="/footer.jsp" />
            <script src="../../scripts/bootstrap-3.0.0/js/bootstrap.min.js"></script>
	  <script>
	  var apiRequest=null;
	  //this function paser param from url
		function gup( name ){
		  name = name.replace(/[\[]/,"\\\[").replace(/[\]]/,"\\\]");
		  var regexS = "[\\?&]"+name+"=([^&#]*)";
		  var regex = new RegExp( regexS );
		  var results = regex.exec( window.location.href );
		  if( results == null )
			return "";
		  else
			return results[1];
		}
		var api=gup("api");
		var apiInfoObject="";
		//this function process api infomation
		var processApiInfo=function(apiInfoObject){
			//process apiUrl
			$('#apiUrl').html(apiInfoObject.apiUrl+"?format=json");
			//Process selectExample
			var htmlContent="";
			var selectExampleArray=apiInfoObject.selectExample;
			for(var i=0;i<selectExampleArray.length;i++){
				if(i>0){
					htmlContent+="&#x000A;";
				}
				var url_source=selectExampleArray[i].split(' ')[1];
				var url='<a class="apiReviewExample" target="_blank" href="'+url_source+'">'+url_source+'</a>';
				selectExampleArray[i]=selectExampleArray[i].replace(url_source,url);
				htmlContent+=selectExampleArray[i];
			}
			$("#selectExample").html(htmlContent);
			//process by example
			var htmlContent="";
			var exampleArray=apiInfoObject.byExample;
			for(var i=0;i<exampleArray.length;i++){
				if(i>0){
					htmlContent+="&#x000A;";
				}
				var url_source=exampleArray[i].split(' ')[1];
				var url='<a class="apiReviewExample" target="_blank" href="'+url_source+'">'+url_source+'</a>';
				exampleArray[i]=exampleArray[i].replace(url_source,url);
				htmlContent+=exampleArray[i];
			}
			$("#byExample").html(htmlContent);	
			//process where example
			var htmlContent="";
			var exampleArray=apiInfoObject.whereExample;
			for(var i=0;i<exampleArray.length;i++){
				if(i>0){
					htmlContent+="&#x000A;";
				}
				var url_source=exampleArray[i].split(' ')[1];
				var url='<a class="apiReviewExample" target="_blank" href="'+url_source+'">'+url_source+'</a>';
				exampleArray[i]=exampleArray[i].replace(url_source,url);
				htmlContent+=exampleArray[i];
			}
			$("#whereExample").html(htmlContent);
			//process where example
			var htmlContent="";
			var exampleArray=apiInfoObject.orderExample;
			for(var i=0;i<exampleArray.length;i++){
				if(i>0){
					htmlContent+="&#x000A;";
				}
				var url_source=exampleArray[i].split(' ')[1];
				var url='<a class="apiReviewExample" target="_blank" href="'+url_source+'">'+url_source+'</a>';
				exampleArray[i]=exampleArray[i].replace(url_source,url);
				htmlContent+=exampleArray[i];
			}
			$("#orderExample").html(htmlContent);	

			//process dimensions
			var dimensionsArray=apiInfoObject.dimensions;
			var htmlContent="";
			
			for(var i=0;i<dimensionsArray.length;i++){
				var item=dimensionsArray[i];
				var name=item[0];
				var desc=item[1];
				var type=item[2];
				if(desc==''){
					desc='-';
				}
				var htmlItem='<tr><td><var>'+name+'</var></td><td>'+desc+'</td><td><span class="label '+type+'">'+type+'</span></td></tr>';
				htmlContent+=htmlItem;
			}
			$('#dimensions-body').html(htmlContent);
			
			//process measures measures-body
			var measuresArray=apiInfoObject.measures;
			var htmlContent="";
			
			for(var i=0;i<measuresArray.length;i++){
				var item=measuresArray[i];
				var name=item[0];
				var desc=item[1];
				var type=item[2];
				if(desc==''){
					desc='-';
				}
				var htmlItem='<tr><td><var>'+name+'</var></td><td>'+desc+'</td><td><span class="label '+type+'">'+type+'</span></td></tr>';
				htmlContent+=htmlItem;
			}
			$('#measures-body').html(htmlContent);	
			//process constraints constrains-body
			var constraintsArray=apiInfoObject.contraints;
			var htmlContent="";
			
			for(var i=0;i<constraintsArray.length;i++){
				var item=constraintsArray[i];
				var parameter=item[0];
				var type=item[1];
				var exampleValue=item[2];
				var htmlItem='<tr><td><var>'+parameter+'</var></td><td><span class="label '+type+'">'+type+'</span></td><td><code>'+exampleValue+'</code></td></tr>';
				htmlContent+=htmlItem;
			}
			$('#constrains-body').html(htmlContent);			
		}
		$( document ).ready(function() {
			//load api info object
			var url="";
			if(api=='advertiserByDate'){
				url+="AdvertiserByDate?info";
			}else if(api=='revenueByHour'){
				url+="revenueByHour?info";
			}else if(api=='lookup_orders'){
				url+="LookupOrders?info";
			}else{
				url+=api+"?info";				
			}
			$.ajax({
			  dataType: "json",
			  url: url,
			  success: function(data){
				apiInfoObject=data;
				processApiInfo(apiInfoObject);
				$('.apiReviewExample').click(function(event){
					event.preventDefault();
					var item=$(this);
					var url=item.attr('href');
					$('#exampleInputUrl').val(url);
					//show modal
					$('#myModal').modal('show');
					sendApiRequest();
					//Add click event
					$('#sendRequestBt').click(function(){						
						sendApiRequest();
					});
				});
			  }
			});
			
			
		});
		function sendApiRequest(){
			var url = $('input[name=exampleInputUrl]').val();
			if(apiRequest!=null){
				apiRequest.abort();
			}
			$('#apiResult').html("Loading...");
			$('#sqlQuery').html("");
			url=url+"\&getQuery=true";
			console.log(url);
			//send request
			apiRequest=$.getJSON(url).done(function(data){
				$('#sqlQuery').html(data.sqlQuery);
				delete data.sqlQuery;
				$('#apiResult').html(library.json.prettyPrint(data));
			});
		}
		$('#apiSubmitForm').submit(function(event){
			event.preventDefault();
			sendApiRequest();
			return false;
		});
		if (!library)
			   var library = {};

			library.json = {
			   replacer: function(match, pIndent, pKey, pVal, pEnd) {
			      var key = '<span class=json-key>';
			      var val = '<span class=json-value>';
			      var str = '<span class=json-string>';
			      var r = pIndent || '';
			      if (pKey)
			         r = r + key + pKey.replace(/[": ]/g, '') + '</span>: ';
			      if (pVal)
			         r = r + (pVal[0] == '"' ? str : val) + pVal + '</span>';
			      return r + (pEnd || '');
			      },
			   prettyPrint: function(obj) {
			      var jsonLine = /^( *)("[\w]+": )?("[^"]*"|[\w.+-]*)?([,[{])?$/mg;
			      return JSON.stringify(obj, null, 3)
			         .replace(/&/g, '&amp;').replace(/\\"/g, '&quot;')
			         .replace(/</g, '&lt;').replace(/>/g, '&gt;')
			         .replace(jsonLine, library.json.replacer);
			      }
			   };

	  </script>

   </body>
</html>