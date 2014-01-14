<?php
echo "Hello <br/>";
$dbhost = 'localhost';
$dbuser = 'deplao_admin';
$dbpass = 'adminsanchikaro';
$username=$_GET['user'];
$pass=$_GET['pass'];

echo $username.'<br/>';
echo $pass.'<br/>';

$conn = mysql_connect($dbhost, $dbuser, $dbpass,'deplao_buxto');
if(! $conn )
{
  die('Could not connect: ' . mysql_error());
}
$sql = 'SELECT COUNT( 1 ) as count FROM  accounts WHERE name =  \''.$username.'\'';
echo "query: ".$sql."<br />";
$result = mysqli_query($conn,$sql);
while($row = mysqli_fetch_array($result))
  {
  echo "The count: ".$row[0];
  echo "<br>";
  }

mysql_close($conn);
?>