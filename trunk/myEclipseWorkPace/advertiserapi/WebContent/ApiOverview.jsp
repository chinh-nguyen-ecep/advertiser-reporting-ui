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
      <link href='images/verve-icon.ico' rel='shortcut icon'>
      <title>Advertiser API</title>
      <meta content="authenticity_token" name="csrf-param" />
      <meta content="Ffi5oJhiKei0VEUzQzm3mErTcIyOYlbE/+rIbvfvNkU=" name="csrf-token" />
      <link href="css/web.css" media="all" rel="stylesheet" type="text/css" />
      <script src="js/web.js" type="text/javascript"></script>
   </head>
   <body class='reports' id='top'>
      <nav class='navbar navbar-inverse navbar-fixed-top'>
         <div class='navbar-inner'>
            <div class='container'>
               <a href="/" class="brand"><img alt="Logo" class="pull-left" src="images/verve_logo.png" />
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
                  <li class='active'>API Overview</li>
               </ul>
            </nav>
            <table class='table table-bordered'> 
               <tr>
                  <th colspan='2'>Advertiser Reports</th>
               </tr>
               <tr>
                  <td><a href="ApiOverviewDetail?api=advertiserByDate">Advertiser by Date</a></td>
                  <td>overview-internal</td>
               </tr> 
               <tr>
                  <td><a href="ApiOverviewDetail?api=advertiserByHour">Advertiser by Hour</a></td>
                  <td>overview-internal</td>
               </tr> 
               <tr>
                  <td><a href="ApiOverviewDetail?api=advertiserByDistance">Advertiser by Distance</a></td>
                  <td>overview-internal</td>
               </tr> 			   
            </table>
            <nav>
               <ul class='breadcrumb'>
                  <li class='active'>Dimension Lookup</li>
               </ul>
            </nav>
            <table class='table table-bordered'> 
               <tr>
                  <td><a href="ApiOverviewDetail?api=lookup_orders">Orders</a></td>
                  <td>overview-internal</td>
               </tr> 
               <tr>
                  <td><a href="ApiOverviewDetail?api=lookup_flights">Flights</a></td>
                  <td>overview-internal</td>
               </tr> 
               <tr>
                  <td><a href="ApiOverviewDetail?api=lookup_creatives">Creatives</a></td>
                  <td>overview-internal</td>
               </tr> 			   
            </table>
         </div>
         <footer></footer>
      </div>
   </body>
</html>

<script>
function callbackParent(){
	console.log('callbackParent called...');
}
callbackParent();
</script>