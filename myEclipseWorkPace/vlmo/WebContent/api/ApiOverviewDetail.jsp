<!DOCTYPE html>
<html>
   <head>
      <meta charset='utf-8'>
      <meta content='IE=edge,chrome=1' http-equiv='X-UA-Compatible'>
      <meta content='Verve Mobile, Inc' name='author'>
      <meta content='Local mobile ad network and publishing platform serving local media around the globe.' name='description'>
      <meta content='width=device-width, initial-scale=1.0' name='viewport'>
      <meta content='Local, Mobile, ad network, technology platform, mobile apps, mobile web sites, iPhone, Nokia, BlackBerry, Android, News, Local News, iPad' name='keywords'>
      <meta content='Copyright Verve Mobile, All Rights Reserved.' name='copyright'>
      <link href='http://d2ylcatjgg04jf.cloudfront.net/assets/favicon-11eed6f979e83f15f89b948edd8b4245.ico' rel='shortcut icon'>
      <title>Verve Reporting API</title>
      <meta content="authenticity_token" name="csrf-param" />
      <meta content="Ffi5oJhiKei0VEUzQzm3mErTcIyOYlbE/+rIbvfvNkU=" name="csrf-token" />
      <link href="http://d2ylcatjgg04jf.cloudfront.net/assets/application-03f1f31be53c1a4ba4dc0cc5b19a6c2a.css" media="all" rel="stylesheet" type="text/css" />
      <script src="http://d2ylcatjgg04jf.cloudfront.net/assets/application-1fd2757121ac42f35995dc474b2d6cc1.js" type="text/javascript"></script>
   </head>
   <body class='reports' id='top'>
      <nav class='navbar navbar-inverse navbar-fixed-top'>
         <div class='navbar-inner'>
            <div class='container'>
               <a href="/" class="brand"><img alt="Logo" class="pull-left" src="http://d2ylcatjgg04jf.cloudfront.net/assets/logo-c047c79627f72fa225bf33c5b561484d.png" />
               </a><a class='btn btn-navbar' data-target='.nav-collapse' data-toggle='collapse'>
               <span class='icon-bar'></span>
               <span class='icon-bar'></span>
               <span class='icon-bar'></span>
               </a>
               <div class='nav-collapse'>
                  <ul class='nav'>
                     <li><a href="ApiOverview">API Overview</a></li>
                  </ul>
                  <ul class='nav pull-right' style="display:none">
                     <li class='dropdown'>
                        <a class='dropdown-toggle' data-toggle='dropdown' href='#'>
                        chinh.nguyen@vervemobile.com
                        <b class='caret'></b>
                        </a>
                        <ul class='dropdown-menu'>
                           <li>
                              <a href="/sign_out" class="" data-confirm="Are you really sure?" data-method="delete" rel="nofollow"><i class='icon-off'></i>
                              Sign Out
                              </a>
                           </li>
                        </ul>
                     </li>
                  </ul>
               </div>
            </div>
         </div>
      </nav>
      <div class='container'>
         <div class='content'>
            <nav>
               <ul class='breadcrumb'>
                  <li>
                     <a href="ApiOverview">API Overview</a>
                     <span class='divider'>/</span>
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
               <li><a href="#lookups" data-toggle="tab">Lookups</a></li>
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
                        Constraints to apply; Default: <var>full_date=[currentDate-1]</var>
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
         <footer></footer>
      </div>
	  <script>
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
			$('#apiUrl').html(apiInfoObject.apiUrl);
			//Process selectExample
			var htmlContent="";
			var selectExampleArray=apiInfoObject.selectExample;
			for(var i=0;i<selectExampleArray.length;i++){
				if(i>0){
					htmlContent+="&#x000A;";
				}
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
			var url="/AdvertiserDashboard/api/";
			if(api=="adcel"){
				url+="AdCel?info";
			}if(api=='creativesByHour'){
				url+="AdvertiserCreativesByHour?info";
			}
			$.ajax({
			  dataType: "json",
			  url: url,
			  success: function(data){
				apiInfoObject=data;
				processApiInfo(apiInfoObject);
			  }
			});
		});
		

	  </script>
   </body>
</html>