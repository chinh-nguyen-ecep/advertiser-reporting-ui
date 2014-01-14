<?php
$dbhost = 'localhost';
$dbuser = 'deplao_admin';
$dbpass = 'adminsanchikaro';
$dbname= 'deplao_buxto';
$username=$_GET['username'];
$lastview=$_GET['lastview'];
$directFollowers=$_GET['directFollowers'];
$followers=$_GET['followers'];
$followersWebsiteVisits=$_GET['followersWebsiteVisits'];
$accountBalance=$_GET['accountBalance'];
$totalAmountPaid=$_GET['totalAmountPaid'];
$ip=$_SERVER["REMOTE_ADDR"];
$proxy=$_GET['proxy'];
$port=$_GET['port'];

//$conn = mysql_connect($dbhost, $dbuser, $dbpass,$dbname);
$conn =mysqli_connect($dbhost, $dbuser, $dbpass, $dbname) or die ("could not connect to mysql"); 
//mysqli_select_db("$dbname") or die ("no database"); 
// Check connection
if (mysqli_connect_errno($conn))
  {
  echo "Failed to connect to MySQL: " . mysqli_connect_error();
  }

//update account
$sql="INSERT INTO daily_log(date,username,lastview,directFollowers,followers,followersWebsiteVisits,accountBalance,totalAmountPaid,ip,proxy,port)";
$sql=$sql." VALUES (null,'".$username."',".$lastview.",".$directFollowers.",".$followers.",".$followersWebsiteVisits.",'".$accountBalance."','".$totalAmountPaid."','".$ip."','".$proxy."','".$port."')";
echo $sql;
mysqli_query($conn,$sql);
mysql_close($conn);
?>