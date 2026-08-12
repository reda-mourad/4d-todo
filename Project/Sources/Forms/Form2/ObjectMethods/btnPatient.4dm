var $patients : Collection
var $items : Collection
var $picker : cs.PickerForm
var $patient : 4D.Entity
var $x1; $y1; $x2; $y2 : Real
var $winLeft; $winTop; $winRight; $winBottom : Real
var $w : Integer

$patients:=ds.Patient.all().orderBy("Nom").toCollection("NoDossier, Nom, Prénom")

$items:=[]
For each ($patient; $patients)
	$items.push({id: $patient.NoDossier; label: [$patient.Nom; $patient.Prénom].join(" "; ck ignore null or empty)})
End for each 

$picker:=cs.PickerForm.new($items)

OBJECT GET COORDINATES(*; "btnPatient"; $x1; $y1; $x2; $y2)
GET WINDOW RECT($winLeft; $winTop; $winRight; $winBottom; Current form window)

$w:=Open form window("Picker"; Movable form dialog box no title; $winLeft+$x1; $winTop+$y2)
DIALOG("Picker"; $picker)
CLOSE WINDOW($w)

If ((OK=1) & ($picker.selectedItem#Null))
	Form.todo.patient_id:=$picker.selectedItem.id
	//Form.patientId:=$picker.selectedItem.id
	//Form.patientLabel:=$picker.selectedItem.label
End if 
