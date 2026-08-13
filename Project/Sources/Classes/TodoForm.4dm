property userId : Integer
property selectedTodo : cs.TodoEntity
property todos : cs.TodoSelection
property progressLabel : Text
property progress : Integer
property search : Text
property onlyMyTodos : Integer
property onlyTodayTodos : Integer
property onlyCreatedTodos : Integer
property allTodos : Integer
property onlyOpen : Integer


Class constructor($userId : Integer)
	This.userId:=$userId
	This.reload()
	This.onlyMyTodos:=1
	//This.onlyTodayTodos:=1
	This.onlyOpen:=1
	
	
Function reload()
	This.filter()
	
	
Function filter()
	var $keywords : Collection
	var $filters : Collection
	var $orFilter : Collection
	var $result : cs.TodoSelection
	var $total; $achieved : Integer
	var $x1; $x2; $y1; $y2 : Real
	
	$filters:=[]
	$keywords:=Split string(String(This.search); " "; sk ignore empty strings)
	$keywords:=$keywords.map(Formula("@"+$1.value+"@"))
	$result:=ds.Todo.all()
	$settings:={parameters: {}}
	$settings.parameters.keywords:=$keywords
	$settings.parameters.assigned_to:=This.userId
	$settings.parameters.due_date:=Current date()
	$settings.parameters.created_by:=This.userId
	
	If ($keywords.length>0)
		
		$orFilter:=[]
		$orFilter.push("(label in :keywords")
		$orFilter.push("assignee.Nom in :keywords")
		$orFilter.push("patient.Nom in :keywords")
		$orFilter.push("patient.Prénom in :keywords)")
		$filters.push($orFilter.join(" OR "))
		
	End if 
	
	If (Bool(This.onlyMyTodos))
		$filters.push("assigned_to = :assigned_to")
	Else 
		If (Bool(This.onlyCreatedTodos))
			$filters.push("created_by = :created_by")
		End if 
	End if 
	
	If (Bool(This.onlyTodayTodos))
		$filters.push("due_date = :due_date")
	End if 
	
	If (Not(Bool(This.onlyOpen)))
		$filters.push("completed_at = null")
	End if 
	
	If ($filters.length>0)
		This.todos:=$result.query($filters.join(" AND ")+" order By completed_at, due_date"; $settings)
	Else 
		This.todos:=ds.Todo.all()
	End if 
	
	$total:=This.todos.length
	If ($total=0)
		This.progress:=0
		This.progressLabel:="0 / 0"
	Else 
		$achieved:=This.todos.query("completed_at # null").length
		This.progress:=$achieved/$total
		This.progressLabel:=[$achieved; $total].join(" / ")
	End if 
	
	OBJECT GET COORDINATES(*; "progress"; $x1; $y1; $x2; $y2)
	$x2:=$x1+(198*This.progress)
	If (($x2-$x1)<28)
		$x2:=$x1+28
	End if 
	OBJECT SET COORDINATES(*; "progress"; $x1; $y1; $x2; $y2)
	
	
Function completeTask()
	If (This.selectedTodo#Null)
		If ((This.selectedTodo.completed_at=Null) & ((This.selectedTodo.assigned_to=This.userId) | (This.selectedTodo.created_by=This.userId)))
			This.selectedTodo.completed_at:=cs.Timestamp.me.now()
			This.selectedTodo.save()
			This.reload()
		End if 
		
	End if 
	
	
Function reopenTask()
	If (This.selectedTodo#Null)
		If ((This.selectedTodo.completed_at#Null) & ((This.selectedTodo.assigned_to=This.userId) | (This.selectedTodo.created_by=This.userId)))
			This.selectedTodo.completed_at:=Null
			This.selectedTodo.save()
			This.reload()
		End if 
	End if 
	
	
Function editTask()
	var $todo : cs.TodoEntity
	var $x1; $y1; $x2; $y2 : Real
	
	If (This.selectedTodo#Null)
		$todo:=ds.Todo.get(This.selectedTodo.ID)
		If ($todo#Null)
			OBJECT GET COORDINATES(*; "btnAdd"; $x1; $y1; $x2; $y2)
			CONVERT COORDINATES($x2; $y2; XY Current form; XY Main window)
			cs.NewTodoForm.new(This.userId; $todo).dialog($x2-532; $y2)
			This.reload()
		End if 
	End if 
	
	
Function dialog()
	var $window : Integer
	var $user : cs.UtilisateurEntity
	
	$user:=ds.Utilisateur.get(This.userId)
	$window:=Open form window("Form1"; Movable form dialog box)
	SET WINDOW TITLE([String($user.Nom); "Gestion des tâches"].join(" : "; ck ignore null or empty); $window)
	DIALOG("Form1"; This)
	CLOSE WINDOW($window)
	
	
Function handleEvents()
	
	Case of 
		: (Form event code=On Load)
			This.reload()
			
		: (Form event code=On Clicked)
			
			Case of 
				: (FORM Event.objectName="btnAdd")
					//462
					//371
					OBJECT GET COORDINATES(*; "btnAdd"; $x1; $y1; $x2; $y2)
					CONVERT COORDINATES($x2; $y2; XY Current form; XY Main window)
					cs.NewTodoForm.new(This.userId).dialog($x2-532; $y2)
					This.reload()
					
					
				: (FORM Event.objectName="lbTodos")
					This.editTask()
					
					
				: (FORM Event.objectName="rdo@") || (FORM Event.objectName="chk@")
					This.filter()
					
					
			End case 
			
			
		: (Form event code=On Data Change)
			
			Case of 
				: (FORM Event.objectName="inputSearch")
					This.filter()
					
					
					
			End case 
			
	End case 
	