var $category : cs.TodoCategoryEntity
var $todoCategory : cs.TodoCategoriesEntity
var $oldLinks : cs.TodoCategoriesSelection
var $todo : cs.TodoEntity

If (Not(Form.canEdit))
	CANCEL
	Return
End if 

If (Form.isEditing)
	$todo:=ds.Todo.get(Form.todo.ID)
	If ($todo=Null)
		CANCEL
		Return
	End if 
	If (($todo.created_by#Form.userId) & ($todo.assigned_to#Form.userId))
		CANCEL
		Return
	End if 
	If ($todo.completed_at#Null)
		CANCEL
		Return
	End if 
Else 
	Form.todo.created_at:=cs.Timestamp.me.now()
	Form.todo.created_by:=Form.userId
End if 

Form.todo.due_date:=Date(Form.due_date)
Form.todo.save()

If (Form.isEditing)
	$oldLinks:=ds.TodoCategories.query("todo_id = :1"; Form.todo.ID)
	$oldLinks.drop()
End if 

For each ($category; Form.selectedCategories)
	
	$todoCategory:=ds.TodoCategories.new()
	$todoCategory.category_id:=$category.ID
	$todoCategory.todo_id:=Form.todo.ID
	$todoCategory.save()
	
End for each 

ACCEPT