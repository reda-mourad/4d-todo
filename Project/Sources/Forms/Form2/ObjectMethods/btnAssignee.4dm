var $users : Collection
var $items : Collection
var $picker : cs.PickerForm
var $user : 4D.Entity
var $x1; $y1; $x2; $y2 : Real
var $winLeft; $winTop; $winRight; $winBottom : Real
var $w : Integer

$users:=ds.Utilisateur.all().orderBy("Nom").toCollection("xNumUser, Nom")

$items:=[]
For each ($user; $users)
	$items.push({id: $user.xNumUser; label: $user.Nom})
End for each 

$picker:=cs.PickerForm.new($items)

OBJECT GET COORDINATES(*; "btnAssignee"; $x1; $y1; $x2; $y2)
GET WINDOW RECT($winLeft; $winTop; $winRight; $winBottom; Current form window)

$w:=Open form window("Picker"; Movable form dialog box no title; $winLeft+$x1; $winTop+$y2)
DIALOG("Picker"; $picker)
CLOSE WINDOW($w)

If ((OK=1) & ($picker.selectedItem#Null))
	Form.todo.assigned_to:=$picker.selectedItem.id
	//Form.assigneeId:=$picker.selectedItem.id
	//Form.assigneeLabel:=$picker.selectedItem.label
End if 
