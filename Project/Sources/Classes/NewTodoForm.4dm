property todo : cs.TodoEntity
property userId : Integer
property categories : cs.TodoCategorySelection
property selectedCategories : cs.TodoCategorySelection
property due_date : Date
property isEditing : Boolean
property canEdit : Boolean
property completedAtLabel : Text
property canToggleClose : Boolean
property closeButtonLabel : Text


Class constructor($userId : Integer; $todo : cs.TodoEntity)
	var $todoCategory : cs.TodoCategoriesEntity
	var $categoryIDs : Collection
	
	This.userId:=$userId
	This.categories:=ds.TodoCategory.all()
	
	If ($todo#Null)
		This.todo:=ds.Todo.get($todo.ID)
		$categoryIDs:=[]
		For each ($todoCategory; This.todo.todoCategories)
			$categoryIDs.push($todoCategory.category_id)
		End for each 
		If ($categoryIDs.length>0)
			This.selectedCategories:=This.categories.query("ID in :1"; $categoryIDs)
		Else 
			This.selectedCategories:=This.categories.query("ID = :1"; -1)
		End if 
		This.due_date:=This.todo.due_date
		This.isEditing:=True
		This.canEdit:=((This.todo.created_by=This.userId) & (This.todo.completed_at=Null))
		This.canToggleClose:=((This.todo.assigned_to=This.userId) | (This.todo.created_by=This.userId))
		This.closeButtonLabel:=This.todo.completed_at=Null ? "✔️ Clôturer" : "↩️ Rouvrir"
		This.completedAtLabel:=This.todo.completed_at ? [String(cs.Timestamp.me.stampToDate(This.todo.completed_at)); String(cs.Timestamp.me.stampToTime(This.todo.completed_at))].join(" - ") : ""
	Else 
		This.todo:=ds.Todo.new()
		This.selectedCategories:=This.categories.query("ID = :1"; -1)
		This.due_date:=Current date
		This.isEditing:=False
		This.canEdit:=True
		This.canToggleClose:=False
		This.closeButtonLabel:="✔️ Clôturer"
		This.completedAtLabel:=""
	End if 
	
	
Function dialog($x : Integer; $y : Integer)
	var $window : Integer
	$window:=Open form window("Form2"; Movable form dialog box no title; $x; $y)
	DIALOG("Form2"; This)
	CLOSE WINDOW($window)