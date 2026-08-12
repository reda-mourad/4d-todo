//%attributes = {}
var $user1; $user2; $user3; $assignee : cs.UtilisateurEntity
var $patients : cs.PatientSelection
var $todo : cs.TodoEntity
var $category; $randomCategory : cs.TodoCategoryEntity
var $categories : cs.TodoCategorySelection
var $todoCategoryLink : cs.TodoCategoriesEntity
var $label : Text
var $categoryLabels; $selectedCategoryIDs; $todoLabels; $assignees : Collection
var $categoriesToAssign : Integer
var $i : Integer

ds.Todo.all().drop()
ds.TodoCategories.all().drop()
ds.TodoCategory.all().drop()

ds.Patient.fromCollection(JSON Parse(Folder(fk desktop folder).file("patients.json").getText()))
ds.Utilisateur.fromCollection(JSON Parse(Folder(fk desktop folder).file("users.json").getText()))

$categoryLabels:=New collection("Urgent"; "Suivi"; "Médication"; "Administratif"; "Thérapie"; "Sortie")
For each ($label; $categoryLabels)
	$category:=ds.TodoCategory.new()
	$category.label:=$label
	$category.save()
End for each 

$user1:=ds.Utilisateur.get(15)
$user2:=ds.Utilisateur.get(17)
$user3:=ds.Utilisateur.get(12)
$patients:=ds.Patient.all()
$categories:=ds.TodoCategory.all()
$assignees:=New collection($user1; $user2; $user3)

$todoLabels:=New collection(\
"Vérifier le programme des médicaments"; \
"Confirmer le rendez-vous de suivi"; \
"Mettre à jour les notes de soins"; \
"Appeler la famille avec le résumé de sortie"; \
"Vérifier les résultats de laboratoire"; \
"Préparer la liste de thérapie"; \
"Revoir le plan de gestion de la douleur"; \
"Planifier la séance de rééducation"; \
"Vérifier les documents d’assurance"; \
"Discuter les options de traitement"; \
"Préparer les consignes de sortie"; \
"Confirmer la prochaine visite"\
)

For ($i; 1; 20)
	$todo:=ds.Todo.new()
	$todo.label:=$todoLabels.at(Random%$todoLabels.length)
	$todo.patient_id:=$patients.at(Random%$patients.length).NoDossier
	$todo.created_at:=cs.Timestamp.me.now()
	$todo.created_by:=$assignees.at(Random%$assignees.length).xNumUser
	$todo.due_date:=Current date+(Random%11)
	$assignee:=$assignees.at(Random%$assignees.length)
	$todo.assigned_to:=$assignee.xNumUser
	$todo.save()
	
	$categoriesToAssign:=1+(Random%3)
	$selectedCategoryIDs:=New collection
	Repeat 
		$randomCategory:=$categories.at(Random%$categories.length)
		If ($selectedCategoryIDs.indexOf($randomCategory.ID)=-1)
			$selectedCategoryIDs.push($randomCategory.ID)
			$todoCategoryLink:=ds.TodoCategories.new()
			$todoCategoryLink.todo_id:=$todo.ID
			$todoCategoryLink.category_id:=$randomCategory.ID
			$todoCategoryLink.save()
		End if 
	Until ($selectedCategoryIDs.length=$categoriesToAssign)
End for