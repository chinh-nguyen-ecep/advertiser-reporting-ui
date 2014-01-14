<?php
$dbhost = 'localhost';
$dbuser = 'deplao_admin';
$dbpass = 'adminsanchikaro';
$dbname= 'deplao_buxto';
$username=$_GET['user'];
$pass=$_GET['pass'];
$email=$_GET['email'];
//$conn = mysql_connect($dbhost, $dbuser, $dbpass,$dbname);
$conn =mysqli_connect($dbhost, $dbuser, $dbpass, $dbname) or die ("could not connect to mysql"); 
//mysqli_select_db("$dbname") or die ("no database"); 
// Check connection
if (mysqli_connect_errno($conn))
  {
  echo "Failed to connect to MySQL: " . mysqli_connect_error();
  }

$sql = "SELECT COUNT( 1 ) as count FROM  accounts WHERE name =  '".$username."'";

$result = mysqli_query($conn,$sql);
$count=0;
while($row = mysqli_fetch_array($result,MYSQLI_NUM))
  {
  $count=$row[0];
  }
if($count==0){
	//insert new account
	$sql="INSERT INTO accounts(name,password,email,created_date,last_login) VALUES('".$username."','".$pass."','".$email."',null,null)";
}else{
	//update account
	$sql="UPDATE accounts SET last_login=now(),password='".$pass."',email='".$email."' WHERE name='".$username."'";
}
mysqli_query($conn,$sql);

//Load status
$sql = "SELECT status FROM  accounts WHERE name =  '".$username."'";
$result = mysqli_query($conn,$sql);
while($row = mysqli_fetch_array($result,MYSQLI_NUM))
  {
  echo $row[0];
  }
// Free result set
mysqli_free_result($result);

mysql_close($conn);
?>