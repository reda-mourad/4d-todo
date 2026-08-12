shared singleton Class constructor()
	// Intentionally empty
	
	
shared Function stampToDate($stamp : Integer)->$date : Date
	$date:=!1970-01-01!+Int($stamp/86400)
	
	
shared Function stampToTime($stmap : Integer)->$time : Time
	var $seconds : Integer
	$seconds:=$stmap%86400
	$time:=$seconds
	
	
shared Function now()->$stamp : Integer
	$stamp:=This.buildStamp(Current date; Current time)
	
	
shared Function buildStamp($date : Date; $time : Time)->$stamp : Integer
	$stamp:=($date-!1970-01-01!)*86400+$time